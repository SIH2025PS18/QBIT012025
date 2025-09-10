const User = require('../models/User');
const Pharmacy = require('../models/Pharmacy');
const jwt = require('jsonwebtoken');

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};


// Register user
const registerUser = async (req, res) => {
  try {
    const { name, email, password, role, phone, address, pharmacyId } = req.body;

    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // For pharmacy role, validate pharmacyId
    let validPharmacyId = null;
    if (role === 'pharmacy' && pharmacyId) {
      const pharmacy = await Pharmacy.findById(pharmacyId);
      if (!pharmacy || !pharmacy.active) {
        return res.status(400).json({ message: 'Invalid pharmacy' });
      }
      validPharmacyId = pharmacyId;
    }

    // For admin role, no pharmacyId should be assigned
    if (role === 'admin' && pharmacyId) {
      return res.status(400).json({ message: 'Admin cannot be associated with a pharmacy' });
    }

    const user = await User.create({
      name,
      email,
      password,
      role,
      phone,
      address,
      pharmacyId: validPharmacyId
    });

    if (user) {
      const userWithDetails = await User.findById(user._id)
        .select('-password')
        .populate('pharmacyId');
      
      res.status(201).json({
        _id: userWithDetails._id,
        name: userWithDetails.name,
        email: userWithDetails.email,
        role: userWithDetails.role,
        pharmacyId: userWithDetails.pharmacyId,
        phone: userWithDetails.phone,
        address: userWithDetails.address,
        token: generateToken(userWithDetails._id),
      });
    } else {
      res.status(400).json({ message: 'Invalid user data' });
    }
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: error.message });
  }
};

// Login user
const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email }).populate('pharmacyId');

    if (user && (await user.matchPassword(password))) {
      res.json({
        _id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        pharmacyId: user.pharmacyId,
        phone: user.phone,
        address: user.address,
        token: generateToken(user._id),
      });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: error.message });
  }
};

// Get user profile
const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-password').populate('pharmacyId');
    
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update user profile
const updateUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    if (user) {
      user.name = req.body.name || user.name;
      user.email = req.body.email || user.email;
      user.phone = req.body.phone || user.phone;
      user.address = req.body.address || user.address;

      if (req.body.password) {
        user.password = req.body.password;
      }

      const updatedUser = await user.save();
      await updatedUser.populate('pharmacyId');

      res.json({
        _id: updatedUser._id,
        name: updatedUser.name,
        email: updatedUser.email,
        role: updatedUser.role,
        pharmacyId: updatedUser.pharmacyId,
        phone: updatedUser.phone,
        address: updatedUser.address,
        token: generateToken(updatedUser._id),
      });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  registerUser,
  loginUser,
  getUserProfile,
  updateUserProfile,
};