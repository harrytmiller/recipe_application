import 'package:flutter/material.dart';
import 'package:flutter_log/pages/faqs_page/FAQ_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QAItem Widget Tests', () {
    testWidgets('QAItem widget should display title and children',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QAItem(
              title: 'Test Question',
              children: [
                Text('Test Answer'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Question'), findsOneWidget);
      // Children are initially hidden in ExpansionTile, need to expand first
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();
      expect(find.text('Test Answer'), findsOneWidget);
    });
  });

  testWidgets('FloatingActionButton widget test', (WidgetTester tester) async {
    bool onPressedCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onPressedCalled = true;
          },
          child: Icon(Icons.add),
        ),
      ),
    ));

    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(onPressedCalled, true);
  });

  testWidgets('QAItem ExpansionTile functionality', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QAItem(
            title: 'Test Question',
            children: [
              Text('Test Answer'),
            ],
          ),
        ),
      ),
    );

    // Verify the ExpansionTile exists
    expect(find.byType(ExpansionTile), findsOneWidget);
    
    // Verify the title is visible
    expect(find.text('Test Question'), findsOneWidget);
    
    // The answer should initially be hidden (collapsed)
    expect(find.text('Test Answer'), findsNothing);
    
    // Tap to expand the tile
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    
    // Now the answer should be visible
    expect(find.text('Test Answer'), findsOneWidget);
  });

  testWidgets('QAItem with custom colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QAItem(
            title: 'Colored Question',
            children: [
              Text('Colored Answer'),
            ],
            backgroundColor: Colors.blue,
            titleColor: Colors.white,
            childrenColor: Colors.yellow,
          ),
        ),
      ),
    );

    final expansionTile = tester.widget<ExpansionTile>(find.byType(ExpansionTile));
    expect(expansionTile.backgroundColor, Colors.blue);
    
    final titleText = tester.widget<Text>(find.text('Colored Question'));
    expect(titleText.style?.color, Colors.white);
  });

  // Simple test that doesn't require Firebase initialization
  testWidgets('QAItem multiple children test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QAItem(
            title: 'Question with multiple answers',
            children: [
              Text('Answer 1'),
              Text('Answer 2'),
              Text('Answer 3'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Question with multiple answers'), findsOneWidget);
    
    // Expand the tile
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    
    // All answers should now be visible
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('Answer 2'), findsOneWidget);
    expect(find.text('Answer 3'), findsOneWidget);
  });
}