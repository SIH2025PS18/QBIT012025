const jwt = require('jsonwebtoken');
const User = require('../models/User');

const protect = async (req, res, next) => {
  let token;
  try {
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
      token = req.headers.authorization.split(' ')[1];
      if (!token) throw new Error('Token missing');

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      req.user = await User.findById(decoded.id).select('-password');

      if (!req.user) {
        return res.status(401).json({ message: 'Not authorized, user not found' });
      }
      return next();
    } else {
      return res.status(401).json({ message: 'Not authorized, no token' });
    }
  } catch (error) {
    console.error('JWT Error:', error.message); // optional: can remove console.error to avoid spam
    return res.status(401).json({ message: 'Not authorized, token failed or malformed' });
  }
};


const admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    return next();
  }
  return res.status(403).json({ message: 'Not authorized as admin' });
};

const pharmacy = (req, res, next) => {
  if (req.user && (req.user.role === 'pharmacy' || req.user.role === 'admin')) {
    return next();
  }
  return res.status(403).json({ message: 'Not authorized as pharmacy' });
};

module.exports = { protect, admin, pharmacy };
