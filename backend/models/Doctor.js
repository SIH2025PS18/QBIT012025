const mongoose = require("mongoose");

const doctorSchema = new mongoose.Schema({
  doctorId: {
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
  speciality: {
    type: String,
    required: true,
    enum: [
      "Cardiologist",
      "Dermatologist",
      "Pediatrician",
      "Neurologist",
      "General Practitioner",
      "Psychiatrist",
      "Orthopedic",
      "Gynecologist",
      "ENT Specialist",
      "Ophthalmologist",
    ],
  },
  qualification: {
    type: String,
    required: true,
  },
  experience: {
    type: Number,
    required: true,
    min: 0,
  },
  licenseNumber: {
    type: String,
    required: true,
    unique: true,
  },
  consultationFee: {
    type: Number,
    required: true,
    min: 0,
  },
  status: {
    type: String,
    enum: ["online", "offline", "busy"],
    default: "offline",
  },
  isAvailable: {
    type: Boolean,
    default: true,
  },
  languages: [
    {
      type: String,
      enum: ["en", "hi", "pa"],
      default: ["en"],
    },
  ],
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5,
  },
  totalRatings: {
    type: Number,
    default: 0,
  },
  totalConsultations: {
    type: Number,
    default: 0,
  },
  todayConsultations: {
    type: Number,
    default: 0,
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
  workingHours: {
    start: {
      type: String,
      default: "09:00",
    },
    end: {
      type: String,
      default: "17:00",
    },
    timezone: {
      type: String,
      default: "Asia/Kolkata",
    },
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  profileImage: String,
  documents: [
    {
      type: String,
      url: String,
      uploadedAt: {
        type: Date,
        default: Date.now,
      },
    },
  ],
  socialMedia: {
    linkedin: String,
    twitter: String,
    website: String,
  },
  lastActive: {
    type: Date,
    default: Date.now,
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
doctorSchema.index({ speciality: 1, isAvailable: 1, status: 1 });
doctorSchema.index({ email: 1 });
doctorSchema.index({ doctorId: 1 });

// Pre-save middleware
doctorSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

// Virtual for full address
doctorSchema.virtual("fullAddress").get(function () {
  if (!this.address) return "";
  return `${this.address.street}, ${this.address.city}, ${this.address.state} ${this.address.pincode}`;
});

// Method to update status
doctorSchema.methods.updateStatus = function (status) {
  this.status = status;
  this.lastActive = Date.now();
  return this.save();
};

// Static method to find available doctors
doctorSchema.statics.findAvailable = function (speciality = null) {
  const query = {
    isAvailable: true,
    status: { $in: ["online", "busy"] },
    isVerified: true,
  };

  if (speciality) {
    query.speciality = speciality;
  }

  return this.find(query).sort({ rating: -1, totalConsultations: -1 });
};

module.exports = mongoose.model("Doctor", doctorSchema);
