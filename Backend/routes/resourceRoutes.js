const express = require("express");
const router = express.Router();
const db = require("../config/db");
const upload = require("../middleware/upload");
const authMiddleware = require("../middleware/authMiddleware");
const checkRole = require("../middleware/roleMiddleware");

// ================= GET ALL RESOURCES (PUBLIC) =================
router.get("/", (req, res) => {
  db.query("SELECT * FROM resources", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
});

// ================= GET SINGLE RESOURCE (PUBLIC) =================
router.get("/:id", (req, res) => {
  db.query(
    "SELECT * FROM resources WHERE id = ?",
    [req.params.id],
    (err, result) => {
      if (err) return res.status(500).json(err);

      if (result.length === 0) {
        return res.status(404).json({ message: "Resource not found" });
      }

      res.json(result[0]);
    }
  );
});

// ================= CREATE RESOURCE (ADMIN ONLY) =================
router.post("/", authMiddleware, checkRole("admin"), (req, res) => {
  const { name, type, description, stock, image, price } = req.body;

  db.query(
    "INSERT INTO resources (name, type, description, stock, image, price) VALUES (?, ?, ?, ?, ?, ?)",
    [name, type, description, stock, image, price],
    (err) => {
      if (err) return res.status(500).json(err);

      res.json({ message: "Resource created successfully" });
    }
  );
});

// ================= UPDATE RESOURCE (ADMIN ONLY) =================
router.put("/:id", authMiddleware, checkRole("admin"), (req, res) => {
  const { name, type, description, stock, image, price } = req.body;

  db.query(
    `UPDATE resources 
     SET name=?, type=?, description=?, stock=?, image=?, price=? 
     WHERE id=?`,
    [name, type, description, stock, image, price, req.params.id],
    (err) => {
      if (err) return res.status(500).json(err);

      res.json({ message: "Resource updated successfully" });
    }
  );
});

// ================= DELETE RESOURCE (ADMIN ONLY) =================
router.delete("/:id", authMiddleware, checkRole("admin"), (req, res) => {
  db.query(
    "DELETE FROM resources WHERE id = ?",
    [req.params.id],
    (err) => {
      if (err) return res.status(500).json(err);

      res.json({ message: "Resource deleted successfully" });
    }
  );
});

// ================= UPLOAD IMAGE (ADMIN ONLY) =================
router.post("/upload", authMiddleware, checkRole("admin"), upload.single("image"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded." });
  }

  res.json({
    message: "Image uploaded successfully!",
    filename: req.file.filename,
    url: `http://localhost:3000/uploads/${req.file.filename}`
  });
});

module.exports = router;