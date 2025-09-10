const Medicine = require('../models/Medicine');
const Pharmacy = require('../models/Pharmacy');

// Get all medicines with filters
const getMedicines = async (req, res) => {
  try {
    const { page = 1, limit = 10, search, category, pharmacyId, requiresPrescription } = req.query;
    
    let query = { active: true };
    
    if (search) {
      query.name = { $regex: search, $options: 'i' };
    }
    
    if (category) {
      query.category = category;
    }
    
    if (pharmacyId) {
      query.pharmacyId = pharmacyId;
    }
    
    if (requiresPrescription !== undefined) {
      query.requiresPrescription = requiresPrescription === 'true';
    }
    
    if (req.user.role === 'pharmacy') {
      query.pharmacyId = req.user.pharmacyId;
    }

    const medicines = await Medicine.find(query)
      .populate('pharmacyId', 'name address')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Medicine.countDocuments(query);

    res.json({
      medicines,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get single medicine
const getMedicineById = async (req, res) => {
  try {
    const medicine = await Medicine.findById(req.params.id).populate('pharmacyId', 'name address');
    
    if (medicine) {
      res.json(medicine);
    } else {
      res.status(404).json({ message: 'Medicine not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create medicine
const createMedicine = async (req, res) => {
  try {
    const { name, description, price, stockQuantity, category, manufacturer, requiresPrescription } = req.body;
    
    // Validate pharmacy exists if pharmacyId is provided
    let pharmacyId = req.user.pharmacyId || req.body.pharmacyId;
    if (req.body.pharmacyId) {
      const pharmacy = await Pharmacy.findById(req.body.pharmacyId);
      if (!pharmacy || !pharmacy.active) {
        return res.status(400).json({ message: 'Invalid pharmacy' });
      }
      pharmacyId = req.body.pharmacyId;
    }
    
    const medicine = new Medicine({
      name,
      description,
      price,
      stockQuantity,
      category,
      manufacturer,
      requiresPrescription,
      pharmacyId,
      image: req.file ? `/uploads/${req.file.filename}` : ''
    });

    const createdMedicine = await medicine.save();
    await createdMedicine.populate('pharmacyId', 'name address');
    res.status(201).json(createdMedicine);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update medicine
const updateMedicine = async (req, res) => {
  try {
    const medicine = await Medicine.findById(req.params.id);
    
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }
    
    // Check if pharmacy user owns this medicine or is admin
    if (req.user.role === 'pharmacy' && medicine.pharmacyId.toString() !== req.user.pharmacyId.toString()) {
      return res.status(403).json({ message: 'Not authorized to update this medicine' });
    }
    
    // Validate pharmacy exists if pharmacyId is being updated
    if (req.body.pharmacyId && req.body.pharmacyId !== medicine.pharmacyId.toString()) {
      if (req.user.role !== 'admin') {
        return res.status(403).json({ message: 'Only admin can change pharmacy assignment' });
      }
      
      const pharmacy = await Pharmacy.findById(req.body.pharmacyId);
      if (!pharmacy || !pharmacy.active) {
        return res.status(400).json({ message: 'Invalid pharmacy' });
      }
    }

    medicine.name = req.body.name || medicine.name;
    medicine.description = req.body.description || medicine.description;
    medicine.price = req.body.price || medicine.price;
    medicine.stockQuantity = req.body.stockQuantity || medicine.stockQuantity;
    medicine.category = req.body.category || medicine.category;
    medicine.manufacturer = req.body.manufacturer || medicine.manufacturer;
    medicine.requiresPrescription = req.body.requiresPrescription !== undefined 
      ? req.body.requiresPrescription 
      : medicine.requiresPrescription;
    
    if (req.body.pharmacyId) {
      medicine.pharmacyId = req.body.pharmacyId;
    }

    if (req.file) {
      medicine.image = `/uploads/${req.file.filename}`;
    }

    const updatedMedicine = await medicine.save();
    await updatedMedicine.populate('pharmacyId', 'name address');
    res.json(updatedMedicine);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete medicine
const deleteMedicine = async (req, res) => {
  try {
    const medicine = await Medicine.findById(req.params.id);
    
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }
    
    // Check if pharmacy user owns this medicine or is admin
    if (req.user.role === 'pharmacy' && medicine.pharmacyId.toString() !== req.user.pharmacyId.toString()) {
      return res.status(403).json({ message: 'Not authorized to delete this medicine' });
    }

    // Soft delete by setting active to false
    medicine.active = false;
    await medicine.save();
    
    res.json({ message: 'Medicine removed' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getMedicines,
  getMedicineById,
  createMedicine,
  updateMedicine,
  deleteMedicine
};