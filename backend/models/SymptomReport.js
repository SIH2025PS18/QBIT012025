const mongoose = require('mongoose');

// Schema for anonymized symptom reporting
const SymptomReportSchema = new mongoose.Schema({
  // Anonymized identifier (not linked to user account)
  anonymousId: {
    type: String,
    required: true,
    index: true
  },
  
  // Symptoms data
  symptoms: [{
    type: String,
    required: true
  }],
  
  // Primary complaint/condition identified by AI
  primaryCondition: {
    type: String,
    required: true
  },
  
  // Severity assessment from AI
  severity: {
    type: String,
    enum: ['low', 'moderate', 'high', 'emergency'],
    required: true
  },
  
  // Geographic information (anonymized to block/village level)
  location: {
    state: { type: String, required: true },
    district: { type: String, required: true },
    block: { type: String, required: true },
    village: String, // Optional for privacy
    pincode: { type: String, required: true },
    
    // Approximate coordinates (rounded to protect privacy)
    coordinates: {
      type: {
        type: String,
        enum: ['Point'],
        default: 'Point'
      },
      coordinates: {
        type: [Number], // [longitude, latitude]
        index: '2dsphere'
      }
    }
  },
  
  // Age group for epidemiological analysis
  ageGroup: {
    type: String,
    enum: ['0-5', '6-18', '19-35', '36-60', '60+'],
    required: true
  },
  
  // Gender for analysis
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    required: true
  },
  
  // Timestamp information
  reportedAt: {
    type: Date,
    default: Date.now,
    index: true
  },
  
  // Data sync information
  syncedAt: {
    type: Date,
    default: Date.now
  },
  
  // Flag for processed status in outbreak detection
  processed: {
    type: Boolean,
    default: false,
    index: true
  },
  
  // Associated outbreak alerts (if any)
  outbreakAlerts: [{
    alertId: { type: mongoose.Schema.Types.ObjectId, ref: 'OutbreakAlert' },
    associatedAt: { type: Date, default: Date.now }
  }]
}, {
  timestamps: true,
  collection: 'symptom_reports'
});

// Indexes for efficient querying
SymptomReportSchema.index({ 'location.pincode': 1, reportedAt: -1 });
SymptomReportSchema.index({ 'location.block': 1, reportedAt: -1 });
SymptomReportSchema.index({ primaryCondition: 1, reportedAt: -1 });
SymptomReportSchema.index({ symptoms: 1, reportedAt: -1 });
SymptomReportSchema.index({ 'location.coordinates': '2dsphere' });

module.exports = mongoose.model('SymptomReport', SymptomReportSchema);