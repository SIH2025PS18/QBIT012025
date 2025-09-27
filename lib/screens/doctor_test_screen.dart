import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorTestScreen extends StatefulWidget {
  const DoctorTestScreen({Key? key}) : super(key: key);

  @override
  State<DoctorTestScreen> createState() => _DoctorTestScreenState();
}

class _DoctorTestScreenState extends State<DoctorTestScreen> {
  String _output = '';
  bool _isLoading = false;

  void _addOutput(String message) {
    setState(() {
      _output += '$message\n';
    });
    print(message);
  }

  Future<void> _testDoctorSystem() async {
    setState(() {
      _isLoading = true;
      _output = '';
    });

    _addOutput('🧪 Testing Doctor Creation and Login System...\n');

    try {
      // Test 1: Create a doctor
      _addOutput('1️⃣ Creating new doctor...');

      final doctorData = {
        'name': 'Dr. John Test',
        'email': 'john.test@hospital.com',
        'phone': '+1234567890',
        'speciality': 'General Practitioner',
        'qualification': 'MBBS, MD',
        'experience': 3,
        'licenseNumber': 'TEST${DateTime.now().millisecondsSinceEpoch}',
        'consultationFee': 500,
        'languages': ['en'],
        'isAvailable': true,
        'isVerified': true,
      };

      final createResponse = await http.post(
        Uri.parse('http://192.168.1.7:5001/api/doctors'),
        headers: {
          'Content-Type': 'application/json',
          // Note: In real app, admin auth token would be required
        },
        body: json.encode(doctorData),
      );

      _addOutput('📊 Create doctor response: ${createResponse.statusCode}');
      _addOutput('📋 Response body: ${createResponse.body}');

      if (createResponse.statusCode == 201 ||
          createResponse.statusCode == 200) {
        final responseData = json.decode(createResponse.body);
        if (responseData['success'] == true) {
          _addOutput('✅ Doctor created successfully!');
          final doctorInfo = responseData['data'];
          final defaultPassword = responseData['defaultPassword'];

          _addOutput('👤 Doctor: ${doctorInfo['name']}');
          _addOutput('📧 Email: ${doctorInfo['email']}');
          _addOutput('🔑 Password: $defaultPassword');
          _addOutput('🆔 Doctor ID: ${doctorInfo['doctorId']}');

          // Test 2: Try to login with created credentials
          _addOutput('\n2️⃣ Testing login with generated credentials...');

          final loginData = {
            'loginId': doctorInfo['email'],
            'password': defaultPassword,
            'userType': 'doctor',
          };

          final loginResponse = await http.post(
            Uri.parse('http://192.168.1.7:5001/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(loginData),
          );

          _addOutput('📊 Login response: ${loginResponse.statusCode}');
          _addOutput('📋 Login body: ${loginResponse.body}');

          if (loginResponse.statusCode == 200) {
            final loginResponseData = json.decode(loginResponse.body);
            if (loginResponseData['success'] == true) {
              _addOutput('✅ Login successful!');
              _addOutput(
                '👤 Logged in as: ${loginResponseData['data']['user']['name']}',
              );
              _addOutput(
                '🎫 Token received: ${loginResponseData['data']['token'] != null}',
              );
              _addOutput(
                '\n🎉 Doctor creation and login system working correctly!',
              );
            } else {
              _addOutput('❌ Login failed: ${loginResponseData['message']}');
            }
          } else {
            _addOutput(
              '❌ Login request failed with status: ${loginResponse.statusCode}',
            );
          }
        } else {
          _addOutput('❌ Doctor creation failed: ${responseData['message']}');
        }
      } else {
        _addOutput(
          '❌ Doctor creation request failed with status: ${createResponse.statusCode}',
        );
      }
    } catch (e) {
      _addOutput('❌ Error during testing: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor System Test'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 48,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Doctor Authentication Test',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Test doctor creation and login functionality',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _testDoctorSystem,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isLoading ? 'Testing...' : 'Run Test'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Output:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _output.isEmpty
                                  ? 'Press "Run Test" to start...'
                                  : _output,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
