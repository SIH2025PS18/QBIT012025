const express = require("express");
const router = express.Router();

// Placeholder routes for video calls
router.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Video calls endpoint",
    data: [],
  });
});

module.exports = router;
