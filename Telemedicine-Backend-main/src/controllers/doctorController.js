import Doctor from '../models/Doctor.js';
import Pateint from '../models/Patient.js';
import jwt from 'jsonwebtoken';
import { JWT_SECRET } from '../config/env.js';

export const doctorLogin = async (req, res) => {
  const { email, password } = req.body;

  try {
    const doctor = await Doctor.findOne({ email });
    if (!doctor) return res.status(401).json({ message: 'Invalid credentials' });

    if (password !== doctor.password) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    doctor.isOnline = true;
    doctor.queueActive = true;
    doctor.updatedAt = new Date();
    await doctor.save();

    const token = jwt.sign(
      { doctorId: doctor._id, doctorName: doctor.name },
      JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.cookie('token', token, {
      httpOnly: true,
      maxAge: 8 * 60 * 60 * 1000,
    });

    return res.status(200).json({ message: 'Login successful', doctor:doctor,token});
  } catch (error) {
    console.error('Login Controller Error:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
};


export const logout = async (req, res) => {
  try {
    const doctorId = req.user.doctorId;

    await Doctor.findByIdAndUpdate(doctorId, {
      isOnline: false,
      queueActive: false,
      updatedAt: new Date()
    });

    res.clearCookie('token');
    const doctor = await Doctor.findById(doctorId);
    return res.status(200).json({ message: 'Logout successful',doctor:doctor });
  } catch (error) {
    console.error('Logout Controller Error:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
};

