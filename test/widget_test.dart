// Basic Flutter widget test for the volleyball rotation app.

import 'package:flutter_test/flutter_test.dart';
import 'package:volley_rotation/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without throwing an exception
    // This is a basic smoke test to ensure the app can start
    expect(find.byType(MyApp), findsOneWidget);
  });
}