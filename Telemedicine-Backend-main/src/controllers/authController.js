import Hospital from "../models/Hospital.js";
import jwt from "jsonwebtoken";
import bcrypt from 'bcryptjs';
import {JWT_SECRET } from "../config/env.js";

export const adminLogin= async (req, res) => {
  const { adminEmail, adminPassword } = req.body;
  try {
    const hospital = await Hospital.findOne({ adminEmail });
    if (!hospital) return res.status(401).json({ message: 'Invalid credentials' });

    const isMatch = await bcrypt.compare(password, hospital.adminPassword);
    if (!isMatch) return res.status(401).json({ message: 'Invalid credentials' });

    const token = jwt.sign(
      { hospitalId: hospital._id, adminName: hospital.adminName },
      JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.json({ token, hospitalId: hospital._id });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
