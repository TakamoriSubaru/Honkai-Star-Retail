const express = require("express");
const router = express.Router();
const db = require("../config/db");
const verifyToken = require("../middleware/authMiddleware");

// ================= BUY RESOURCE =================
// POST /api/transactions/buy
router.post("/buy", verifyToken, (req, res) => {
  const { resource_id, quantity } = req.body;
  const user_id = req.user.id;

  // --- Validation ---
  if (!resource_id || !quantity || quantity < 1) {
    return res.status(400).json({ message: "resource_id and quantity (min 1) are required." });
  }

  // --- Step 1: Get resource ---
  db.query("SELECT * FROM resources WHERE id = ?", [resource_id], (err, results) => {
    if (err) return res.status(500).json({ message: "DB error", error: err });
    if (results.length === 0) return res.status(404).json({ message: "Resource not found." });

    const resource = results[0];

    // --- Step 2: Check stock ---
    if (resource.stock < quantity) {
      return res.status(400).json({
        message: `Not enough stock. Available: ${resource.stock}`,
      });
    }

    const total_price = resource.price * quantity;

    // --- Step 3: Deduct stock + insert transaction (atomic) ---
    db.beginTransaction((err) => {
      if (err) return res.status(500).json({ message: "Transaction start failed", error: err });

      // Deduct stock
      db.query(
        "UPDATE resources SET stock = stock - ? WHERE id = ?",
        [quantity, resource_id],
        (err) => {
          if (err) {
            return db.rollback(() =>
              res.status(500).json({ message: "Stock update failed", error: err })
            );
          }

          // Insert transaction
          db.query(
            "INSERT INTO transactions (user_id, resource_id, quantity, total_price) VALUES (?, ?, ?, ?)",
            [user_id, resource_id, quantity, total_price],
            (err, result) => {
              if (err) {
                return db.rollback(() =>
                  res.status(500).json({ message: "Transaction insert failed", error: err })
                );
              }

              // Commit
              db.commit((err) => {
                if (err) {
                  return db.rollback(() =>
                    res.status(500).json({ message: "Commit failed", error: err })
                  );
                }

                res.status(201).json({
                  message: "Purchase successful!",
                  transaction: {
                    id: result.insertId,
                    user_id,
                    resource_id,
                    quantity,
                    total_price,
                  },
                });
              });
            }
          );
        }
      );
    });
  });
});

// ================= TRANSACTION HISTORY =================
// GET /api/transactions
router.get("/", verifyToken, (req, res) => {
  const user_id = req.user.id;

  db.query(
    `SELECT t.id, t.quantity, t.total_price, t.created_at,
            r.name, r.type, r.image, r.price
     FROM transactions t
     JOIN resources r ON t.resource_id = r.id
     WHERE t.user_id = ?
     ORDER BY t.created_at DESC`,
    [user_id],
    (err, results) => {
      if (err) return res.status(500).json({ message: "DB error", error: err });
      res.json(results);
    }
  );
});

// ================= ALL TRANSACTIONS (ADMIN ONLY) =================
// GET /api/transactions/all
router.get("/all", verifyToken, (req, res) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ message: "Access denied. Admins only." });
  }

  db.query(
    `SELECT t.id, t.quantity, t.total_price, t.created_at,
            u.name AS user_name, u.email,
            r.name AS resource_name, r.type, r.image, r.price
     FROM transactions t
     JOIN users u ON t.user_id = u.id
     JOIN resources r ON t.resource_id = r.id
     ORDER BY t.created_at DESC`,
    (err, results) => {
      if (err) return res.status(500).json({ message: "DB error", error: err });
      res.json(results);
    }
  );
});

module.exports = router;