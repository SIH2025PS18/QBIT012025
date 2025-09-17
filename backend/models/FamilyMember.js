const mongoose = require("mongoose");

const familyMemberSchema = new mongoose.Schema({
  // Primary user who manages this dependent
  primaryUserId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Patient",
    required: true,
  },
  
  // Basic Information
  name: {
    type: String,
    required: true,
  },
  relation: {
    type: String,
    enum: [
      "father",
      "mother",
      "spouse",
      "son", 
      "daughter",
      "brother",
      "sister",
      "grandfather",
      "grandmother",
      "uncle",
      "aunt",
      "cousin",
      "other"
    ],
    required: true,
  },
  dateOfBirth: {
    type: Date,
    required: true,
  },
  gender: {
    type: String,
    enum: ["male", "female", "other"],
    required: true,
  },
  
  // Contact Information
  phoneNumber: {
    type: String,
    default: "",
  },
  email: {
    type: String,
    default: "",
  },
  
  // Medical Information
  bloodGroup: {
    type: String,
    enum: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "unknown"],
    default: "unknown",
  },
  allergies: [
    {
      allergen: String,
      severity: {
        type: String,
        enum: ["mild", "moderate", "severe"],
        default: "mild",
      },
      reaction: String,
    },
  ],
  medications: [
    {
      name: String,
      dosage: String,
      frequency: String,
      prescribedBy: String,
      startDate: Date,
      endDate: Date,
      isActive: {
        type: Boolean,
        default: true,
      },
    },
  ],
  medicalHistory: [
    {
      condition: {
        type: String,
        required: true,
      },
      diagnosedDate: Date,
      notes: String,
      doctor: String,
      status: {
        type: String,
        enum: ["active", "resolved", "chronic"],
        default: "active",
      },
    },
  ],
  medicalConditions: [String], // Simplified current conditions
  
  // Physical Information
  vitals: {
    bloodPressure: {
      systolic: Number,
      diastolic: Number,
      lastUpdated: Date,
    },
    heartRate: {
      value: Number,
      lastUpdated: Date,
    },
    temperature: {
      value: Number,
      unit: {
        type: String,
        enum: ["celsius", "fahrenheit"],
        default: "celsius",
      },
      lastUpdated: Date,
    },
    weight: {
      value: Number,
      unit: {
        type: String,
        enum: ["kg", "lbs"],
        default: "kg",
      },
      lastUpdated: Date,
    },
    height: {
      value: Number,
      unit: {
        type: String,
        enum: ["cm", "ft"],
        default: "cm",
      },
      lastUpdated: Date,
    },
  },
  
  // Address (can be different from primary user)
  address: {
    street: String,
    city: String,
    state: String,
    pincode: String,
    country: {
      type: String,
      default: "India",
    },
  },
  
  // Emergency Contact
  emergencyContact: {
    type: String,
    default: "",
  },
  emergencyContactPhone: {
    type: String,
    default: "",
  },
  
  // Caregiver Settings
  caregiverPermissions: [
    {
      type: String,
      enum: [
        "view_medical_history",
        "book_appointments", 
        "manage_medications",
        "receive_notifications",
        "emergency_access",
        "update_profile",
        "view_reports",
        "manage_insurance"
      ],
    },
  ],
  caregiverSettings: {
    type: Map,
    of: mongoose.Schema.Types.Mixed,
    default: {},
  },
  
  // Account Linking
  hasOwnAccount: {
    type: Boolean,
    default: false,
  },
  linkedAccountId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Patient",
    default: null,
  },
  allowIndependentAccess: {
    type: Boolean,
    default: false,
  },
  
  // Emergency Information
  emergencyInfo: {
    type: Map,
    of: mongoose.Schema.Types.Mixed,
    default: {},
  },
  
  // Profile Settings
  profilePhotoUrl: {
    type: String,
    default: "",
  },
  isPrimaryContact: {
    type: Boolean,
    default: false,
  },
  
  // Insurance Information
  insuranceInfo: {
    provider: String,
    policyNumber: String,
    validUntil: Date,
    isDependent: {
      type: Boolean,
      default: true,
    },
  },
  
  // Activity Tracking
  lastCaregiverActivity: {
    type: Date,
    default: null,
  },
  lastHealthCheck: {
    type: Date,
    default: null,
  },
  
  // Status
  isActive: {
    type: Boolean,
    default: true,
  },
  
  // Timestamps
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

