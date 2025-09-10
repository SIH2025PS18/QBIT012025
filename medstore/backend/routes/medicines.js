const express = require('express');
const { getMedicines, getMedicineById, createMedicine, updateMedicine, deleteMedicine } = require('../controllers/medicineController');
const { protect, pharmacy, admin } = require('../middleware/auth');
const upload = require('../middleware/upload');
const router = express.Router();

router.route('/')
  .get(protect, getMedicines)
  .post(protect, pharmacy, upload.single('image'), createMedicine);

router.route('/:id')
  .get(protect, getMedicineById)
  .put(protect, pharmacy, upload.single('image'), updateMedicine)
  .delete(protect, pharmacy, deleteMedicine);

module.exports = router;