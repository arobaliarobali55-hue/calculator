import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:totalizer/providers/theme_provider.dart';
import 'package:totalizer/main.dart';

void main() {
  testWidgets('HomeScreen loads and displays title',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const AllInOneCalculatorApp(),
      ),
    );

    // Verify that the logo is displayed (it's an Image.asset with 'assets/logo/logo.png')
    expect(find.byType(Image), findsWidgets);

    // Verify that some calculator cards are present.
    expect(find.text('Scientific Calculator'), findsOneWidget);
    expect(find.text('Financial Calculator'), findsOneWidget);
  });

  testWidgets('HomeScreen navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const AllInOneCalculatorApp(),
      ),
    );

    // Find and tap the 'Open' button for Scientific Calculator.
    // Since there are multiple 'Open' buttons, we find the one related to the Scientific Calculator.
    final scientificButton = find.widgetWithText(ElevatedButton, 'Open').first;

    await tester.tap(scientificButton);
    await tester.pumpAndSettle();

    // Verify that we are now on the Scientific Calculator screen.
    expect(
        find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Scientific Calculator')),
        findsOneWidget);
  });
}
