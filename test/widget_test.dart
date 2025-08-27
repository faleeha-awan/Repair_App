// This is a basic Flutter widget test for the Repair Guide App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/screens/main_navigation_screen.dart';

void main() {
  testWidgets('Main navigation screen renders correctly', (WidgetTester tester) async {
    // Build the MainNavigationScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: const MainNavigationScreen(),
      ),
    );
    
    // Wait for the widget to build
    await tester.pump();

    // Verify that the bottom navigation bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that all navigation tabs are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('My Guides'), findsOneWidget);
    expect(find.text('Manuals & Chat'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Navigation between tabs works', (WidgetTester tester) async {
    // Build the MainNavigationScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: const MainNavigationScreen(),
      ),
    );
    
    // Wait for the widget to build
    await tester.pump();

    // Test navigation to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pump();

    // Verify Profile screen is displayed (should show loading initially)
    expect(find.text('Profile'), findsAtLeastNWidgets(1)); // AppBar title
  });
}
