import 'package:brain_game/data/cases_data.dart';
import 'package:brain_game/games/anomaly_logic_game.dart';
import 'package:brain_game/l10n/app_strings.dart';
import 'package:brain_game/main.dart';
import 'package:brain_game/models/game_models.dart';
import 'package:brain_game/screens/deduction_screen.dart';
import 'package:brain_game/services/storage_service.dart';
import 'package:brain_game/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'MindCase boots with comedy cases, toggles sound & ID/EN, and opens Case #01',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppStateController();
    await controller.load();

    await tester.pumpWidget(MindCaseApp(controller: controller));
    await tester.pumpAndSettle();

    // Default Indonesian UI + Sound ON
    expect(find.text('MindCase'), findsOneWidget);
    expect(find.text('Tragedi Jam 02.15 & Espresso Gaib'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

    // Toggle sound off
    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);

    // Switch language to English
    await tester.tap(find.text('ID'));
    await tester.pumpAndSettle();
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('The 02:15 Clock & Phantom Espresso'), findsOneWidget);

    // Open Case #01 Board (scroll into view inside the mobile-framed list)
    await tester.drag(find.byType(ListView).first, const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(find.text('The 02:15 Clock & Phantom Espresso'));
    await tester.pumpAndSettle();
    expect(find.text('Keycard Panel Recall'), findsOneWidget);
  });

  testWidgets('Solving Case #01 reveals funny unexpected Plot Twist artwork',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppStateController();
    await controller.load();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: DeductionScreen(
          controller: controller,
          detectiveCase: kDetectiveCases.first,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Scroll to Nadia Kusuma (culprit) and accuse
    await tester.scrollUntilVisible(find.text('Nadia Kusuma'), 200);
    await tester.tap(find.text('Nadia Kusuma'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Tuduh Tersangka Ini!'), 200);
    await tester.tap(find.text('Tuduh Tersangka Ini!'));
    await tester.pumpAndSettle();

    // Verify Plot Twist illustration & comedic reveal text!
    expect(find.text('PLOT TWIST!'), findsOneWidget);
    expect(find.text('PLOT TWIST: "Bos Mochi" Ikut Terbawa!'), findsOneWidget);
  });

  testWidgets('New Odd Clue Hunt visual logic mini-game displays story banner',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: const AnomalyLogicGameScreen(
          strings: AppStrings(AppLanguage.id),
          difficulty: 1,
          caseId: 'case_01',
          storyCaption: 'Cari simbol log yang janggal!',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('TKP • LIVE'), findsOneWidget);
    expect(find.text('Cari simbol log yang janggal!'), findsOneWidget);
    expect(find.text('Ketuk 1 bukti yang JANGGAL di grid!'), findsOneWidget);
  });
}
