const express = require("express");
const router = express.Router();

// Placeholder routes for pharmacies
router.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Pharmacies endpoint",
    data: [],
  });
});

module.exports = router;
