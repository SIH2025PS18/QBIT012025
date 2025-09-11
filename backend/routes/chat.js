const express = require("express");
const router = express.Router();

// Placeholder routes for chat
router.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Chat endpoint",
    data: [],
  });
});

module.exports = router;
