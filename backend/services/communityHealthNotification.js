const OutbreakAlert = require('../models/OutbreakAlert');
const SymptomReport = require('../models/SymptomReport');

class CommunityHealthNotificationService {
  constructor() {
    this.config = {
      // Health authority contacts (would be loaded from database in production)
      healthAuthorities: {
        'Primary Health Centre': {
          email: 'phc@health.gov.in',
          phone: '+91-9876543210',
          role: 'primary_response'
        },
        'District Health Officer': {
          email: 'dho@health.gov.in', 
          phone: '+91-9876543211',
          role: 'district_coordination'
        },
        'State Surveillance Unit': {
          email: 'surveillance@health.gov.in',
          phone: '+91-9876543212',
          role: 'state_monitoring'
        }
      }
    };
  }

  // Send alerts to both users and health authorities
  async sendOutbreakAlerts(outbreakAlert) {
    try {
      console.log(`📢 Initiating alert notifications for ${outbreakAlert.alertId}`);

      // Send user notifications
      const userResults = await this.sendUserNotifications(outbreakAlert);
      
      // Send authority notifications
      const authorityResults = await this.sendAuthorityNotifications(outbreakAlert);

      // Update alert with notification status
      await this.updateNotificationStatus(outbreakAlert._id, userResults, authorityResults);

      return {
        success: true,
        userNotifications: userResults,
        authorityNotifications: authorityResults
      };

    } catch (error) {
      console.error('Error sending outbreak alerts:', error);
      return { success: false, error: error.message };
    }
  }

  // Send health advisories to users in affected area
  async sendUserNotifications(outbreakAlert) {
    try {
      const affectedArea = outbreakAlert.affectedArea;
      
      // In a real implementation, this would:
      // 1. Query user database for users in affected pincodes/coordinates
      // 2. Send push notifications via FCM/APNS
      // 3. Send in-app notifications
      // 4. Send SMS for critical alerts

      // For now, we'll simulate the notification process
      const estimatedUsers = await this.estimateAffectedUsers(affectedArea);
      
      const notificationPayload = {
        title: outbreakAlert.messages.userAlert.title,
        body: outbreakAlert.messages.userAlert.message,
        data: {
          alertId: outbreakAlert.alertId,
          alertType: outbreakAlert.alertType,
          severity: outbreakAlert.severity,
          precautions: JSON.stringify(outbreakAlert.messages.userAlert.precautions),
          urgency: outbreakAlert.messages.userAlert.urgency
        },
        priority: outbreakAlert.severity === 'critical' ? 'high' : 'normal'
      };

      // Simulate notification sending
      console.log(`📱 Sending user notifications to ~${estimatedUsers} users in affected area`);
      console.log(`🔔 Notification: ${notificationPayload.title}`);
      console.log(`📝 Message: ${notificationPayload.body}`);
      
      // Log precautions for users
      console.log('📋 Recommended precautions:');
      outbreakAlert.messages.userAlert.precautions.forEach((precaution, index) => {
        console.log(`   ${index + 1}. ${precaution}`);
      });

      return {
        sent: estimatedUsers,
        reached: Math.floor(estimatedUsers * 0.8), // Assuming 80% delivery rate
        method: 'push_notification',
        payload: notificationPayload
      };

    } catch (error) {
      console.error('Error sending user notifications:', error);
      return { sent: 0, reached: 0, error: error.message };
    }
  }

  // Send detailed reports to health authorities
  async sendAuthorityNotifications(outbreakAlert) {
    const notifications = [];

    try {
      for (const [authority, contact] of Object.entries(this.config.healthAuthorities)) {
        const report = this.generateAuthorityReport(outbreakAlert, authority);
        
        // In production, this would send actual emails/SMS
        console.log(`📧 Sending alert to ${authority} (${contact.email})`);
        console.log(`📞 Emergency contact: ${contact.phone}`);
        console.log(`📊 Report Summary: ${report.summary}`);
        console.log(`🔍 Analysis: ${report.analysis}`);
        console.log(`📋 Recommended Actions:`);
        report.actions.forEach((action, index) => {
          console.log(`   ${index + 1}. ${action}`);
        });
        console.log('---');

        notifications.push({
          authority,
          contactInfo: contact.email,
          notifiedAt: new Date(),
          reportSent: true
        });
      }

      return notifications;

    } catch (error) {
      console.error('Error sending authority notifications:', error);
      return [];
    }
  }

