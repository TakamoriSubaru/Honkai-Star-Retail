const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  const header = req.headers["authorization"];

  if (!header) {
    return res.json({ message: "Access denied. No token provided." });
  }

  const token = header.split(" ")[1];

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified; // attach user info to request
    next();
  } catch (err) {
    res.json({ message: "Invalid token" });
  }
};

module.exports = verifyToken;