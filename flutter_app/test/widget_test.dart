import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zippy_ride/app.dart';

void main() {
  testWidgets('ZippyRideApp renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ZippyRideApp());
    await tester.pumpAndSettle();

    // Verify the app renders the onboarding screen
    expect(find.text('Zippy Ride'), findsWidgets);
  });
}
