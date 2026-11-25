import 'package:brain_game/data/cases_data.dart';
import 'package:brain_game/games/dictaphone_tune_game.dart';
import 'package:brain_game/games/hold_breath_game.dart';
import 'package:brain_game/games/mirror_wipe_game.dart';
import 'package:brain_game/games/ritual_offering_game.dart';
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
      'Arsip Kelam boots in Dark Horror theme, toggles sound & ID/EN, and opens Case #01',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppStateController();
    await controller.load();

    await tester.pumpWidget(MindCaseApp(controller: controller));
    await tester.pumpAndSettle();

    // Default Indonesian UI + Sound ON
    expect(find.text('Arsip Kelam'), findsOneWidget);
    expect(find.text('Bangsal Melati Lantai 3 — RSUD Cempaka Lama'),
        findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

    // Toggle sound off
    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);

    // Switch language to English
    await tester.tap(find.text('ID'));
    await tester.pumpAndSettle();
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('Melati Ward Floor 3 — Old Cempaka Hospital'),
        findsOneWidget);

    // Open Case #01 Board
    await tester.drag(find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Melati Ward Floor 3 — Old Cempaka Hospital'));
    await tester.pumpAndSettle();
    expect(find.text('Wipe the Fogged Mirror'), findsOneWidget);
  });

  testWidgets('Solving Case #01 reveals Room 304 Plot Twist',
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

    await tester.drag(find.byType(ListView), const Offset(0, -450));
    await tester.pumpAndSettle();
    await tester.tap(find.text('dr. Hendro Wirawan'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tunjuk Sumber Tragedi'));
    await tester.pumpAndSettle();

    expect(find.text('PLOT TWIST!'), findsOneWidget);
    expect(
      find.text('PLOT TWIST: Harta Gelap di Balik Tembok Ruang 304!'),
      findsOneWidget,
    );
  });

  testWidgets('All 4 horror mini-games render cleanly',
      (WidgetTester tester) async {
    const s = AppStrings(AppLanguage.id);

    // 1. Usap Cermin
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: const MirrorWipeGameScreen(
          strings: s,
          difficulty: 1,
          stageId: 'c1_s1',
        ),
      ),
    );
    await tester.pump();
    expect(find.text('304'), findsOneWidget);
    expect(find.text('01:45'), findsOneWidget);

    // 2. Selaraskan Pita Diktafon
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: const DictaphoneTuneGameScreen(
          strings: s,
          difficulty: 1,
          stageId: 'c1_s2',
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Slider), findsOneWidget);

    // 3. Susun Arah Sesajen
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: const RitualOfferingGameScreen(strings: s, difficulty: 1),
      ),
    );
    await tester.pump();
    expect(find.text('UTARA'), findsOneWidget);
    expect(find.text('TENGAH'), findsOneWidget);
    expect(find.text('SELATAN'), findsOneWidget);
    expect(find.text('Kendi Tanah Liat'), findsOneWidget);
    expect(find.text('Bunga Melati'), findsOneWidget);
    expect(find.text('Kemenyan'), findsOneWidget);

    // 4. Tahan Napas
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: const HoldBreathGameScreen(strings: s, difficulty: 1),
      ),
    );
    await tester.pump();
    expect(find.text('TAHAN NAPAS'), findsOneWidget);
  });
}
