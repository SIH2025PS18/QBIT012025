const express = require("express");
const router = express.Router();
const FamilyMember = require("../models/FamilyMember");
const Patient = require("../models/Patient");
const authenticateToken = require("../middleware/authenticateToken");

// GET /api/family/overview - Get family health overview
router.get("/overview", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;

    // Get family overview with all dependents
    const familyOverview = await FamilyMember.getFamilyOverview(userId);
    
    // Get primary user information
    const primaryUser = await Patient.findById(userId).select(
      "name age phoneNumber medicalConditions"
    );

    res.json({
      success: true,
      data: {
        ...familyOverview,
        primaryUser,
      },
    });
  } catch (error) {
    console.error("Family overview error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get family overview",
      error: error.message,
    });
  }
});

// GET /api/family/dependents - Get all family members/dependents
router.get("/dependents", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;

    const dependents = await FamilyMember.getByPrimaryUser(userId);

    res.json({
      success: true,
      data: dependents,
    });
  } catch (error) {
    console.error("Get dependents error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get family members",
      error: error.message,
    });
  }
});

// POST /api/family/dependents - Add a new family member
router.post("/dependents", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const {
      name,
      relation,
      dateOfBirth,
      gender,
      phoneNumber,
      email,
      bloodGroup,
      allergies,
      medications,
      medicalHistory,
      medicalConditions,
      address,
      emergencyContact,
      emergencyContactPhone,
      caregiverPermissions,
      insuranceInfo,
      profilePhotoUrl,
    } = req.body;

    // Basic validation
    if (!name || !relation || !dateOfBirth || !gender) {
      return res.status(400).json({
        success: false,
        message: "Name, relation, date of birth, and gender are required",
      });
    }

    // Create new family member
    const familyMember = new FamilyMember({
      primaryUserId: userId,
      name,
      relation,
      dateOfBirth,
      gender,
      phoneNumber: phoneNumber || "",
      email: email || "",
      bloodGroup: bloodGroup || "unknown",
      allergies: allergies || [],
      medications: medications || [],
      medicalHistory: medicalHistory || [],
      medicalConditions: medicalConditions || [],
      address: address || {},
      emergencyContact: emergencyContact || "",
      emergencyContactPhone: emergencyContactPhone || "",
      caregiverPermissions: caregiverPermissions || [
        "view_medical_history",
        "book_appointments",
        "manage_medications",
        "receive_notifications",
      ],
      insuranceInfo: insuranceInfo || {},
      profilePhotoUrl: profilePhotoUrl || "",
    });

    await familyMember.save();

    res.status(201).json({
      success: true,
      message: "Family member added successfully",
      data: familyMember,
    });
  } catch (error) {
    console.error("Add family member error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to add family member",
      error: error.message,
    });
  }
});

// PUT /api/family/dependents/:id - Update family member
router.put("/dependents/:id", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;

    // Find the family member and verify ownership
    const familyMember = await FamilyMember.findOne({
      _id: id,
      primaryUserId: userId,
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    // Update allowed fields
    const allowedUpdates = [
      "name",
      "phoneNumber",
      "email",
      "bloodGroup",
      "allergies",
      "medications",
      "medicalHistory",
      "medicalConditions",
      "address",
      "emergencyContact",
      "emergencyContactPhone",
      "caregiverPermissions",
      "insuranceInfo",
      "profilePhotoUrl",
    ];

    allowedUpdates.forEach((field) => {
      if (req.body[field] !== undefined) {
        familyMember[field] = req.body[field];
      }
    });

    await familyMember.save();

    res.json({
      success: true,
      message: "Family member updated successfully",
      data: familyMember,
    });
  } catch (error) {
    console.error("Update family member error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update family member",
      error: error.message,
    });
  }
});

// DELETE /api/family/dependents/:id - Delete family member
router.delete("/dependents/:id", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;

    // Soft delete by setting isActive to false
    const familyMember = await FamilyMember.findOneAndUpdate(
      { _id: id, primaryUserId: userId },
      { isActive: false },
      { new: true }
    );

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    res.json({
      success: true,
      message: "Family member removed successfully",
    });
  } catch (error) {
    console.error("Delete family member error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to remove family member",
      error: error.message,
    });
  }
});

