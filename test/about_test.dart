import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_log/pages/about_us_page/about_page.dart';

void main() {
  group('AboutUsPage Tests', () {
    testWidgets('Page renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify the page loads without exceptions
      expect(find.byType(AboutUsPage), findsOneWidget);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check that AppBar and title exist
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
    });

    testWidgets('Main content container exists', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check for main content using textContaining to match partial text
      expect(find.textContaining('WasteAway is an exciting new application'), findsOneWidget);
      
      // Verify the page has scrollable content
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Team member cards are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check that team member names are displayed
      expect(find.text('Josh Varney'), findsOneWidget);
      expect(find.text('Hazaloid Jenkins'), findsOneWidget);
      expect(find.text('Mattew Bowers'), findsOneWidget);
      expect(find.text('Rhys Parsons'), findsOneWidget);
      expect(find.text('Khadija Baffa'), findsOneWidget);
      expect(find.text('Cindy Murimi'), findsOneWidget);
    });

    testWidgets('Team member roles are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check that team member roles are shown
      expect(find.text('All-round Developer'), findsNWidgets(2));
      expect(find.text('Front-end Developer'), findsNWidgets(2));
      expect(find.text('Back-end Developer'), findsNWidgets(2));
    });

    testWidgets('Contact email links are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check that all contact email links exist
      expect(find.text('Contact by email'), findsNWidgets(6));
    });

    testWidgets('Person icons are displayed for all team members', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check that person icons are present (should be 6 for 6 team members)
      expect(find.byIcon(Icons.person), findsNWidgets(6));
    });


    testWidgets('Email tap handlers exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Find all email contact links
      final emailLinks = find.text('Contact by email');
      expect(emailLinks, findsNWidgets(6));

      // Verify they are wrapped in GestureDetector (tappable)
      for (int i = 0; i < 6; i++) {
        final gestureDetector = find.ancestor(
          of: emailLinks.at(i),
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      }
    });

    testWidgets('Team member descriptions are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Check that team member descriptions contain expected text
      expect(find.textContaining('I am Josh'), findsOneWidget);
      expect(find.textContaining('I am haz'), findsOneWidget);
      expect(find.textContaining('I am Matt'), findsOneWidget);
      expect(find.textContaining('I am Rhys'), findsOneWidget);
      expect(find.textContaining('I am Khadija'), findsOneWidget);
      expect(find.textContaining('I am Cindy'), findsOneWidget);
    });
  });
}