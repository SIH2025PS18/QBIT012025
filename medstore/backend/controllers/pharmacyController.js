const Pharmacy = require("../models/Pharmacy");
const Medicine = require("../models/Medicine");
const User = require("../models/User");
const bcrypt = require("bcryptjs");

// Get all pharmacies
const getPharmacies = async (req, res) => {
  try {
    const { active } = req.query;
    let query = {};
    if (active !== undefined) {
      query.active = active === "true";
    }
    const pharmacies = await Pharmacy.find(query);
    res.json(pharmacies);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get single pharmacy
const getPharmacyById = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);
    if (!pharmacy) return res.status(404).json({ message: "Pharmacy not found" });
    res.json(pharmacy);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create pharmacy (admin only)
const createPharmacy = async (req, res) => {
  try {
    const { name, address, phone, email, licenseNumber } = req.body;

    if (!name || !address || !phone || !email || !licenseNumber) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Check if pharmacy already exists
    const existingPharmacy = await Pharmacy.findOne({ licenseNumber });
    if (existingPharmacy) {
      return res.status(400).json({ message: "Pharmacy with this license number already exists" });
    }

    // Create Pharmacy
    const pharmacy = await Pharmacy.create({
      name,
      address,
      phone,
      email,
      licenseNumber
    });

    // Also create a User account for this pharmacy (role=pharmacy)
    const tempPassword = Math.random().toString(36).slice(-8);
    const hashed = await bcrypt.hash(tempPassword, 10);

    await User.create({
      name,
      email,
      password: hashed,
      role: "pharmacy",
      pharmacyId: pharmacy._id  // ✅ Correct field name
    });
    res.status(201).json({
      pharmacy,
      tempPassword,
      message: "Pharmacy created successfully. A pharmacy user account was also created."
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update pharmacy (admin only)
const updatePharmacy = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);
    if (!pharmacy) return res.status(404).json({ message: "Pharmacy not found" });

    if (req.body.licenseNumber && req.body.licenseNumber !== pharmacy.licenseNumber) {
      const existing = await Pharmacy.findOne({ licenseNumber: req.body.licenseNumber });
      if (existing) return res.status(400).json({ message: "Pharmacy with this license number already exists" });
    }

    Object.assign(pharmacy, req.body);
    const updatedPharmacy = await pharmacy.save();
    res.json(updatedPharmacy);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//get user count
const getUserCount = async (req, res) => {
  try {
    const userCount = await User.countDocuments();
    res.json({ count: userCount });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete pharmacy (soft delete)
const deletePharmacy = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);
    if (!pharmacy) return res.status(404).json({ message: "Pharmacy not found" });

    const medicineCount = await Medicine.countDocuments({
      pharmacyId: pharmacy._id,
      active: true
    });

    if (medicineCount > 0) {
      return res.status(400).json({
        message: "Cannot delete pharmacy with active medicines. Delete medicines first."
      });
    }

    pharmacy.active = false;
    await pharmacy.save();

    res.json({ message: "Pharmacy deactivated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getPharmacies,
  getPharmacyById,
  createPharmacy,
  updatePharmacy,
  deletePharmacy,
  getUserCount 
};
