const SymptomReport = require('../models/SymptomReport');
const OutbreakAlert = require('../models/OutbreakAlert');
const { v4: uuidv4 } = require('uuid');

class OutbreakDetectionService {
  constructor() {
    // Statistical thresholds for outbreak detection
    this.config = {
      // Minimum cases needed to trigger investigation
      minCasesThreshold: 5,
      
      // Time windows for analysis
      analysisWindows: [24, 72, 168], // 1 day, 3 days, 7 days (hours)
      
      // Statistical significance thresholds
      significanceThresholds: {
        low: 1.5,      // 50% increase
        moderate: 2.0,  // 100% increase  
        high: 3.0,      // 200% increase
        critical: 5.0   // 400% increase
      },
      
      // Condition groupings for related symptom detection
      conditionGroups: {
        'gastrointestinal': ['diarrhea', 'vomiting', 'nausea', 'stomach pain', 'food poisoning'],
        'respiratory': ['cough', 'fever', 'cold', 'flu', 'pneumonia', 'bronchitis'],
        'vector_borne': ['dengue', 'malaria', 'chikungunya', 'typhoid'],
        'skin_conditions': ['rash', 'itching', 'skin infection', 'allergic reaction'],
        'neurological': ['headache', 'dizziness', 'seizure', 'paralysis']
      }
    };
  }

  // Main analysis function called when new symptom data arrives
  async analyzeArea(location) {
    try {
      console.log(`🔍 Analyzing outbreak patterns for area: ${location.block}, ${location.district}`);
      
      // Analyze each time window
      for (const hours of this.config.analysisWindows) {
        await this.analyzeTimeWindow(location, hours);
      }
      
    } catch (error) {
      console.error('Error in outbreak analysis:', error);
    }
  }

  async analyzeTimeWindow(location, hours) {
    const windowStart = new Date();
    windowStart.setHours(windowStart.getHours() - hours);

    // Get current period data
    const currentData = await this.getSymptomData(location, windowStart, new Date());
    
    // Get historical baseline (same window, one period ago)
    const baselineStart = new Date(windowStart);
    baselineStart.setHours(baselineStart.getHours() - hours);
    const baselineData = await this.getSymptomData(location, baselineStart, windowStart);

    // Analyze each condition group
    for (const [groupName, conditions] of Object.entries(this.config.conditionGroups)) {
      await this.analyzeConditionGroup(location, groupName, conditions, currentData, baselineData, hours);
    }

    // Analyze individual high-impact conditions
    await this.analyzeIndividualConditions(location, currentData, baselineData, hours);
  }

  async getSymptomData(location, startDate, endDate) {
    const query = {
      reportedAt: { $gte: startDate, $lte: endDate },
      $or: [
        { 'location.pincode': location.pincode },
        { 'location.block': location.block }
      ]
    };

    const data = await SymptomReport.aggregate([
      { $match: query },
      {
        $group: {
          _id: '$primaryCondition',
          count: { $sum: 1 },
          symptoms: { $push: '$symptoms' },
          ageGroups: { $push: '$ageGroup' },
          genders: { $push: '$gender' },
          locations: { $addToSet: '$location.village' },
          coordinates: { $push: '$location.coordinates' }
        }
      }
    ]);

    return data;
  }

  async analyzeConditionGroup(location, groupName, conditions, currentData, baselineData, hours) {
    const currentCount = this.getGroupCount(currentData, conditions);
    const baselineCount = this.getGroupCount(baselineData, conditions);

    if (currentCount < this.config.minCasesThreshold) return;

    const increaseRatio = baselineCount > 0 ? currentCount / baselineCount : currentCount;
    const significance = this.calculateSignificance(increaseRatio);

    if (significance && increaseRatio >= this.config.significanceThresholds.low) {
      console.log(`🚨 Potential ${groupName} outbreak detected: ${currentCount} cases (${(increaseRatio * 100).toFixed(1)}% increase)`);
      
      await this.createOutbreakAlert(
        location,
        groupName,
        conditions,
        currentData,
        {
          currentCount,
          baselineCount,
          increaseRatio,
          significance,
          timeWindow: hours
        }
      );
    }
  }

  async analyzeIndividualConditions(location, currentData, baselineData, hours) {
    for (const current of currentData) {
      if (current.count < this.config.minCasesThreshold) continue;

      const baseline = baselineData.find(b => b._id === current._id);
      const baselineCount = baseline ? baseline.count : 0;
      const increaseRatio = baselineCount > 0 ? current.count / baselineCount : current.count;
      
      if (increaseRatio >= this.config.significanceThresholds.moderate) {
        const significance = this.calculateSignificance(increaseRatio);
        
        console.log(`🚨 Individual condition spike: ${current._id} - ${current.count} cases (${(increaseRatio * 100).toFixed(1)}% increase)`);
        
        await this.createOutbreakAlert(
          location,
          current._id,
          [current._id],
          [current],
          {
            currentCount: current.count,
            baselineCount,
            increaseRatio,
            significance,
            timeWindow: hours
          }
        );
      }
    }
  }

  getGroupCount(data, conditions) {
    return data.reduce((total, item) => {
      return conditions.includes(item._id.toLowerCase()) ? total + item.count : total;
    }, 0);
  }

  calculateSignificance(ratio) {
    if (ratio >= this.config.significanceThresholds.critical) return 'critical';
    if (ratio >= this.config.significanceThresholds.high) return 'high';
    if (ratio >= this.config.significanceThresholds.moderate) return 'moderate';
    if (ratio >= this.config.significanceThresholds.low) return 'low';
    return null;
  }