// Indexes
familyMemberSchema.index({ primaryUserId: 1 });
familyMemberSchema.index({ relation: 1 });
familyMemberSchema.index({ name: 1 });
familyMemberSchema.index({ createdAt: -1 });

// Pre-save middleware
familyMemberSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

// Virtual for age calculation
familyMemberSchema.virtual("age").get(function () {
  const now = new Date();
  const birthDate = new Date(this.dateOfBirth);
  let age = now.getFullYear() - birthDate.getFullYear();
  const monthDiff = now.getMonth() - birthDate.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && now.getDate() < birthDate.getDate())) {
    age--;
  }
  
  return age;
});

// Virtual for BMI calculation
familyMemberSchema.virtual("bmi").get(function () {
  if (this.vitals.weight?.value && this.vitals.height?.value) {
    const weightInKg =
      this.vitals.weight.unit === "lbs"
        ? this.vitals.weight.value * 0.453592
        : this.vitals.weight.value;

    const heightInM =
      this.vitals.height.unit === "ft"
        ? this.vitals.height.value * 0.3048
        : this.vitals.height.value / 100;

    return (weightInKg / (heightInM * heightInM)).toFixed(1);
  }
  return null;
});

// Virtual for full address
familyMemberSchema.virtual("fullAddress").get(function () {
  if (!this.address) return "";
  return `${this.address.street}, ${this.address.city}, ${this.address.state} ${this.address.pincode}`;
});

// Method to add medical history
familyMemberSchema.methods.addMedicalHistory = function (condition, notes, doctor) {
  this.medicalHistory.push({
    condition,
    notes,
    doctor,
    diagnosedDate: new Date(),
  });
  return this.save();
};

// Method to update vitals
familyMemberSchema.methods.updateVitals = function (vitalsData) {
  Object.keys(vitalsData).forEach((key) => {
    if (this.vitals[key]) {
      this.vitals[key].value = vitalsData[key].value;
      this.vitals[key].lastUpdated = new Date();
      if (vitalsData[key].unit) {
        this.vitals[key].unit = vitalsData[key].unit;
      }
    }
  });
  return this.save();
};

// Method to add medication
familyMemberSchema.methods.addMedication = function (medicationData) {
  this.medications.push({
    ...medicationData,
    startDate: medicationData.startDate || new Date(),
  });
  return this.save();
};

// Method to update caregiver activity
familyMemberSchema.methods.updateCaregiverActivity = function () {
  this.lastCaregiverActivity = new Date();
  return this.save();
};

// Static method to get family members by primary user
familyMemberSchema.statics.getByPrimaryUser = function (primaryUserId) {
  return this.find({ primaryUserId, isActive: true })
    .sort({ createdAt: -1 });
};

// Static method to get family overview
familyMemberSchema.statics.getFamilyOverview = async function (primaryUserId) {
  const familyMembers = await this.find({ primaryUserId, isActive: true });
  
  // Calculate statistics
  const totalMembers = familyMembers.length + 1; // +1 for primary user
  const upcomingAppointments = 0; // TODO: Implement appointment counting
  const pendingMedications = familyMembers.reduce((count, member) => {
    return count + member.medications.filter(med => med.isActive).length;
  }, 0);
  const criticalAlerts = 0; // TODO: Implement alerts counting
  
  return {
    primaryUserId,
    dependents: familyMembers,
    totalMembers,
    upcomingAppointments,
    pendingMedications,
    criticalAlerts,
    lastUpdated: new Date(),
  };
};

module.exports = mongoose.model("FamilyMember", familyMemberSchema);