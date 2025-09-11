const express = require("express");
const router = express.Router();

// Placeholder routes for queue management
router.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Queue endpoint",
    data: [],
  });
});

module.exports = router;
