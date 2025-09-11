const express = require("express");
const { auth, authorize } = require("../middleware/auth");
const Doctor = require("../models/Doctor");
const Patient = require("../models/Patient");

const router = express.Router();

// @desc    Get dashboard statistics
// @route   GET /api/admin/dashboard/stats
// @access  Private (Admin only)
router.get("/dashboard/stats", auth, authorize("admin"), async (req, res) => {
  try {
    // Get counts
    const totalDoctors = await Doctor.countDocuments({});
    const totalPatients = await Patient.countDocuments({});
    
    // Get active doctors (available)
    const activeDoctors = await Doctor.countDocuments({ isAvailable: true });
    
    // Get recent patients (last 30 days)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    const recentPatients = await Patient.countDocuments({
      createdAt: { $gte: thirtyDaysAgo }
    });

    // Mock data for now (can be enhanced with real appointment data)
    const stats = {
      totalDoctors,
      totalPatients,
      totalAppointments: 890, // Mock data
      todayAppointments: 28, // Mock data
      pendingAppointments: 15, // Mock data
      completedAppointments: 775, // Mock data
      cancelledAppointments: 100, // Mock data
      revenue: 125000.0, // Mock data
      monthlyGrowth: 12.5, // Mock data
      activeDoctors,
      recentPatients,
      appointmentChart: [
        { label: 'Mon', value: 25 },
        { label: 'Tue', value: 30 },
        { label: 'Wed', value: 28 },
        { label: 'Thu', value: 35 },
        { label: 'Fri', value: 32 },
        { label: 'Sat', value: 20 },
        { label: 'Sun', value: 15 },
      ],
      revenueChart: [
        { label: 'Jan', value: 85000 },
        { label: 'Feb', value: 92000 },
        { label: 'Mar', value: 105000 },
        { label: 'Apr', value: 118000 },
        { label: 'May', value: 125000 },
      ],
    };

    res.json({
      success: true,
      data: stats,
    });
  } catch (error) {
    console.error("Error fetching dashboard stats:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching dashboard statistics",
    });
  }
});

// @desc    Get all users (doctors and patients) for admin
// @route   GET /api/admin/users
// @access  Private (Admin only)
router.get("/users", auth, authorize("admin"), async (req, res) => {
  try {
    const doctors = await Doctor.find({}).select("-password");
    const patients = await Patient.find({}).select("-password");

    res.json({
      success: true,
      data: {
        doctors,
        patients,
        total: doctors.length + patients.length
      },
    });
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching users",
    });
  }
});

module.exports = router;
