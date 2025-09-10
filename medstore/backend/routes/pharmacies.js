const express = require("express");
const { 
  getPharmacies, 
  getPharmacyById, 
  createPharmacy, 
  updatePharmacy, 
  deletePharmacy ,
  getUserCount
} = require("../controllers/pharmacyController");
const { protect, admin } = require("../middleware/auth");

const router = express.Router();

// Admin-only routes
router.get("/", protect, admin, getPharmacies);
router.get("/:id", protect, admin, getPharmacyById);
router.post("/", protect, admin, createPharmacy);
router.put("/:id", protect, admin, updatePharmacy);
router.delete("/:id", protect, admin, deletePharmacy);
router.get('/users/count', protect, admin, getUserCount);

module.exports = router;