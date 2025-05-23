import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Image widget should be created and rendered',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Image(
          width: 310,
          image: AssetImage(
            'assets/images/logo/logo.png',
          ),
        ),
      ),
    ));

    // Verify that the Image widget is rendered.
    expect(find.byType(Image), findsOneWidget);
  });
}
