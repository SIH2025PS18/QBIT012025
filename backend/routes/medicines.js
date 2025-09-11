const express = require('express');
const router = express.Router();

// Import existing medstore routes (pharmacy management)
// These routes handle medicine inventory and orders

// Placeholder routes for medicines
router.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Medicines endpoint',
    data: []
  });
});

router.post('/', (req, res) => {
  res.json({
    success: true,
    message: 'Add medicine endpoint'
  });
});

module.exports = router;