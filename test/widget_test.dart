import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:telemed/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TelemedApp());

    // Verify that the app starts without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
