console.log("RESOURCE ROUTES FILE LOADED");

require("dotenv").config();
const express = require("express");
const cors = require("cors");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use("/uploads", express.static("uploads"));

// DB connection
require("./config/db");

// ================= ROUTES =================
const authRoutes = require("./routes/authRoutes");
const resourceRoutes = require("./routes/resourceRoutes");
const transactionRoutes = require("./routes/transactionRoutes");

// Mount routes
app.use("/api", authRoutes);
app.use("/api/resources", resourceRoutes);
app.use("/api/transactions", transactionRoutes);

// ================= TEST ROUTE =================
app.get("/", (req, res) => {
  res.send("API is running...");
});

// ================= START SERVER =================
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});