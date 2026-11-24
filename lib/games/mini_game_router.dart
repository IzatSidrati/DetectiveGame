import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import 'anomaly_logic_game.dart';
import 'memory_grid_game.dart';
import 'quick_math_game.dart';
import 'stroop_focus_game.dart';

Future<MiniGameResult?> launchMiniGame({
  required BuildContext context,
  required BrainSkill skill,
  required AppStrings strings,
  required int difficulty,
  String? headerTitle,
  String? caseId,
  String? storyCaption,
}) {
  Widget page;
  switch (skill) {
    case BrainSkill.memory:
      page = MemoryGridGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
        caseId: caseId,
        storyCaption: storyCaption,
      );
      break;
    case BrainSkill.focus:
      page = StroopFocusGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
        caseId: caseId,
        storyCaption: storyCaption,
      );
      break;
    case BrainSkill.logic:
      page = AnomalyLogicGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
        caseId: caseId,
        storyCaption: storyCaption,
      );
      break;
    case BrainSkill.math:
      page = QuickMathGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
        caseId: caseId,
        storyCaption: storyCaption,
      );
      break;
  }

  return Navigator.of(context).push<MiniGameResult>(
    MaterialPageRoute(builder: (_) => page),
  );
}
