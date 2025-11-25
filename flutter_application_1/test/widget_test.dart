// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_dealer_app/main.dart';

void main() {
  testWidgets('Auto Dealer App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AutoDealerApp());

    // Verify that main screen is loaded
    expect(find.text('Главная'), findsOneWidget);
    expect(find.text('Автосалон'), findsOneWidget);

    // Verify that navigation items are present
    expect(find.byIcon(Icons.directions_car), findsWidgets);
    expect(find.byIcon(Icons.people), findsWidgets);
  });

  testWidgets('Navigation drawer test', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoDealerApp());

    // Tap the menu icon to open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify that drawer items are present
    expect(find.text('Автомобили'), findsOneWidget);
    expect(find.text('Покупатели'), findsOneWidget);
    expect(find.text('Аналитика'), findsOneWidget);
  });

  testWidgets('Bottom navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoDealerApp());

    // Verify bottom navigation items
    expect(find.text('Главная'), findsOneWidget);
    expect(find.text('Автомобили'), findsOneWidget);
    expect(find.text('Покупатели'), findsOneWidget);
    expect(find.text('Аналитика'), findsOneWidget);
  });
}