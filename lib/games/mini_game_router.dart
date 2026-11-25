import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import 'dictaphone_tune_game.dart';
import 'hold_breath_game.dart';
import 'mirror_wipe_game.dart';
import 'ritual_offering_game.dart';

Future<MiniGameResult?> launchMiniGame({
  required BuildContext context,
  required BrainSkill skill,
  required AppStrings strings,
  required int difficulty,
  String? headerTitle,
  String? caseId,
  String? stageId,
  String? storyCaption,
}) {
  Widget page;
  switch (skill) {
    case BrainSkill.memory:
      page = MirrorWipeGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
        stageId: stageId,
      );
      break;
    case BrainSkill.focus:
      page = DictaphoneTuneGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
        stageId: stageId,
      );
      break;
    case BrainSkill.logic:
      page = RitualOfferingGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
      );
      break;
    case BrainSkill.math:
      page = HoldBreathGameScreen(
        strings: strings,
        difficulty: difficulty,
        headerTitle: headerTitle,
      );
      break;
  }

  return Navigator.of(context).push<MiniGameResult>(
    MaterialPageRoute(builder: (_) => page),
  );
}
