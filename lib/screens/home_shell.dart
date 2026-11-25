import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cases_data.dart';
import '../games/mini_game_router.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/radar_chart.dart';
import '../widgets/scene_illustrations.dart';
import '../widgets/solved_illustrations.dart';
import 'case_board_screen.dart';
import 'premium_modal.dart';

class HomeShell extends StatefulWidget {
  final AppStateController controller;

  const HomeShell({super.key, required this.controller});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;
  int _trainingDifficulty = 1;
  final _rng = math.Random();

  Future<void> _runFreeTraining(BrainSkill skill) async {
    SoundService.instance.playTap();
    final s = AppStrings(widget.controller.language);
    final res = await launchMiniGame(
      context: context,
      skill: skill,
      strings: s,
      difficulty: _trainingDifficulty,
    );
    if (res == null || !mounted) return;
    await widget.controller.recordMiniGameResult(res);
    if (res.passed) {
      SoundService.instance.playUnlock();
    } else {
      SoundService.instance.playWrong();
    }

    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            DetectiveAvatar(
              mood: res.passed ? DetectiveMood.excited : DetectiveMood.oops,
              size: 42,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(s.trainingComplete)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (res.passed) ...[
              StageSolvedComicArtwork(skill: skill, height: 122),
              const SizedBox(height: 12),
            ],
            Text(
              '${s.skillName(skill)} • ${s.skillGameTitle(skill)}',
              style: TextStyle(
                color: AppColors.forSkill(skill),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${s.scoreLabel}: ${res.score}/100\n${s.accuracyLabel}: ${res.correctCount}/${res.totalCount}',
              style: const TextStyle(color: AppColors.textPrimary, height: 1.5),
            ),
            const SizedBox(height: 10),
            Text(
              res.passed ? s.winQuip : s.failQuip,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              SoundService.instance.playTap();
              Navigator.of(ctx).pop();
            },
            child: Text(s.doneBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final s = AppStrings(widget.controller.language);
        final progress = widget.controller.progress;
        final soundOn = widget.controller.soundEnabled;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const DetectiveAvatar(mood: DetectiveMood.smug, size: 34),
                const SizedBox(width: 10),
                Text(
                  s.appName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            actions: [
              // Sound mute/unmute button
              IconButton(
                tooltip: s.soundEffectsLabel,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  widget.controller.toggleSound();
                },
                icon: Icon(
                  soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color:
                      soundOn ? AppColors.accentAmber : AppColors.textMuted,
                  size: 21,
                ),
              ),
              // Bilingual ID/EN switcher pill
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    SoundService.instance.playTap();
                    widget.controller.toggleLanguage();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.translate_rounded,
                            size: 14, color: AppColors.accentAmber),
                        const SizedBox(width: 5),
                        Text(
                          widget.controller.language == AppLanguage.id
                              ? 'ID'
                              : 'EN',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: _tabIndex,
            children: [
              _buildCasesTab(s, progress),
              _buildTrainingTab(s),
              _buildProfileTab(s, progress),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tabIndex,
            onDestinationSelected: (idx) {
              HapticFeedback.selectionClick();
              SoundService.instance.playTap();
              setState(() => _tabIndex = idx);
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.folder_copy_outlined),
                selectedIcon: const Icon(Icons.folder_copy_rounded),
                label: s.navCases,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bolt_outlined),
                selectedIcon: const Icon(Icons.bolt_rounded),
                label: s.navTraining,
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights_outlined),
                selectedIcon: const Icon(Icons.insights_rounded),
                label: s.navProfile,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCasesTab(AppStrings s, PlayerProgress progress) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        // Top status summary card + Detective Juno greeting
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF101B20), Color(0xFF0A1114)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            s.offlineBadge,
                            style: const TextStyle(
                              color: AppColors.accentTeal,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          s.brainIndexLabel,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${progress.brainIndex}',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              ' / 100',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department_rounded,
                            color: AppColors.accentAmber, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          s.daysCount(progress.streakDays),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          s.streakLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withOpacity(0.6)),
                ),
                child: Row(
                  children: [
                    const DetectiveAvatar(mood: DetectiveMood.smug, size: 38),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.heroGreeting,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          s.activeFiles,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        ...kDetectiveCases.map((c) {
          final doneStages = c.stages
              .where((st) => progress.completedStageIds.contains(st.id))
              .length;
          final solved = progress.solvedCaseIds.contains(c.id);
          final lockedByPremium = c.isPremium && !progress.isPremiumUnlocked;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                SoundService.instance.playTap();
                if (lockedByPremium) {
                  showDetectivePassModal(
                    context: context,
                    controller: widget.controller,
                    strings: s,
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CaseBoardScreen(
                        controller: widget.controller,
                        detectiveCase: c,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: solved
                        ? AppColors.success.withOpacity(0.5)
                        : lockedByPremium
                            ? AppColors.accentAmber.withOpacity(0.35)
                            : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Illustrated Scene Banner with floating badges
                    Stack(
                      children: [
                        CaseSceneArtwork(
                          caseId: c.imageAsset,
                          height: 210,
                          borderRadius: BorderRadius.zero,
                        ),
                        Positioned(
                          top: 10,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.82),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.accentAmber.withOpacity(0.5)),
                            ),
                            child: Text(
                              c.code,
                              style: const TextStyle(
                                color: AppColors.accentAmber,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 12,
                          child: _CaseStatusBadge(
                            text: solved
                                ? s.solvedBadge
                                : c.isPremium
                                    ? s.premiumBadge
                                    : s.freeBadge,
                            color: solved
                                ? AppColors.success
                                : c.isPremium
                                    ? AppColors.accentAmber
                                    : AppColors.accentTeal,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.title.of(s.lang),
                            style: const TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            c.subtitle.of(s.lang),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            c.synopsis.of(s.lang),
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: lockedByPremium
                                    ? Row(
                                        children: [
                                          const Icon(Icons.lock_rounded,
                                              size: 16,
                                              color: AppColors.accentAmber),
                                          const SizedBox(width: 6),
                                          Text(
                                            s.unlockWithPass,
                                            style: const TextStyle(
                                              color: AppColors.accentAmber,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: LinearProgressIndicator(
                                              value:
                                                  doneStages / c.stages.length,
                                              minHeight: 6,
                                              backgroundColor:
                                                  AppColors.surfaceElevated,
                                              color: solved
                                                  ? AppColors.success
                                                  : AppColors.accentAmber,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            s.evidenceProgress(
                                                doneStages, c.stages.length),
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.chevron_right_rounded,
                                  color: AppColors.textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrainingTab(AppStrings s) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.accentAmber.withOpacity(0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.accentAmber),
                  const SizedBox(width: 8),
                  Text(
                    s.dailyWorkoutTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                s.dailyWorkoutDesc,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final pick = BrainSkill
                        .values[_rng.nextInt(BrainSkill.values.length)];
                    _runFreeTraining(pick);
                  },
                  icon: const Icon(Icons.shuffle_rounded),
                  label: Text(s.startRandomDrill),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                s.difficultyLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 1, label: Text('Lv 1')),
                ButtonSegment(value: 2, label: Text('Lv 2')),
                ButtonSegment(value: 3, label: Text('Lv 3')),
              ],
              selected: {_trainingDifficulty},
              onSelectionChanged: (v) {
                HapticFeedback.selectionClick();
                SoundService.instance.playTap();
                setState(() => _trainingDifficulty = v.first);
              },
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          s.chooseSkill,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...BrainSkill.values.map((skill) {
          final color = AppColors.forSkill(skill);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _runFreeTraining(skill),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(AppColors.iconForSkill(skill), color: color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${s.skillName(skill)} • ${s.skillGameTitle(skill)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.skillGameDesc(skill),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.play_circle_fill_rounded, color: color, size: 28),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProfileTab(AppStrings s, PlayerProgress progress) {
    final soundOn = widget.controller.soundEnabled;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.cognitiveMap,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${s.brainIndexLabel}: ${progress.brainIndex}',
                    style: const TextStyle(
                      color: AppColors.accentAmber,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CognitiveRadarChart(scores: progress.skillScores, strings: s),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: s.totalSessions,
                value: '${progress.totalSessions}',
                icon: Icons.fitness_center_rounded,
                color: AppColors.accentSky,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                label: s.casesSolved,
                value:
                    '${progress.solvedCaseIds.length}/${kDetectiveCases.length}',
                icon: Icons.verified_rounded,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Detective Pass status card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: progress.isPremiumUnlocked
                  ? AppColors.success.withOpacity(0.5)
                  : AppColors.accentAmber.withOpacity(0.45),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: progress.isPremiumUnlocked
                    ? AppColors.success
                    : AppColors.accentAmber,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.detectivePassTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      progress.isPremiumUnlocked
                          ? s.detectivePassActive
                          : s.detectivePassInactive,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!progress.isPremiumUnlocked)
                TextButton(
                  onPressed: () {
                    SoundService.instance.playTap();
                    showDetectivePassModal(
                      context: context,
                      controller: widget.controller,
                      strings: s,
                    );
                  },
                  child: Text(s.upgradeBtn),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Sound Effects toggle tile
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    soundOn
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    color: soundOn ? AppColors.accentAmber : AppColors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    s.soundEffectsLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Switch(
                value: soundOn,
                activeColor: AppColors.accentAmber,
                onChanged: (_) => widget.controller.toggleSound(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Language switcher tile
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  s.languageLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<AppLanguage>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: AppLanguage.id, label: Text('ID')),
                  ButtonSegment(value: AppLanguage.en, label: Text('EN')),
                ],
                selected: {widget.controller.language},
                onSelectionChanged: (sel) {
                  SoundService.instance.playTap();
                  widget.controller.setLanguage(sel.first);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.surface,
                title: Text(s.resetConfirmTitle),
                content: Text(
                  s.resetConfirmBody,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(s.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(
                      s.reset,
                      style: const TextStyle(color: AppColors.accentCrimson),
                    ),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await widget.controller.resetAllProgress();
            }
          },
          icon: const Icon(Icons.restart_alt_rounded,
              color: AppColors.accentCrimson),
          label: Text(
            s.resetProgress,
            style: const TextStyle(color: AppColors.accentCrimson),
          ),
        ),
      ],
    );
  }
}

class _CaseStatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _CaseStatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.84),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
