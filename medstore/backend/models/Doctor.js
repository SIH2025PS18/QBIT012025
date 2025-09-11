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
  },
  qualification: {
    type: String,
    required: true,
  },
  experience: {
    type: Number,
    required: true,
  },
  licenseNumber: {
    type: String,
    required: true,
  },
  consultationFee: {
    type: Number,
    required: true,
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
  address: {
    street: String,
    city: String,
    state: String,
    pincode: String,
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
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  profileImage: String,
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

doctorSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model("Doctor", doctorSchema);
