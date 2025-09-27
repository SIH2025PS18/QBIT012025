import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedSection = 'general';

  // General Settings
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  bool _darkMode = true;
  String _language = 'English';
  String _timezone = 'Asia/Kolkata';

  // Security Settings
  bool _twoFactorAuth = false;
  bool _biometricAuth = true;
  int _sessionTimeout = 30;
  bool _passwordComplexity = true;

  // System Settings
  bool _autoBackup = true;
  String _backupFrequency = 'Daily';
  bool _maintenanceMode = false;
  bool _debugMode = false;
  int _maxConcurrentUsers = 100;

  // Hospital Settings
  String _hospitalName = 'City General Hospital';
  String _hospitalAddress = '123 Medical Center Drive, Healthcare City';
  String _hospitalPhone = '+91 9876543210';
  String _hospitalEmail = 'admin@hospital.com';
  String _emergencyContact = '+91 9876543211';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Row(
                    children: [
                      _buildSidebar(),
                      Expanded(
                        child: _buildContent(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D29),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2D3F))),
      ),
      child: Row(
        children: [
          const Text(
            'System Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D29),
        border: Border(right: BorderSide(color: Color(0xFF2A2D3F))),
      ),
      child: Column(
        children: [
          _buildSidebarItem('general', Icons.settings, 'General'),
          _buildSidebarItem('security', Icons.security, 'Security'),
          _buildSidebarItem(
              'notifications', Icons.notifications, 'Notifications'),
          _buildSidebarItem('system', Icons.computer, 'System'),
          _buildSidebarItem('hospital', Icons.local_hospital, 'Hospital Info'),
          _buildSidebarItem('users', Icons.people, 'User Management'),
          _buildSidebarItem('backup', Icons.backup, 'Backup & Recovery'),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String section, IconData icon, String title) {
    final isSelected = _selectedSection == section;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2A2D3F) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[400],
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedSection = section;
          });
        },
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedSection) {
      case 'general':
        return _buildGeneralSettings();
      case 'security':
        return _buildSecuritySettings();
      case 'notifications':
        return _buildNotificationSettings();
      case 'system':
        return _buildSystemSettings();
      case 'hospital':
        return _buildHospitalSettings();
      case 'users':
        return _buildUserManagement();
      case 'backup':
        return _buildBackupSettings();
      default:
        return _buildGeneralSettings();
    }
  }

  Widget _buildGeneralSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('General Settings'),
          const SizedBox(height: 24),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Dark Mode',
              'Enable dark theme for the admin panel',
              _darkMode,
              (value) => setState(() => _darkMode = value),
            ),
            _buildDropdownSetting(
              'Language',
              'Select the interface language',
              _language,
              ['English', 'Hindi', 'Spanish', 'French'],
              (value) => setState(() => _language = value!),
            ),
            _buildDropdownSetting(
              'Timezone',
              'Select your timezone',
              _timezone,
              ['Asia/Kolkata', 'UTC', 'America/New_York', 'Europe/London'],
              (value) => setState(() => _timezone = value!),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Security Settings'),
          const SizedBox(height: 24),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Two-Factor Authentication',
              'Require 2FA for admin access',
              _twoFactorAuth,
              (value) => setState(() => _twoFactorAuth = value),
            ),
            _buildSwitchSetting(
              'Biometric Authentication',
              'Allow fingerprint/face ID login',
              _biometricAuth,
              (value) => setState(() => _biometricAuth = value),
            ),
            _buildSliderSetting(
              'Session Timeout',
              'Auto-logout after inactivity (minutes)',
              _sessionTimeout.toDouble(),
              15,
              120,
              (value) => setState(() => _sessionTimeout = value.round()),
            ),
            _buildSwitchSetting(
              'Password Complexity',
              'Enforce strong password requirements',
              _passwordComplexity,
              (value) => setState(() => _passwordComplexity = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Notification Settings'),
          const SizedBox(height: 24),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Email Notifications',
              'Receive important updates via email',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchSetting(
              'SMS Notifications',
              'Receive emergency alerts via SMS',
              _smsNotifications,
              (value) => setState(() => _smsNotifications = value),
            ),
            _buildSwitchSetting(
              'Push Notifications',
              'Receive real-time push notifications',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSystemSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('System Settings'),
          const SizedBox(height: 24),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Auto Backup',
              'Automatically backup system data',
              _autoBackup,
              (value) => setState(() => _autoBackup = value),
            ),
            _buildDropdownSetting(
              'Backup Frequency',
              'How often to backup data',
              _backupFrequency,
              ['Hourly', 'Daily', 'Weekly', 'Monthly'],
              (value) => setState(() => _backupFrequency = value!),
            ),
            _buildSwitchSetting(
              'Maintenance Mode',
              'Put system in maintenance mode',
              _maintenanceMode,
              (value) => setState(() => _maintenanceMode = value),
            ),
            _buildSwitchSetting(
              'Debug Mode',
              'Enable debug logging (development only)',
              _debugMode,
              (value) => setState(() => _debugMode = value),
            ),
            _buildSliderSetting(
              'Max Concurrent Users',
              'Maximum number of concurrent users',
              _maxConcurrentUsers.toDouble(),
              50,
              500,
              (value) => setState(() => _maxConcurrentUsers = value.round()),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildHospitalSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Hospital Information'),
          const SizedBox(height: 24),
          _buildSettingsCard([
            _buildTextFieldSetting(
              'Hospital Name',
              'Enter hospital name',
              _hospitalName,
              (value) => setState(() => _hospitalName = value),
            ),
            _buildTextFieldSetting(
              'Hospital Address',
              'Enter complete address',
              _hospitalAddress,
              (value) => setState(() => _hospitalAddress = value),
              maxLines: 3,
            ),
            _buildTextFieldSetting(
              'Hospital Phone',
              'Enter main phone number',
              _hospitalPhone,
              (value) => setState(() => _hospitalPhone = value),
            ),
            _buildTextFieldSetting(
              'Hospital Email',
              'Enter official email address',
              _hospitalEmail,
              (value) => setState(() => _hospitalEmail = value),
            ),
            _buildTextFieldSetting(
              'Emergency Contact',
              'Enter emergency contact number',
              _emergencyContact,
              (value) => setState(() => _emergencyContact = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildUserManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('User Management'),
          const SizedBox(height: 24),
          _buildComingSoonCard(
              'User management features including role assignments, permissions, and user activity monitoring will be available soon.'),
        ],
      ),
    );
  }

  Widget _buildBackupSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Backup & Recovery'),
          const SizedBox(height: 24),
          _buildComingSoonCard(
              'Advanced backup and recovery options including scheduled backups, restore points, and disaster recovery will be available soon.'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2D3F)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildComingSoonCard(String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2D3F)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Coming Soon',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF6B9D),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(String title, String subtitle, String value,
      List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: const Color(0xFF2A2D3F),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2A2D3F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(String title, String subtitle, double value,
      double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${value.round()}',
                style: const TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            activeColor: const Color(0xFFFF6B9D),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSetting(
      String title, String hint, String value, ValueChanged<String> onChanged,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFF2A2D3F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implement save settings functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
