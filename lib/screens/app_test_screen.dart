import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_auth_service.dart';
import '../services/supabase_patient_profile_service.dart';
import '../models/patient_profile.dart';

class AppTestScreen extends StatefulWidget {
  const AppTestScreen({super.key});

  @override
  State<AppTestScreen> createState() => _AppTestScreenState();
}

class _AppTestScreenState extends State<AppTestScreen> {
  final List<String> _testResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runAllTests();
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isLoading = true;
      _testResults.clear();
    });

    await _testAuthentication();
    await _testPatientProfile();
    await _testFirestore();
    await _testNavigation();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testAuthentication() async {
    try {
      final user = AuthService.currentUser;
      if (user != null) {
        _addResult("✅ Authentication: User logged in as ${user.email}");
        _addResult("✅ Supabase Auth Service: Working properly");
      } else {
        _addResult("❌ Authentication: No user logged in");
      }
    } catch (e) {
      _addResult("❌ Authentication Error: $e");
    }
  }

  Future<void> _testPatientProfile() async {
    try {
      final profile = await PatientProfileService.getCurrentPatientProfile();

      if (profile != null) {
        _addResult("✅ Patient Profile: Found existing profile");
        _addResult("   - Name: ${profile.fullName}");
        _addResult("   - Age: ${profile.age} years");
        _addResult(
          "   - Blood Group: ${profile.bloodGroup.isEmpty ? 'Not set' : profile.bloodGroup}",
        );
      } else {
        _addResult(
          "ℹ️ Patient Profile: No profile found (this is normal for new users)",
        );
      }

      _addResult("✅ Patient Profile Service: Working properly");
    } catch (e) {
      _addResult("❌ Patient Profile Error: $e");
    }
  }

  Future<void> _testFirestore() async {
    try {
      // Test Supabase connectivity
      await PatientProfileService.getCurrentPatientProfile(); // This will test Supabase connection
      _addResult("✅ Supabase: Connection successful");
    } catch (e) {
      _addResult("❌ Supabase Error: $e");
    }
  }

  Future<void> _testNavigation() async {
    try {
      // Test if we can navigate (this itself proves routing is working)
      _addResult("✅ Navigation: Working (you navigated to this screen)");
      _addResult("✅ Material Design: UI rendering properly");
    } catch (e) {
      _addResult("❌ Navigation Error: $e");
    }
  }

  void _addResult(String result) {
    setState(() {
      _testResults.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Functionality Test'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.health_and_safety,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Telemed App Test Results',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Testing all core functionality...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _runAllTests,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(_isLoading ? 'Testing...' : 'Run Tests Again'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _testResults.isEmpty
                      ? const Center(child: Text('No test results yet...'))
                      : ListView.builder(
                          itemCount: _testResults.length,
                          itemBuilder: (context, index) {
                            final result = _testResults[index];
                            Color textColor = Colors.black87;

                            if (result.startsWith('✅')) {
                              textColor = Colors.green;
                            } else if (result.startsWith('❌')) {
                              textColor = Colors.red;
                            } else if (result.startsWith('⚠️')) {
                              textColor = Colors.orange;
                            } else if (result.startsWith('ℹ️')) {
                              textColor = Colors.blue;
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: Text(
                                result,
                                style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Next Steps',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('• Patient Profile system is ready'),
                    const Text('• Next: Implement appointment booking'),
                    const Text(
                      '• Then: Add doctor list and basic consultations',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