  async createOutbreakAlert(location, conditionName, relatedConditions, symptomData, statistics) {
    // Check if alert already exists for this condition and area
    const existingAlert = await OutbreakAlert.findOne({
      'affectedArea.block': location.block,
      'affectedArea.district': location.district,
      suspectedCondition: conditionName,
      status: 'active',
      createdAt: { $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) } // Last 24 hours
    });

    if (existingAlert) {
      console.log(`Alert already exists for ${conditionName} in ${location.block}`);
      return;
    }

    const alertId = `ALERT_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    
    // Generate user-facing health advisory
    const userAlert = this.generateUserAlert(conditionName, relatedConditions, statistics.significance);
    
    // Generate authority report
    const authorityReport = this.generateAuthorityReport(
      conditionName,
      location,
      symptomData,
      statistics
    );

    const outbreakAlert = new OutbreakAlert({
      alertId,
      alertType: statistics.significance === 'critical' ? 'outbreak_confirmed' : 'outbreak_suspected',
      severity: statistics.significance,
      affectedArea: {
        state: location.state,
        district: location.district,
        block: location.block,
        villages: location.village ? [location.village] : [],
        pincodes: [location.pincode],
        centerCoordinates: location.coordinates
      },
      suspectedCondition: conditionName,
      relatedSymptoms: relatedConditions,
      statistics: {
        totalCases: statistics.currentCount,
        timeRange: {
          start: new Date(Date.now() - statistics.timeWindow * 60 * 60 * 1000),
          end: new Date()
        },
        casesPerThousand: this.estimateCasesPerThousand(statistics.currentCount, location),
        increasePercentage: ((statistics.increaseRatio - 1) * 100),
        confidenceLevel: this.calculateConfidence(statistics.increaseRatio, statistics.currentCount)
      },
      messages: {
        userAlert,
        authorityReport
      },
      detectionMetadata: {
        algorithm: 'statistical_threshold_v1',
        version: '1.0.0',
        confidence: this.calculateConfidence(statistics.increaseRatio, statistics.currentCount),
        threshold: this.config.significanceThresholds[statistics.significance],
        rawData: { statistics, symptomData }
      }
    });

    await outbreakAlert.save();
    
    // Trigger notification system
    await this.sendAlerts(outbreakAlert);
    
    console.log(`✅ Outbreak alert created: ${alertId} for ${conditionName} in ${location.block}`);
    
    return outbreakAlert;
  }

  generateUserAlert(condition, relatedConditions, severity) {
    const precautionsByCondition = {
      gastrointestinal: [
        'Drink only boiled or bottled water',
        'Wash hands frequently with soap',
        'Avoid street food and raw vegetables',
        'Use oral rehydration solution (ORS) if experiencing diarrhea'
      ],
      respiratory: [
        'Wear a mask in crowded places',
        'Maintain social distancing',
        'Cover coughs and sneezes',
        'Seek medical attention if fever persists'
      ],
      vector_borne: [
        'Use mosquito nets and repellents',
        'Remove stagnant water around homes',
        'Wear long-sleeved clothing during evening hours',
        'Seek immediate medical attention for high fever'
      ],
      default: [
        'Maintain good hygiene practices',
        'Avoid crowded places if possible',
        'Seek medical attention if symptoms worsen',
        'Follow local health guidelines'
      ]
    };

    const precautions = precautionsByCondition[condition] || precautionsByCondition.default;
    
    return {
      title: `Health Advisory: Increased ${condition.replace(/_/g, ' ')} cases in your area`,
      message: `Our monitoring system has detected an increase in ${condition.replace(/_/g, ' ')} related cases in your area. Please take preventive measures and consult a healthcare provider if you experience symptoms.`,
      precautions,
      urgency: severity === 'critical' ? 'urgent' : severity === 'high' ? 'warning' : 'info'
    };
  }

  generateAuthorityReport(condition, location, symptomData, statistics) {
    return {
      summary: `Outbreak alert for ${condition} in ${location.block}, ${location.district}. ${statistics.currentCount} cases detected in last ${statistics.timeWindow} hours (${((statistics.increaseRatio - 1) * 100).toFixed(1)}% increase from baseline).`,
      detailedAnalysis: `Statistical analysis shows a ${statistics.significance} significance outbreak pattern. Baseline: ${statistics.baselineCount} cases, Current: ${statistics.currentCount} cases.`,
      recommendedActions: [
        'Immediate field investigation',
        'Contact tracing of affected individuals', 
        'Environmental assessment of common sources',
        'Public health intervention if confirmed',
        'Enhanced surveillance in surrounding areas'
      ]
    };
  }

  estimateCasesPerThousand(cases, location) {
    // Rough estimation based on typical block population (varies widely)
    const estimatedPopulation = 50000; // Average rural block population
    return ((cases / estimatedPopulation) * 1000).toFixed(2);
  }

  calculateConfidence(ratio, caseCount) {
    // Simple confidence calculation based on case count and ratio
    let confidence = Math.min(90, (caseCount * 10) + (ratio * 20));
    return Math.max(30, confidence); // Minimum 30% confidence
  }

  async sendAlerts(outbreakAlert) {
    try {
      const notificationService = require('./communityHealthNotification');
      const results = await notificationService.sendOutbreakAlerts(outbreakAlert);
      
      console.log(`✅ Alert notifications sent for ${outbreakAlert.alertId}`);
      console.log(`📱 Users notified: ${results.userNotifications?.sent || 0}`);
      console.log(`🏥 Authorities notified: ${results.authorityNotifications?.length || 0}`);
      
      return results;
    } catch (error) {
      console.error('Error sending alerts:', error);
    }
  }
}

module.exports = new OutbreakDetectionService();