const mongoose = require('mongoose');

// Schema for outbreak alerts and community health warnings
const OutbreakAlertSchema = new mongoose.Schema({
  // Alert identification
  alertId: {
    type: String,
    unique: true,
    required: true,
    index: true
  },
  
  // Alert type and severity
  alertType: {
    type: String,
    enum: ['outbreak_suspected', 'outbreak_confirmed', 'health_advisory', 'emergency'],
    required: true
  },
  
  severity: {
    type: String,
    enum: ['low', 'moderate', 'high', 'critical'],
    required: true
  },
  
  // Geographic scope
  affectedArea: {
    state: { type: String, required: true },
    district: { type: String, required: true },
    block: { type: String, required: true },
    villages: [String], // Multiple villages can be affected
    pincodes: [String],
    
    // Radius of alert area
    radius: { type: Number, default: 5 }, // km
    centerCoordinates: {
      lat: Number,
      lng: Number
    }
  },
  
  // Outbreak details
  suspectedCondition: {
    type: String,
    required: true
  },
  
  relatedSymptoms: [{
    type: String,
    required: true
  }],
  
  // Statistical information
  statistics: {
    totalCases: { type: Number, required: true },
    timeRange: {
      start: { type: Date, required: true },
      end: { type: Date, required: true }
    },
    
    // Demographic breakdown
    ageGroupBreakdown: [{
      ageGroup: String,
      count: Number
    }],
    
    genderBreakdown: [{
      gender: String,
      count: Number
    }],
    
    // Rate calculations
    casesPerThousand: Number,
    increasePercentage: Number,
    confidenceLevel: Number // Statistical confidence in outbreak detection
  },
  
  // Alert messages
  messages: {
    // Public health advisory for users
    userAlert: {
      title: { type: String, required: true },
      message: { type: String, required: true },
      precautions: [String],
      urgency: { type: String, enum: ['info', 'warning', 'urgent'], default: 'info' }
    },
    
    // Detailed report for health authorities
    authorityReport: {
      summary: { type: String, required: true },
      detailedAnalysis: String,
      recommendedActions: [String],
      dataAttachments: [String] // File paths to detailed data exports
    }
  },
  
  // Status tracking
  status: {
    type: String,
    enum: ['active', 'resolved', 'false_positive', 'under_investigation'],
    default: 'active'
  },
  
  // Notification tracking
  notifications: {
    usersSent: { type: Number, default: 0 },
    usersReached: { type: Number, default: 0 },
    authoritiesNotified: [{
      authority: String,
      contactInfo: String,
      notifiedAt: { type: Date, default: Date.now }
    }]
  },
  
  // AI analysis metadata
  detectionMetadata: {
    algorithm: String,
    version: String,
    confidence: Number,
    threshold: Number,
    rawData: mongoose.Schema.Types.Mixed
  },
  
  // Follow-up information
  followUp: {
    investigationStarted: Boolean,
    investigatedBy: String,
    resolution: String,
    resolvedAt: Date,
    preventiveMeasures: [String]
  }
}, {
  timestamps: true,
  collection: 'outbreak_alerts'
});

// Indexes for efficient querying
OutbreakAlertSchema.index({ 'affectedArea.pincode': 1, status: 1 });
OutbreakAlertSchema.index({ 'affectedArea.block': 1, alertType: 1 });
OutbreakAlertSchema.index({ suspectedCondition: 1, createdAt: -1 });
OutbreakAlertSchema.index({ status: 1, createdAt: -1 });
OutbreakAlertSchema.index({ 'affectedArea.centerCoordinates': '2dsphere' });

module.exports = mongoose.model('OutbreakAlert', OutbreakAlertSchema);