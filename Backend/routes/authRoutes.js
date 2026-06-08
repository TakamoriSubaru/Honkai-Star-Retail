const express = require("express");
const router = express.Router();
const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const authMiddleware = require("../middleware/authMiddleware");
const checkRole = require("../middleware/roleMiddleware");


// ================= REGISTER =================
router.post("/register", async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.json({ message: "All fields are required" });
  }

  db.query("SELECT * FROM users WHERE email = ?", [email], async (err, result) => {
    if (result.length > 0) {
      return res.json({ message: "Email already registered" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    db.query(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')",
      [name, email, hashedPassword],
      (err) => {
        if (err) return res.json(err);
        res.json({ message: "User registered successfully" });
      }
    );
  });
});


// ================= LOGIN =================
router.post("/login", (req, res) => {
  const { email, password } = req.body;

  db.query("SELECT * FROM users WHERE email = ?", [email], async (err, result) => {
    if (result.length === 0) {
      return res.json({ message: "Email not found" });
    }

    const user = result[0];

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.json({ message: "Wrong password" });
    }

    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.json({
      message: "Login successful",
      token: token,
      user: {
        id: user.id,
        name: user.name,
        role: user.role
      }
    });
  });
});


// ================= PROTECTED TEST =================
router.get("/protected", authMiddleware, (req, res) => {
  res.json({
    message: "You accessed protected route!",
    user: req.user
  });
});


// ================= ADMIN ONLY =================
router.get(
  "/admin",
  authMiddleware,
  checkRole("admin"),
  (req, res) => {
    res.json({ message: "Welcome Admin 👑" });
  }
);

// ================= GOOGLE OAUTH =================
router.post("/oauth", (req, res) => {
  const { email, name } = req.body;

  if (!email || !name) {
    return res.status(400).json({ message: "OAuth data incomplete." });
  }

  // Check if user already exists
  db.query("SELECT * FROM users WHERE email = ?", [email], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });

    if (results.length > 0) {
      // User exists — just issue a token
      const user = results[0];
      const token = jwt.sign(
        { id: user.id, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: "1d" }
      );
      return res.json({
        message: "OAuth login successful!",
        token,
        user: { id: user.id, name: user.name, role: user.role }
      });
    }

    // New user — create account automatically
    const dummyPassword = require("bcrypt").hashSync(
      Math.random().toString(36),
      10
    );

    db.query(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')",
      [name, email, dummyPassword],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });

        const token = jwt.sign(
          { id: result.insertId, role: "user" },
          process.env.JWT_SECRET,
          { expiresIn: "1d" }
        );

        res.status(201).json({
          message: "OAuth account created!",
          token,
          user: { id: result.insertId, name, role: "user" }
        });
      }
    );
  });
});

module.exports = router;