import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../games/mini_game_router.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';
import '../widgets/solved_illustrations.dart';

class StageBriefingScreen extends StatefulWidget {
  final AppStateController controller;
  final DetectiveCase detectiveCase;
  final CaseStage stage;

  const StageBriefingScreen({
    super.key,
    required this.controller,
    required this.detectiveCase,
    required this.stage,
  });

  @override
  State<StageBriefingScreen> createState() => _StageBriefingScreenState();
}

class _StageBriefingScreenState extends State<StageBriefingScreen> {
  MiniGameResult? _result;

  Future<void> _startGame() async {
    SoundService.instance.playTap();
    final s = AppStrings(widget.controller.language);
    final res = await launchMiniGame(
      context: context,
      skill: widget.stage.skill,
      strings: s,
      difficulty: widget.stage.difficulty,
      headerTitle: widget.stage.title.of(s.lang),
      caseId: widget.detectiveCase.imageAsset,
      stageId: widget.stage.id,
      storyCaption: widget.stage.briefing.of(s.lang),
    );
    if (res == null || !mounted) return;

    await widget.controller.recordMiniGameResult(
      res,
      stageId: widget.stage.id,
    );
    if (res.passed) {
      HapticFeedback.mediumImpact();
      SoundService.instance.playUnlock();
    } else {
      SoundService.instance.playWrong();
    }
    setState(() => _result = res);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(widget.controller.language);
    final stage = widget.stage;
    final accent = AppColors.forSkill(stage.skill);

    if (_result != null) {
      return _buildOutcomeView(s, accent, _result!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.detectiveCase.code} • 0${stage.order}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaseSceneArtwork(
                        caseId: widget.detectiveCase.imageAsset,
                        height: 185,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accent.withOpacity(0.45)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppColors.iconForSkill(stage.skill),
                                color: accent, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '${s.skillName(stage.skill)} • ${s.skillGameTitle(stage.skill)}',
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        stage.title.of(s.lang),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            stage.location.of(s.lang),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Micro-narrative dossier card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.description_outlined,
                                    color: AppColors.accentAmber, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  s.dossierBriefing.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.accentAmber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              stage.briefing.of(s.lang),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Witty Detective Juno comment bubble
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accentAmber.withOpacity(0.32),
                          ),
                        ),
                        child: Row(
                          children: [
                            const DetectiveAvatar(
                                mood: DetectiveMood.smug, size: 46),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                stage.detectiveQuip.of(s.lang),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.tips_and_updates_outlined,
                                color: accent, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.skillGameDesc(stage.skill),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startGame,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(s.startAnalysis),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutcomeView(AppStrings s, Color accent, MiniGameResult result) {
    final stage = widget.stage;
    final passed = result.passed;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.detectiveCase.code),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 6),
                      if (passed) ...[
                        StageSolvedComicArtwork(
                          skill: stage.skill,
                          stageId: stage.id,
                          height: 165,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stage.evidenceFunnyCaption.of(s.lang),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.accentAmber,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ] else ...[
                        const DetectiveAvatar(
                          mood: DetectiveMood.oops,
                          size: 84,
                        ),
                        const SizedBox(height: 14),
                      ],
                      Text(
                        passed ? s.evidenceUnlocked : s.analysisFailed,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        passed ? s.winQuip : s.failQuip,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ScorePill(
                              label: s.scoreLabel, value: '${result.score}'),
                          const SizedBox(width: 10),
                          _ScorePill(
                            label: s.accuracyLabel,
                            value: '${result.correctCount}/${result.totalCount}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (passed)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: AppColors.accentAmber.withOpacity(0.55)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.push_pin_rounded,
                                      color: AppColors.accentAmber, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      stage.evidenceTitle.of(s.lang),
                                      style: const TextStyle(
                                        color: AppColors.accentAmber,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                stage.evidenceDetail.of(s.lang),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            s.analysisFailedDesc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (!passed) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _startGame,
                    icon: const Icon(Icons.replay_rounded),
                    label: Text(s.tryAgain),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                child: passed
                    ? ElevatedButton(
                        onPressed: () {
                          SoundService.instance.playTap();
                          Navigator.of(context).pop(true);
                        },
                        child: Text(s.backToBoard),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          SoundService.instance.playTap();
                          Navigator.of(context).pop(false);
                        },
                        child: Text(s.backToBoard),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String label;
  final String value;

  const _ScorePill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
