const jwt = require("jsonwebtoken");
const Doctor = require("../models/Doctor");
const Patient = require("../models/Patient");
const Admin = require("../models/Admin");

// Middleware to verify JWT token
const auth = async (req, res, next) => {
  try {
    let token;

    // Check for token in header
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    }

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "No token provided, authorization denied",
      });
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Get user based on userType
    let user;
    let Model;

    switch (decoded.userType) {
      case "patient":
        Model = Patient;
        break;
      case "doctor":
        Model = Doctor;
        break;
      case "admin":
        Model = Admin;
        break;
      default:
        return res.status(401).json({
          success: false,
          message: "Invalid user type in token",
        });
    }

    user = await Model.findById(decoded.id).select("-password");

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "User not found, authorization denied",
      });
    }

    // Check if doctor is still verified
    if (decoded.userType === "doctor" && !user.isVerified) {
      return res.status(401).json({
        success: false,
        message: "Doctor account is no longer verified",
      });
    }

    // Add user and userType to request
    req.user = {
      ...user.toObject(),
      userType: decoded.userType,
    };

    next();
  } catch (error) {
    console.error("Auth middleware error:", error);

    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({
        success: false,
        message: "Invalid token",
      });
    } else if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Token expired",
      });
    }

    res.status(500).json({
      success: false,
      message: "Server error in authentication",
    });
  }
};

// Middleware to check for specific user types
const authorize = (...userTypes) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: "Authentication required",
      });
    }

    if (!userTypes.includes(req.user.userType)) {
      return res.status(403).json({
        success: false,
        message: `Access denied. Required user types: ${userTypes.join(", ")}`,
      });
    }

    next();
  };
};

// Middleware to check if doctor is verified
const verifiedDoctor = (req, res, next) => {
  if (req.user.userType !== "doctor") {
    return res.status(403).json({
      success: false,
      message: "Doctor access required",
    });
  }

  if (!req.user.isVerified) {
    return res.status(403).json({
      success: false,
      message: "Doctor verification required",
    });
  }

  next();
};

// Middleware to check admin permissions
const adminPermission = (permission) => {
  return (req, res, next) => {
    if (req.user.userType !== "admin") {
      return res.status(403).json({
        success: false,
        message: "Admin access required",
      });
    }

    if (
      !req.user.permissions.includes("all") &&
      !req.user.permissions.includes(permission)
    ) {
      return res.status(403).json({
        success: false,
        message: `Permission denied. Required permission: ${permission}`,
      });
    }

    next();
  };
};

// Optional authentication (doesn't fail if no token)
const optionalAuth = async (req, res, next) => {
  try {
    let token;

    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    }

    if (!token) {
      return next();
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    let user;
    let Model;

    switch (decoded.userType) {
      case "patient":
        Model = Patient;
        break;
      case "doctor":
        Model = Doctor;
        break;
      case "admin":
        Model = Admin;
        break;
      default:
        return next();
    }

    user = await Model.findById(decoded.id).select("-password");

    if (user) {
      req.user = {
        ...user.toObject(),
        userType: decoded.userType,
      };
    }

    next();
  } catch (error) {
    // If optional auth fails, just continue without user
    next();
  }
};

module.exports = {
  auth,
  authorize,
  verifiedDoctor,
  adminPermission,
  optionalAuth,
};
