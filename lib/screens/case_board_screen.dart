import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';
import 'deduction_screen.dart';
import 'stage_briefing_screen.dart';

class CaseBoardScreen extends StatelessWidget {
  final AppStateController controller;
  final DetectiveCase detectiveCase;

  const CaseBoardScreen({
    super.key,
    required this.controller,
    required this.detectiveCase,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final s = AppStrings(controller.language);
        final progress = controller.progress;
        final c = detectiveCase;
        final completedCount = c.stages
            .where((st) => progress.completedStageIds.contains(st.id))
            .length;
        final allStagesDone = completedCount == c.stages.length;
        final isCaseSolved = progress.solvedCaseIds.contains(c.id);

        return Scaffold(
          appBar: AppBar(
            title: Text('${c.code} • ${s.caseBoardTitle}'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Case synopsis header with custom illustrated scene
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCaseSolved
                          ? AppColors.success.withOpacity(0.6)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaseSceneArtwork(
                        caseId: c.imageAsset,
                        height: 210,
                        borderRadius: BorderRadius.zero,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.title.of(s.lang),
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.synopsis.of(s.lang),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.5,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: completedCount / c.stages.length,
                                minHeight: 7,
                                backgroundColor: AppColors.surfaceElevated,
                                color: isCaseSolved
                                    ? AppColors.success
                                    : AppColors.accentAmber,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isCaseSolved
                                  ? s.caseSolvedBanner
                                  : s.evidenceProgress(
                                      completedCount, c.stages.length),
                              style: TextStyle(
                                color: isCaseSolved
                                    ? AppColors.success
                                    : AppColors.accentAmber,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Evidence nodes timeline
                ...List.generate(c.stages.length, (idx) {
                  final stage = c.stages[idx];
                  final isDone = progress.completedStageIds.contains(stage.id);
                  final isUnlocked = idx == 0 ||
                      progress.completedStageIds.contains(c.stages[idx - 1].id);
                  final skillColor = AppColors.forSkill(stage.skill);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: isUnlocked
                          ? () {
                              SoundService.instance.playTap();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => StageBriefingScreen(
                                    controller: controller,
                                    detectiveCase: c,
                                    stage: stage,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? AppColors.surface
                              : AppColors.surface.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDone
                                ? AppColors.success.withOpacity(0.45)
                                : isUnlocked
                                    ? skillColor.withOpacity(0.55)
                                    : AppColors.border,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: (isDone
                                            ? AppColors.success
                                            : isUnlocked
                                                ? skillColor
                                                : AppColors.surfaceElevated)
                                        .withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isDone
                                        ? Icons.check_rounded
                                        : isUnlocked
                                            ? AppColors.iconForSkill(stage.skill)
                                            : Icons.lock_outline_rounded,
                                    color: isDone
                                        ? AppColors.success
                                        : isUnlocked
                                            ? skillColor
                                            : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '0${stage.order} • ${s.skillName(stage.skill)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: isUnlocked
                                              ? skillColor
                                              : AppColors.textMuted,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        stage.title.of(s.lang),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isUnlocked
                                              ? AppColors.textPrimary
                                              : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isUnlocked
                                        ? AppColors.surfaceElevated
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isDone
                                        ? s.replayStage
                                        : isUnlocked
                                            ? s.investigateNow
                                            : s.lockedStage,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDone
                                          ? AppColors.textSecondary
                                          : isUnlocked
                                              ? AppColors.accentAmber
                                              : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isDone) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.push_pin_rounded,
                                        size: 15, color: AppColors.accentAmber),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${stage.evidenceTitle.of(s.lang)} — ${stage.evidenceDetail.of(s.lang)}',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.textSecondary,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),
                if (allStagesDone)
                  ElevatedButton.icon(
                    onPressed: () {
                      SoundService.instance.playTap();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DeductionScreen(
                            controller: controller,
                            detectiveCase: c,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.gavel_rounded),
                    label: Text(s.accuseCulprit),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const DetectiveAvatar(
                            mood: DetectiveMood.smug, size: 38),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.accuseHint,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