// GET /api/family/dependents/:id - Get specific family member
router.get("/dependents/:id", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;

    const familyMember = await FamilyMember.findOne({
      _id: id,
      primaryUserId: userId,
      isActive: true,
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    res.json({
      success: true,
      data: familyMember,
    });
  } catch (error) {
    console.error("Get family member error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get family member",
      error: error.message,
    });
  }
});

// PUT /api/family/dependents/:id/vitals - Update family member vitals
router.put("/dependents/:id/vitals", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;

    const familyMember = await FamilyMember.findOne({
      _id: id,
      primaryUserId: userId,
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    await familyMember.updateVitals(req.body);

    res.json({
      success: true,
      message: "Vitals updated successfully",
      data: familyMember.vitals,
    });
  } catch (error) {
    console.error("Update vitals error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update vitals",
      error: error.message,
    });
  }
});

// POST /api/family/dependents/:id/medications - Add medication to family member
router.post("/dependents/:id/medications", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;

    const familyMember = await FamilyMember.findOne({
      _id: id,
      primaryUserId: userId,
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    await familyMember.addMedication(req.body);

    res.json({
      success: true,
      message: "Medication added successfully",
      data: familyMember.medications,
    });
  } catch (error) {
    console.error("Add medication error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to add medication",
      error: error.message,
    });
  }
});

// POST /api/family/dependents/:id/medical-history - Add medical history
router.post("/dependents/:id/medical-history", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;
    const { condition, notes, doctor } = req.body;

    if (!condition) {
      return res.status(400).json({
        success: false,
        message: "Medical condition is required",
      });
    }

    const familyMember = await FamilyMember.findOne({
      _id: id,
      primaryUserId: userId,
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    await familyMember.addMedicalHistory(condition, notes, doctor);

    res.json({
      success: true,
      message: "Medical history added successfully",
      data: familyMember.medicalHistory,
    });
  } catch (error) {
    console.error("Add medical history error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to add medical history",
      error: error.message,
    });
  }
});

// PUT /api/family/dependents/:id/caregiver-activity - Update caregiver activity
router.put("/dependents/:id/caregiver-activity", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;
    const { id } = req.params;

    const familyMember = await FamilyMember.findOne({
      _id: id,
      primaryUserId: userId,
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: "Family member not found",
      });
    }

    await familyMember.updateCaregiverActivity();

    res.json({
      success: true,
      message: "Caregiver activity updated successfully",
    });
  } catch (error) {
    console.error("Update caregiver activity error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update caregiver activity",
      error: error.message,
    });
  }
});

// GET /api/family/caregiver-stats - Get caregiver statistics
router.get("/caregiver-stats", authenticateToken, async (req, res) => {
  try {
    const userId = req.userId;

    const familyMembers = await FamilyMember.getByPrimaryUser(userId);
    
    // Calculate statistics
    const stats = {
      totalDependents: familyMembers.length,
      activeMedications: familyMembers.reduce((total, member) => 
        total + member.medications.filter(med => med.isActive).length, 0
      ),
      chronicConditions: familyMembers.reduce((total, member) => 
        total + member.medicalHistory.filter(history => history.status === 'chronic').length, 0
      ),
      recentActivities: familyMembers.filter(member => 
        member.lastCaregiverActivity && 
        (new Date() - member.lastCaregiverActivity) < (7 * 24 * 60 * 60 * 1000) // Last 7 days
      ).length,
      pendingHealthChecks: familyMembers.filter(member => 
        !member.lastHealthCheck || 
        (new Date() - member.lastHealthCheck) > (30 * 24 * 60 * 60 * 1000) // More than 30 days
      ).length,
    };

    res.json({
      success: true,
      data: stats,
    });
  } catch (error) {
    console.error("Caregiver stats error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get caregiver statistics",
      error: error.message,
    });
  }
});

module.exports = router;