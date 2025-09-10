import 'package:flutter/material.dart';
import '../services/simple_auth_service.dart';
import '../services/supabase_auth_service.dart';
import '../services/connection_test_service.dart';

class AuthDebugScreen extends StatefulWidget {
  const AuthDebugScreen({super.key});

  @override
  State<AuthDebugScreen> createState() => _AuthDebugScreenState();
}

class _AuthDebugScreenState extends State<AuthDebugScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final List<String> _logs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default test values
    _emailController.text = 'test@test.com';
    _passwordController.text = '123456789';
    _nameController.text = 'Test User';
    _addLog('Debug screen initialized');
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(
        0,
        '${DateTime.now().toIso8601String().substring(11, 19)}: $message',
      );
    });
    print('🔍 DEBUG: $message');
  }

  Future<void> _testConnection() async {
    setState(() => _isLoading = true);
    _addLog('Testing Supabase connection...');

    try {
      final result = await ConnectionTestService.testConnection();
      _addLog('Connection result: ${result['status']}');

      if (result['status'] == 'success') {
        _addLog('Connection: SUCCESS ✅');
        _addLog('Current user: ${result['currentUser'] ?? 'None'}');
      } else {
        _addLog('Connection: FAILED ❌');
        _addLog('Error: ${result['error']}');
      }
    } catch (e) {
      _addLog('Connection error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testSimpleRegistration() async {
    setState(() => _isLoading = true);
    _addLog('Testing SIMPLE registration...');

    try {
      final response = await SimpleAuthService.signUpSimple(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _nameController.text,
      );

      if (response?.user != null) {
        _addLog('Simple registration: SUCCESS');
        _addLog('User ID: ${response!.user!.id}');
        _addLog('Has session: ${response.session != null}');
        _addLog('Email confirmed: ${response.user!.emailConfirmedAt != null}');
      } else {
        _addLog('Simple registration: FAILED');
      }
    } catch (e) {
      _addLog('Simple registration error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testFullRegistration() async {
    setState(() => _isLoading = true);
    _addLog('Testing FULL registration...');

    try {
      final response = await AuthService.signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _nameController.text,
      );

      if (response?.user != null) {
        _addLog('Full registration: SUCCESS');
        _addLog('User ID: ${response!.user!.id}');
      } else {
        _addLog('Full registration: FAILED');
      }
    } catch (e) {
      _addLog('Full registration error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testSignIn() async {
    setState(() => _isLoading = true);
    _addLog('Testing sign in with credentials...');

    try {
      final result = await ConnectionTestService.testSignIn(
        _emailController.text,
        _passwordController.text,
      );

      _addLog('Sign in result: ${result['status']}');

      if (result['status'] == 'success') {
        _addLog('Sign in: SUCCESS ✅');
        _addLog('User ID: ${result['userId']}');
        _addLog('Email confirmed: ${result['emailConfirmed']}');
      } else {
        _addLog('Sign in: FAILED ❌');
        _addLog('Error: ${result['error']}');
      }
    } catch (e) {
      _addLog('Sign in error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _checkCurrentUser() async {
    _addLog('Checking current user...');

    final user = SimpleAuthService.currentUser;
    if (user != null) {
      _addLog('Current user: ${user.email}');
      _addLog('User ID: ${user.id}');
      _addLog('Email confirmed: ${user.emailConfirmedAt != null}');
    } else {
      _addLog('No current user');
    }
  }

  Future<void> _signOut() async {
    _addLog('Signing out...');
    try {
      await SimpleAuthService.signOut();
      _addLog('Sign out: SUCCESS');
    } catch (e) {
      _addLog('Sign out error: $e');
    }
  }

  Future<void> _testResendConfirmation() async {
    setState(() => _isLoading = true);
    _addLog('Testing resend email confirmation...');

    try {
      final success = await AuthService.resendEmailConfirmation(
        email: _emailController.text,
      );

      if (success) {
        _addLog('Resend confirmation: SUCCESS');
        _addLog('Check your email inbox');
      } else {
        _addLog('Resend confirmation: FAILED');
      }
    } catch (e) {
      _addLog('Resend confirmation error: $e');
    }

    setState(() => _isLoading = false);
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Debug'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: const Icon(Icons.clear_all), onPressed: _clearLogs),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Test buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _testConnection,
                            child: const Text('Test Connection'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    _addLog('Checking if user exists...');
                                    final result =
                                        await ConnectionTestService.checkUserExists(
                                          _emailController.text,
                                        );
                                    _addLog('User check: ${result['status']}');
                                    _addLog(
                                      'Message: ${result['message'] ?? result['error']}',
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                            ),
                            child: const Text('Check User'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _testSimpleRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Simple Register'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _testFullRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text('Full Register'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _testSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                            child: const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _testResendConfirmation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            child: const Text('Resend Email'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Sign Out'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearLogs,
                            child: const Text('Clear Logs'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Logs
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        'Debug Logs (${_logs.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _logs.isEmpty
                          ? const Center(child: Text('No logs yet'))
                          : ListView.builder(
                              itemCount: _logs.length,
                              itemBuilder: (context, index) {
                                final log = _logs[index];
                                final isError =
                                    log.contains('FAILED') ||
                                    log.contains('error');
                                final isSuccess = log.contains('SUCCESS');

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isError
                                        ? Colors.red.withOpacity(0.1)
                                        : isSuccess
                                        ? Colors.green.withOpacity(0.1)
                                        : null,
                                  ),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                      color: isError
                                          ? Colors.red
                                          : isSuccess
                                          ? Colors.green
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
