const express = require('express');
const router = express.Router();
const SymptomReport = require('../models/SymptomReport');
const OutbreakAlert = require('../models/OutbreakAlert');
const { v4: uuidv4 } = require('uuid');

// POST /api/community-health/symptoms - Submit anonymized symptom data
router.post('/symptoms', async (req, res) => {
  try {
    const {
      symptoms,
      primaryCondition,
      severity,
      location,
      ageGroup,
      gender,
      deviceId // For anonymous tracking
    } = req.body;

    // Generate anonymous ID from device ID (hashed for privacy)
    const crypto = require('crypto');
    const anonymousId = crypto.createHash('sha256').update(deviceId).digest('hex').substring(0, 16);

    // Create new symptom report
    const symptomReport = new SymptomReport({
      anonymousId,
      symptoms,
      primaryCondition,
      severity,
      location: {
        ...location,
        // Convert coordinates to GeoJSON format and round to protect privacy
        coordinates: location.coordinates ? {
          type: 'Point',
          coordinates: [
            Math.round(location.coordinates.lng * 100) / 100, // longitude first
            Math.round(location.coordinates.lat * 100) / 100   // latitude second
          ]
        } : undefined
      },
      ageGroup,
      gender,
      reportedAt: new Date(),
      syncedAt: new Date()
    });

    await symptomReport.save();

    // Trigger outbreak detection analysis asynchronously
    setImmediate(() => {
      analyzeForOutbreaks(location);
    });

    res.status(201).json({
      success: true,
      message: 'Symptom data recorded for community health monitoring',
      reportId: symptomReport._id
    });

  } catch (error) {
    console.error('Error saving symptom report:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to record symptom data',
      error: error.message
    });
  }
});

// GET /api/community-health/alerts - Get active health alerts for user's location
router.get('/alerts', async (req, res) => {
  try {
    const { pincode, lat, lng, radius = 10 } = req.query;

    let query = { status: 'active' };

    if (pincode) {
      query['affectedArea.pincodes'] = pincode;
    } else if (lat && lng) {
      query['affectedArea.centerCoordinates'] = {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(lng), parseFloat(lat)]
          },
          $maxDistance: radius * 1000 // Convert km to meters
        }
      };
    }

    const alerts = await OutbreakAlert.find(query)
      .select('alertType severity affectedArea suspectedCondition messages.userAlert createdAt')
      .sort({ createdAt: -1 })
      .limit(10);

    res.json({
      success: true,
      alerts: alerts.map(alert => ({
        id: alert._id,
        type: alert.alertType,
        severity: alert.severity,
        condition: alert.suspectedCondition,
        area: `${alert.affectedArea.block}, ${alert.affectedArea.district}`,
        message: alert.messages.userAlert,
        issuedAt: alert.createdAt
      }))
    });

  } catch (error) {
    console.error('Error fetching alerts:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch health alerts',
      error: error.message
    });
  }
});

// GET /api/community-health/statistics - Get community health statistics for admin
router.get('/statistics', async (req, res) => {
  try {
    const { timeRange = 7, location } = req.query; // Default: last 7 days
    
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - parseInt(timeRange));

    let matchQuery = {
      reportedAt: { $gte: startDate }
    };

    if (location) {
      if (location.pincode) matchQuery['location.pincode'] = location.pincode;
      if (location.block) matchQuery['location.block'] = location.block;
      if (location.district) matchQuery['location.district'] = location.district;
    }

    // Aggregate symptom data for statistics
    const symptomStats = await SymptomReport.aggregate([
      { $match: matchQuery },
      {
        $group: {
          _id: {
            condition: '$primaryCondition',
            date: { $dateToString: { format: '%Y-%m-%d', date: '$reportedAt' } }
          },
          count: { $sum: 1 },
          locations: { $addToSet: '$location.block' }
        }
      },
      { $sort: { '_id.date': -1 } }
    ]);

    // Get active alerts
    const activeAlerts = await OutbreakAlert.find({
      status: 'active',
      createdAt: { $gte: startDate }
    }).select('alertType suspectedCondition affectedArea statistics createdAt');

    // Calculate trend data
    const trendData = await calculateHealthTrends(matchQuery);

    res.json({
      success: true,
      timeRange: `${timeRange} days`,
      statistics: {
        totalReports: await SymptomReport.countDocuments(matchQuery),
        uniqueConditions: symptomStats.length,
        activeAlerts: activeAlerts.length,
        trends: trendData,
        conditionBreakdown: symptomStats,
        alerts: activeAlerts
      }
    });

  } catch (error) {
    console.error('Error generating statistics:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to generate statistics',
      error: error.message
    });
  }
});

// Outbreak detection analysis function
async function analyzeForOutbreaks(location) {
  try {
    const outbreakDetection = require('../services/outbreakDetection');
    await outbreakDetection.analyzeArea(location);
  } catch (error) {
    console.error('Error in outbreak analysis:', error);
  }
}

// Helper function to calculate health trends
async function calculateHealthTrends(baseQuery) {
  const trends = await SymptomReport.aggregate([
    { $match: baseQuery },
    {
      $group: {
        _id: {
          condition: '$primaryCondition',
          week: { $week: '$reportedAt' },
          year: { $year: '$reportedAt' }
        },
        count: { $sum: 1 },
        avgSeverity: { 
          $avg: {
            $switch: {
              branches: [
                { case: { $eq: ['$severity', 'low'] }, then: 1 },
                { case: { $eq: ['$severity', 'moderate'] }, then: 2 },
                { case: { $eq: ['$severity', 'high'] }, then: 3 },
                { case: { $eq: ['$severity', 'emergency'] }, then: 4 }
              ],
              default: 1
            }
          }
        }
      }
    },
    { $sort: { '_id.year': -1, '_id.week': -1 } }
  ]);

  return trends;
}

module.exports = router;