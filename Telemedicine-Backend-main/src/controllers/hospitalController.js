import Doctor from '../models/Doctor.js';
import HospitalAdmin from '../models/Hospital.js'; // pre-created admins
import bcrypt from 'bcryptjs';
import { JWT_SECRET } from '../config/env.js';
import jwt from 'jsonwebtoken';

// --- Hospital Admin Login ---
export const adminLogin = async (req, res) => {
  const { adminEmail, adminPassword } = req.body;
  try {
    const admin = await HospitalAdmin.findOne({ adminEmail });
    if (!admin) return res.status(401).json({ message: 'Invalid credentials' });

    if (adminPassword !== admin.adminPassword) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    console.log('Loaded JWT_SECRET:', JWT_SECRET);  // Debugging line

    const token = jwt.sign(
      { adminId: admin._id, adminName: admin.adminName },
      JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.json({ token, adminId: admin._id });
  } catch (error) {
    console.error('Login Controller Error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// --- Add Doctor ---
export const addDoctor = async (req, res) => {
  const adminId=req.params.id
  const { name,phone,email,specialization,languages,yearsOfExperience,password } = req.body;

  try {
    
    const existingDoctor=await Doctor.findOne({email});
    if(existingDoctor){
      console.log('Doctor Already Exists');
      return res.status(403).json({message:'Doctor Already Exists'});
    }

    const doctor = new Doctor({
      hospitalId:adminId,
      name,
      phone,
      email,
      specialization,
      languages,
      yearsOfExperience,
      password
    });

    await doctor.save();
    res.json({ message: 'Doctor added successfully', doctor });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// --- Get All Doctors of the Hospital ---
export const getDoctors = async (req, res) => {
  const adminId=req.params.id;
  try {
    const doctors = await Doctor.find({ hospitalId:adminId });
    res.json(doctors);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};
