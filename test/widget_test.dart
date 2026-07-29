// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portofolio/main.dart';

void main() {
  testWidgets('portfolio renders the projects section', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = Size(1440, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('SELECTED WORK'), findsOneWidget);
    expect(find.text('October SCADA'), findsOneWidget);
  });
}
