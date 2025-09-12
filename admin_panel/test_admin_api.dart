import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Test admin panel functionality
  await testAdminPanelFunctionality();
}

Future<void> testAdminPanelFunctionality() async {
  const String baseUrl = 'https://telemed18.onrender.com/api';

  // Test 1: Check if backend is accessible
  print('=== Testing Backend Connectivity ===');
  try {
    final response = await http.get(Uri.parse('$baseUrl/health'));
    print('Backend status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('✅ Backend is accessible');
    } else {
      print('❌ Backend returned status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Backend connectivity error: $e');
  }

  // Test 2: Try to get dashboard stats without authentication
  print('\n=== Testing Dashboard Stats (No Auth) ===');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/dashboard/stats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print('Dashboard stats status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 401) {
      print('✅ Authentication correctly required for admin endpoints');
    }
  } catch (e) {
    print('❌ Dashboard stats error: $e');
  }

  // Test 3: Try to get doctors without authentication
  print('\n=== Testing Get Doctors (No Auth) ===');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/doctors'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print('Get doctors status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 401) {
      print('✅ Authentication correctly required for doctor endpoints');
    }
  } catch (e) {
    print('❌ Get doctors error: $e');
  }

  // Test 4: Create admin user first
  print('\n=== Creating Admin User ===');
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-admin'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print('Reset admin status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Admin user created successfully');
    }
  } catch (e) {
    print('❌ Admin creation error: $e');
  }

  // Test 5: Try admin login
  print('\n=== Testing Admin Login ===');
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'loginId': 'admin@telemed.com',
        'password': 'password',
        'userType': 'admin',
      }),
    );
    print('Admin login status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['data']?['token'] != null) {
        print('✅ Admin login successful');
        final token = data['data']['token'];

        // Test authenticated requests
        await testAuthenticatedRequests(baseUrl, token);
      } else {
        print('❌ Admin login failed: ${data['message']}');
      }
    } else {
      print('❌ Admin login failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Admin login error: $e');
  }
}

Future<void> testAuthenticatedRequests(String baseUrl, String token) async {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Test dashboard stats with authentication
  print('\n=== Testing Dashboard Stats (With Auth) ===');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/dashboard/stats'),
      headers: headers,
    );
    print('Dashboard stats status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        print('✅ Dashboard stats retrieved successfully');
        print('Stats: ${data['data']}');
      }
    }
  } catch (e) {
    print('❌ Authenticated dashboard stats error: $e');
  }

  // Test get doctors with authentication
  print('\n=== Testing Get Doctors (With Auth) ===');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/doctors'),
      headers: headers,
    );
    print('Get doctors status: ${response.statusCode}');
    print(
        'Response preview: ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final doctors = data['data'] as List;
        print('✅ Doctors retrieved successfully');
        print('Number of doctors: ${doctors.length}');
      }
    }
  } catch (e) {
    print('❌ Authenticated get doctors error: $e');
  }

  // Test get patients with authentication
  print('\n=== Testing Get Patients (With Auth) ===');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/patients'),
      headers: headers,
    );
    print('Get patients status: ${response.statusCode}');
    print(
        'Response preview: ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final patients = data['data'] as List;
        print('✅ Patients retrieved successfully');
        print('Number of patients: ${patients.length}');
      }
    }
  } catch (e) {
    print('❌ Authenticated get patients error: $e');
  }
}
