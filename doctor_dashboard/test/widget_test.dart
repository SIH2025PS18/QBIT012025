// This is a basic widget test.// This is a basic widget test.

////

// To perform an interaction with a widget in your test, use the WidgetTester// To perform an interaction with a widget in your test, use the WidgetTester

// utility in the flutter_test package. For example, you can send tap and scroll// utility in the flutter_test package. For example, you can send tap and scroll

// gestures. You can also use WidgetTester to find child widgets in the widget// gestures. You can also use WidgetTester to find child widgets in the widget

// tree, read text, and verify that the values of widget properties are correct.// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter_test/flutter_test.dart';import 'package:flutter_test/test.dart';



import 'package:doctor_dashboard/main.dart';import 'package:doctor_dashboard/main.dart';a basic Flutter widget test.

//

void main() {// To perform an interaction with a widget in your test, use the WidgetTester

  testWidgets('Doctor dashboard app loads', (WidgetTester tester) async {// utility in the flutter_test package. For example, you can send tap and scroll

    // Build our app and trigger a frame.// gestures. You can also use WidgetTester to find child widgets in the widget

    await tester.pumpWidget(const DoctorDashboardApp());// tree, read text, and verify that the values of widget properties are correct.



    // Verify that the login screen loadsimport 'package:flutter/material.dart';

    expect(find.text('Doctor Login'), findsOneWidget);import 'package:flutter_test/flutter_test.dart';

  });

}import 'package:doctor_dashboard/main.dart';

void main() {
  testWidgets('Doctor dashboard app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DoctorDashboardApp());

    // Verify that the login screen loads
    expect(find.text('Doctor Login'), findsOneWidget);
  });
}
