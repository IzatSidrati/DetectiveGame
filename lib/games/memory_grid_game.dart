import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';

class MemoryGridGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty; // 1..5
  final String? headerTitle;
  final String? caseId;
  final String? storyCaption;

  const MemoryGridGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
    this.caseId,
    this.storyCaption,
  });

  @override
  State<MemoryGridGameScreen> createState() => _MemoryGridGameScreenState();
}

class _MemoryGridGameScreenState extends State<MemoryGridGameScreen> {
  final _rng = math.Random();
  static const int _totalRounds = 4;

  int _round = 1;
  int _roundsCleared = 0;
  int _mistakesInRound = 0;
  bool _showingPattern = true;
  bool _roundLocked = false;

  late int _gridSize;
  late Set<int> _targetCells;
  final Set<int> _selectedCells = {};
  final Set<int> _wrongCells = {};
  Timer? _previewTimer;

  @override
  void initState() {
    super.initState();
    _setupRound();
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    super.dispose();
  }

  void _setupRound() {
    _previewTimer?.cancel();
    final effectiveLevel = widget.difficulty + (_round - 1);
    _gridSize = effectiveLevel <= 2 ? 3 : 4;
    final totalCells = _gridSize * _gridSize;
    final targetCount = (2 + effectiveLevel).clamp(3, _gridSize == 3 ? 6 : 8);

    final indices = List<int>.generate(totalCells, (i) => i)..shuffle(_rng);
    _targetCells = indices.take(targetCount).toSet();
    _selectedCells.clear();
    _wrongCells.clear();
    _mistakesInRound = 0;
    _showingPattern = true;
    _roundLocked = false;

    setState(() {});

    final previewMs = (1750 - (widget.difficulty * 150)).clamp(1000, 1700);
    _previewTimer = Timer(Duration(milliseconds: previewMs), () {
      if (!mounted) return;
      setState(() => _showingPattern = false);
    });
  }

  void _onTileTap(int index) {
    if (_showingPattern || _roundLocked) return;
    if (_selectedCells.contains(index) || _wrongCells.contains(index)) return;

    if (_targetCells.contains(index)) {
      HapticFeedback.lightImpact();
      SoundService.instance.playTap();
      setState(() => _selectedCells.add(index));

      if (_selectedCells.length == _targetCells.length) {
        _roundLocked = true;
        _roundsCleared++;
        HapticFeedback.mediumImpact();
        SoundService.instance.playCorrect();
        Future.delayed(const Duration(milliseconds: 550), _advanceOrFinish);
      }
    } else {
      HapticFeedback.heavyImpact();
      SoundService.instance.playWrong();
      setState(() {
        _wrongCells.add(index);
        _mistakesInRound++;
      });

      if (_mistakesInRound >= 2) {
        _roundLocked = true;
        // Reveal missed tiles briefly before advancing
        setState(() => _showingPattern = true);
        Future.delayed(const Duration(milliseconds: 850), _advanceOrFinish);
      }
    }
  }

  void _advanceOrFinish() {
    if (!mounted) return;
    if (_round < _totalRounds) {
      _round++;
      _setupRound();
    } else {
      final score = ((_roundsCleared / _totalRounds) * 100).round();
      final passed = _roundsCleared >= 3;
      Navigator.of(context).pop(
        MiniGameResult(
          skill: BrainSkill.memory,
          passed: passed,
          score: score,
          correctCount: _roundsCleared,
          totalCount: _totalRounds,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final accent = AppColors.forSkill(BrainSkill.memory);
    final totalCells = _gridSize * _gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.memory)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s.roundLabel(_round, _totalRounds),
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              MiniGameStoryBanner(
                caseId: widget.caseId,
                skill: BrainSkill.memory,
                caption: widget.storyCaption ?? s.skillGameDesc(BrainSkill.memory),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _round / _totalRounds,
                backgroundColor: AppColors.surfaceElevated,
                color: accent,
                minHeight: 6,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _showingPattern ? accent : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _showingPattern
                          ? Icons.visibility_rounded
                          : Icons.touch_app_rounded,
                      color: _showingPattern ? accent : AppColors.accentAmber,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _showingPattern ? s.memorizePhase : s.recallPhase,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${_selectedCells.length}/${_targetCells.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      final isTarget = _targetCells.contains(index);
                      final isSelected = _selectedCells.contains(index);
                      final isWrong = _wrongCells.contains(index);

                      Color bg = AppColors.surfaceElevated;
                      Color border = AppColors.border;
                      IconData? icon;

                      if (_showingPattern && isTarget) {
                        bg = accent.withOpacity(0.85);
                        border = accent;
                        icon = Icons.fingerprint_rounded;
                      } else if (isSelected) {
                        bg = AppColors.success.withOpacity(0.85);
                        border = AppColors.success;
                        icon = Icons.check_rounded;
                      } else if (isWrong) {
                        bg = AppColors.accentCrimson.withOpacity(0.8);
                        border = AppColors.accentCrimson;
                        icon = Icons.close_rounded;
                      }

                      return GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border, width: 1.5),
                          ),
                          child: icon != null
                              ? Icon(icon, color: Colors.white, size: 28)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (i) {
                  final alive = i < (2 - _mistakesInRound);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.shield_rounded,
                      size: 20,
                      color: alive ? AppColors.accentAmber : AppColors.border,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
