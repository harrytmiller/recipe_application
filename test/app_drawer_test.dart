import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_log/pages/home_page/components/appdraw.dart';

void main() {
  final Function signOutMock = () {};

  testWidgets('AppDrawer widget should be rendered',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AppDrawer(signOutMock),
      ),
    ));

    // Verify that AppDrawer creates a Drawer.
    expect(find.byType(Drawer), findsOneWidget);
  });
}
