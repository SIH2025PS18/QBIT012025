const express = require("express");
const { auth } = require("../middleware/auth");

const router = express.Router();

// Placeholder routes for consultations
router.post("/book", auth, (req, res) => {
  res.json({
    success: true,
    message: "Consultation booking endpoint",
  });
});

router.get("/:id", auth, (req, res) => {
  res.json({
    success: true,
    message: "Get consultation endpoint",
    data: { id: req.params.id },
  });
});

module.exports = router;
