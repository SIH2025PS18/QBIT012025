import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_flutter/_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:telemed/screens/auth/phone_login_with_password_screen.dart';
import 'package:telemed/screens/auth/register_screen.dart';
import 'package:telemed/widgets/custom_text_field.dart';
import 'package:telemed/widgets/custom_button.dart';

// Mock  for testing
class MockClient extends Mock implements Client {}

void main() {
  group('Authentication Widget Tests', () {
    testWidgets('PhoneLoginWithPasswordScreen renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: PhoneLoginWithPasswordScreen()),
      );

      // Check if phone login screen elements are present
      expect(find.text('Phone Login'), findsOneWidget);
      expect(
        find.text('Sign in with your phone number and password'),
        findsOneWidget,
      );

      // Check for text fields
      expect(
        find.byType(CustomTextField),
        findsNWidgets(2),
      ); // Phone and password

      // Check for buttons
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Check for icons
      expect(find.byIcon(Icons.medical_services), findsOneWidget);
    });

    testWidgets('RegisterScreen renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Check if register screen elements are present
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);

      // Check for text fields (Full name, Email, Password, Confirm Password)
      expect(find.byType(CustomTextField), findsNWidgets(4));

      // Check for buttons
      expect(find.text('Create Account'), findsNWidgets(2)); // Title and button
      expect(find.text('Sign In'), findsOneWidget);

      // Check for icons
      expect(find.byIcon(Icons.person_add), findsOneWidget);
    });

    testWidgets('PhoneLoginWithPasswordScreen form validation works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: PhoneLoginWithPasswordScreen()),
      );

      // Find the sign in button
      final signInButton = find.widgetWithText(CustomButton, 'Sign In');

      // Try to submit without filling fields
      await tester.tap(signInButton);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('RegisterScreen form validation works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Find the create account button
      final createAccountButton = find.widgetWithText(
        CustomButton,
        'Create Account',
      );

      // Try to submit without filling fields
      await tester.tap(createAccountButton);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Phone validation works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: PhoneLoginWithPasswordScreen()),
      );

      // Find phone text field
      final phoneField = find.byType(CustomTextField).first;

      // Enter invalid phone
      await tester.enterText(phoneField, 'invalid-phone');
      await tester.pump();

      // Try to submit
      final signInButton = find.widgetWithText(CustomButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pump();

      // Should show email validation error
      expect(find.text('Please enter a valid phone number'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: PhoneLoginWithPasswordScreen()),
      );

      // Find password field
      final passwordFields = find.byType(CustomTextField);
      final passwordField = passwordFields.last;

      // Enter some text
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Find the visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility_off);
      expect(visibilityButton, findsOneWidget);

      // Tap the visibility button
      await tester.tap(visibilityButton);
      await tester.pump();

      // Should now show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Navigation from Login to Register works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: PhoneLoginWithPasswordScreen()),
      );

      // Find and tap the Sign Up link
      final signUpLink = find.text('Sign Up');
      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      // Should navigate to register screen
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
    });

    testWidgets('Navigation from Register back to Login works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Find and tap the Sign In link
      final signInLink = find.text('Sign In');
      await tester.tap(signInLink);
      await tester.pumpAndSettle();

      // Should navigate back to login screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
    });
  });

  group('Input Validation Tests', () {
    testWidgets('Password confirmation validation works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Fill in the fields
      final textFields = find.byType(CustomTextField);

      await tester.enterText(textFields.at(0), 'John Doe'); // Full name
      await tester.enterText(textFields.at(1), 'john@example.com'); // Email
      await tester.enterText(textFields.at(2), 'password123'); // Password
      await tester.enterText(
        textFields.at(3),
        'differentpassword',
      ); // Confirm password

      await tester.pump();

      // Try to submit
      final createAccountButton = find.widgetWithText(
        CustomButton,
        'Create Account',
      );
      await tester.tap(createAccountButton);
      await tester.pump();

      // Should show password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Weak password validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Fill password field with weak password
      final textFields = find.byType(CustomTextField);
      await tester.enterText(textFields.at(2), '123'); // Weak password

      await tester.pump();

      // Try to submit
      final createAccountButton = find.widgetWithText(
        CustomButton,
        'Create Account',
      );
      await tester.tap(createAccountButton);
      await tester.pump();

      // Should show weak password error
      expect(
        find.text('Password must be at least 6 characters long'),
        findsOneWidget,
      );
    });
  });

  group('UI Component Tests', () {
    testWidgets('CustomButton shows loading state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Should show loading indicator instead of text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('CustomTextField displays correctly', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              labelText: 'Test Field',
              hintText: 'Enter text here',
              prefixIcon: Icons.person,
            ),
          ),
        ),
      );

      // Check if all elements are present
      expect(find.text('Test Field'), findsOneWidget);
      expect(find.text('Enter text here'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
