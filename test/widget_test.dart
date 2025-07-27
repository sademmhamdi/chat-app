// This is a basic Flutter widget test for the ChatCall Pro app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chattach/main.dart';

void main() {
  testWidgets('Chat app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we can see the auth screen initially
    expect(find.text('ChatCall Pro'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
