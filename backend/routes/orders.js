const express = require("express");
const router = express.Router();

// Placeholder routes for orders
router.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Orders endpoint",
    data: [],
  });
});

module.exports = router;
