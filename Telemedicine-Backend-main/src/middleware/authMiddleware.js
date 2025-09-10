import jwt from 'jsonwebtoken';
import { JWT_SECRET } from '../config/env.js';

export const authMiddleware = (req, res, next) => {
  try {
    const token = req.cookies.token;

    if (!token) {
      return res.status(401).json({ message: 'Unauthorized: No token found' });
    }

    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload;  // { doctorId, doctorName }

    next();
  } catch (error) {
    console.error('Auth Middleware Error:', error);
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};
