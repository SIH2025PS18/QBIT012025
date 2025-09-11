const mongoose = require("mongoose");

const patientSchema = new mongoose.Schema({
  patientId: {
    type: String,
    required: true,
    unique: true,
  },
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  age: {
    type: Number,
    required: true,
    min: 0,
    max: 150,
  },
  gender: {
    type: String,
    enum: ["male", "female", "other"],
    required: true,
  },
  dateOfBirth: {
    type: Date,
    required: true,
  },
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
  emergencyContacts: [
    {
      name: {
        type: String,
        required: true,
      },
      relationship: {
        type: String,
        required: true,
      },
      phone: {
        type: String,
        required: true,
      },
      isPrimary: {
        type: Boolean,
        default: false,
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
  currentMedications: [
    {
      name: String,
      dosage: String,
      frequency: String,
      prescribedBy: String,
      startDate: Date,
      endDate: Date,
    },
  ],
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
  preferredLanguage: {
    type: String,
    enum: ["en", "hi", "pa"],
    default: "en",
  },
  bloodGroup: {
    type: String,
    enum: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
  },
  profileImage: String,
  isActive: {
    type: Boolean,
    default: true,
  },
  lastConsultation: {
    type: Date,
  },
  totalConsultations: {
    type: Number,
    default: 0,
  },
  insuranceInfo: {
    provider: String,
    policyNumber: String,
    validUntil: Date,
  },
  notifications: {
    email: {
      type: Boolean,
      default: true,
    },
    sms: {
      type: Boolean,
      default: true,
    },
    push: {
      type: Boolean,
      default: true,
    },
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

// Indexes for better performance
patientSchema.index({ email: 1 });
patientSchema.index({ patientId: 1 });
patientSchema.index({ phone: 1 });

// Pre-save middleware
patientSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

// Virtual for BMI calculation
patientSchema.virtual("bmi").get(function () {
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
patientSchema.virtual("fullAddress").get(function () {
  if (!this.address) return "";
  return `${this.address.street}, ${this.address.city}, ${this.address.state} ${this.address.pincode}`;
});

// Method to add medical history
patientSchema.methods.addMedicalHistory = function (condition, notes, doctor) {
  this.medicalHistory.push({
    condition,
    notes,
    doctor,
    diagnosedDate: new Date(),
  });
  return this.save();
};

// Method to update vitals
patientSchema.methods.updateVitals = function (vitalsData) {
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

module.exports = mongoose.model("Patient", patientSchema);