  generateAuthorityReport(outbreakAlert, authorityType) {
    const baseReport = outbreakAlert.messages.authorityReport;
    
    // Customize report based on authority type
    let customActions = [...baseReport.recommendedActions];
    
    if (authorityType === 'Primary Health Centre') {
      customActions.unshift('Deploy field investigation team immediately');
      customActions.push('Set up temporary health camps if needed');
    } else if (authorityType === 'District Health Officer') {
      customActions.unshift('Coordinate with neighboring PHCs');
      customActions.push('Prepare district-wide response plan');
    } else if (authorityType === 'State Surveillance Unit') {
      customActions.unshift('Update state surveillance database');
      customActions.push('Monitor for similar patterns in other districts');
    }

    return {
      summary: baseReport.summary,
      analysis: baseReport.detailedAnalysis,
      actions: customActions,
      alertDetails: {
        id: outbreakAlert.alertId,
        severity: outbreakAlert.severity,
        affectedArea: outbreakAlert.affectedArea,
        statistics: outbreakAlert.statistics,
        confidence: outbreakAlert.detectionMetadata.confidence
      }
    };
  }

  async estimateAffectedUsers(affectedArea) {
    // Estimate number of app users in affected area
    // In production, this would query actual user database
    
    // For simulation: assume 2% of population uses the app
    const populationEstimate = affectedArea.pincodes.length * 20000; // Rough estimate
    const appUserEstimate = Math.floor(populationEstimate * 0.02);
    
    return Math.min(appUserEstimate, 10000); // Cap at 10k for testing
  }

  async updateNotificationStatus(alertId, userResults, authorityResults) {
    await OutbreakAlert.findByIdAndUpdate(alertId, {
      $set: {
        'notifications.usersSent': userResults.sent || 0,
        'notifications.usersReached': userResults.reached || 0,
        'notifications.authoritiesNotified': authorityResults
      }
    });
  }

  // Get health advisories for a specific location
  async getActiveAlertsForLocation(location) {
    try {
      const query = {
        status: 'active',
        $or: [
          { 'affectedArea.pincodes': location.pincode },
          { 'affectedArea.block': location.block }
        ]
      };

      if (location.coordinates) {
        query['affectedArea.centerCoordinates'] = {
          $near: {
            $geometry: {
              type: 'Point',
              coordinates: [location.coordinates.lng, location.coordinates.lat]
            },
            $maxDistance: 10000 // 10km radius
          }
        };
      }

      const alerts = await OutbreakAlert.find(query)
        .select('alertType severity suspectedCondition messages.userAlert createdAt affectedArea')
        .sort({ createdAt: -1 });

      return alerts.map(alert => ({
        id: alert._id,
        type: alert.alertType,
        severity: alert.severity,
        condition: alert.suspectedCondition,
        message: alert.messages.userAlert,
        area: `${alert.affectedArea.block}, ${alert.affectedArea.district}`,
        issuedAt: alert.createdAt
      }));

    } catch (error) {
      console.error('Error fetching alerts for location:', error);
      return [];
    }
  }

  // Send follow-up notifications when outbreak status changes
  async sendStatusUpdate(outbreakAlert, newStatus, updateMessage) {
    console.log(`📢 Outbreak status update: ${outbreakAlert.alertId} -> ${newStatus}`);
    console.log(`📝 Update message: ${updateMessage}`);
    
    // In production, send update notifications to previously notified users and authorities
    
    await OutbreakAlert.findByIdAndUpdate(outbreakAlert._id, {
      status: newStatus,
      'followUp.resolution': updateMessage,
      'followUp.resolvedAt': new Date()
    });
  }
}

module.exports = new CommunityHealthNotificationService();