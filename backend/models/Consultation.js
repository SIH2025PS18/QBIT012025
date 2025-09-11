const mongoose = require("mongoose");

const consultationSchema = new mongoose.Schema({
  consultationId: {
    type: String,
    required: true,
    unique: true,
  },
  patient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Patient",
    required: true,
  },
  doctor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Doctor",
    required: true,
  },
  type: {
    type: String,
    enum: ["video", "audio", "chat", "emergency"],
    default: "video",
  },
  status: {
    type: String,
    enum: [
      "scheduled",
      "waiting",
      "in-progress",
      "completed",
      "cancelled",
      "no-show",
    ],
    default: "scheduled",
  },
  priority: {
    type: String,
    enum: ["low", "normal", "high", "emergency"],
    default: "normal",
  },
  scheduledAt: {
    type: Date,
    required: true,
  },
  startedAt: Date,
  endedAt: Date,
  duration: Number, // in minutes
  symptoms: [
    {
      name: String,
      severity: {
        type: String,
        enum: ["mild", "moderate", "severe"],
        default: "mild",
      },
      duration: String, // e.g., "2 days", "1 week"
      description: String,
    },
  ],
  chiefComplaint: {
    type: String,
    required: true,
  },
  diagnosis: {
    primary: String,
    secondary: [String],
    icd10Code: String,
  },
  treatment: {
    prescribed: Boolean,
    medications: [
      {
        name: String,
        dosage: String,
        frequency: String,
        duration: String,
        instructions: String,
      },
    ],
    advice: [String],
    followUp: {
      required: Boolean,
      date: Date,
      notes: String,
    },
  },
  vitals: {
    bloodPressure: {
      systolic: Number,
      diastolic: Number,
    },
    heartRate: Number,
    temperature: Number,
    weight: Number,
    height: Number,
    oxygenSaturation: Number,
  },
  notes: {
    patient: String, // Patient's notes before consultation
    doctor: String, // Doctor's notes during consultation
    private: String, // Doctor's private notes
  },
  attachments: [
    {
      filename: String,
      originalName: String,
      url: String,
      type: {
        type: String,
        enum: ["image", "document", "report", "prescription"],
      },
      uploadedBy: {
        type: String,
        enum: ["patient", "doctor"],
      },
      uploadedAt: {
        type: Date,
        default: Date.now,
      },
    },
  ],
  chat: [
    {
      sender: {
        type: String,
        enum: ["patient", "doctor"],
        required: true,
      },
      message: {
        type: String,
        required: true,
      },
      timestamp: {
        type: Date,
        default: Date.now,
      },
      type: {
        type: String,
        enum: ["text", "image", "file"],
        default: "text",
      },
      attachmentUrl: String,
    },
  ],
  rating: {
    patientRating: {
      score: {
        type: Number,
        min: 1,
        max: 5,
      },
      feedback: String,
      ratedAt: Date,
    },
    doctorRating: {
      score: {
        type: Number,
        min: 1,
        max: 5,
      },
      feedback: String,
      ratedAt: Date,
    },
  },
  payment: {
    amount: {
      type: Number,
      required: true,
    },
    status: {
      type: String,
      enum: ["pending", "paid", "refunded"],
      default: "pending",
    },
    method: {
      type: String,
      enum: ["card", "upi", "wallet", "insurance"],
    },
    transactionId: String,
    paidAt: Date,
  },
  callDetails: {
    roomId: String,
    agoraToken: String,
    recordingUrl: String,
    callQuality: {
      type: String,
      enum: ["excellent", "good", "fair", "poor"],
    },
  },
  metadata: {
    patientDevice: String,
    doctorDevice: String,
    networkQuality: String,
    browserInfo: String,
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
consultationSchema.index({ patient: 1, createdAt: -1 });
consultationSchema.index({ doctor: 1, createdAt: -1 });
consultationSchema.index({ status: 1, scheduledAt: 1 });
consultationSchema.index({ consultationId: 1 });

// Pre-save middleware
consultationSchema.pre("save", function (next) {
  this.updatedAt = Date.now();

  // Calculate duration if both start and end times are set
  if (this.startedAt && this.endedAt) {
    this.duration = Math.round((this.endedAt - this.startedAt) / (1000 * 60));
  }

  next();
});

// Virtual for estimated duration
consultationSchema.virtual("estimatedDuration").get(function () {
  if (this.type === "emergency") return 30;
  if (this.priority === "high") return 20;
  return 15; // default consultation time
});

// Method to start consultation
consultationSchema.methods.start = function () {
  this.status = "in-progress";
  this.startedAt = new Date();
  return this.save();
};

// Method to end consultation
consultationSchema.methods.end = function () {
  this.status = "completed";
  this.endedAt = new Date();
  this.duration = Math.round((this.endedAt - this.startedAt) / (1000 * 60));
  return this.save();
};

// Method to add chat message
consultationSchema.methods.addChatMessage = function (
  sender,
  message,
  type = "text",
  attachmentUrl = null
) {
  this.chat.push({
    sender,
    message,
    type,
    attachmentUrl,
    timestamp: new Date(),
  });
  return this.save();
};

// Static method to find upcoming consultations
consultationSchema.statics.findUpcoming = function (doctorId, limit = 10) {
  return this.find({
    doctor: doctorId,
    status: { $in: ["scheduled", "waiting"] },
    scheduledAt: { $gte: new Date() },
  })
    .populate("patient", "name age gender phone")
    .sort({ scheduledAt: 1 })
    .limit(limit);
};

// Static method to find consultations in queue
consultationSchema.statics.findInQueue = function (doctorId) {
  return this.find({
    doctor: doctorId,
    status: "waiting",
  })
    .populate("patient", "name age gender phone priority")
    .sort({ priority: -1, scheduledAt: 1 });
};

module.exports = mongoose.model("Consultation", consultationSchema);
