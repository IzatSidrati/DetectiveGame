import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';

class _ColorOption {
  final String idLabel;
  final String enLabel;
  final Color color;

  const _ColorOption({
    required this.idLabel,
    required this.enLabel,
    required this.color,
  });

  String label(AppLanguage lang) => lang == AppLanguage.id ? idLabel : enLabel;
}

const List<_ColorOption> _kStroopColors = [
  _ColorOption(idLabel: 'MERAH', enLabel: 'RED', color: Color(0xFFEF4444)),
  _ColorOption(idLabel: 'BIRU', enLabel: 'BLUE', color: Color(0xFF38BDF8)),
  _ColorOption(idLabel: 'HIJAU', enLabel: 'GREEN', color: Color(0xFF22C55E)),
  _ColorOption(idLabel: 'KUNING', enLabel: 'YELLOW', color: Color(0xFFFACC15)),
];

class StroopFocusGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;
  final String? caseId;
  final String? storyCaption;

  const StroopFocusGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
    this.caseId,
    this.storyCaption,
  });

  @override
  State<StroopFocusGameScreen> createState() => _StroopFocusGameScreenState();
}

class _StroopFocusGameScreenState extends State<StroopFocusGameScreen> {
  final _rng = math.Random();
  static const int _totalQuestions = 10;

  int _questionIndex = 0;
  int _correct = 0;
  late _ColorOption _wordOption;
  late _ColorOption _inkOption;
  late double _timeLeft;
  late double _maxTime;
  Timer? _timer;
  bool? _lastFeedback;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _maxTime = (4.2 - (widget.difficulty * 0.45)).clamp(2.2, 4.0);
    _nextQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (_questionIndex >= _totalQuestions) {
      _finish();
      return;
    }

    final wordIdx = _rng.nextInt(_kStroopColors.length);
    // 80% chance incongruent (classic Stroop conflict)
    int inkIdx;
    if (_rng.nextDouble() < 0.8) {
      inkIdx = (wordIdx + 1 + _rng.nextInt(_kStroopColors.length - 1)) %
          _kStroopColors.length;
    } else {
      inkIdx = wordIdx;
    }

    _wordOption = _kStroopColors[wordIdx];
    _inkOption = _kStroopColors[inkIdx];
    _timeLeft = _maxTime;
    _lastFeedback = null;
    _locked = false;
    setState(() {});

    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _timeLeft = (_timeLeft - 0.05).clamp(0, _maxTime);
      });
      if (_timeLeft <= 0) {
        t.cancel();
        _handleAnswer(null);
      }
    });
  }

  void _handleAnswer(_ColorOption? picked) {
    if (_locked) return;
    _locked = true;
    _timer?.cancel();

    final isRight = picked != null && picked.color == _inkOption.color;
    if (isRight) {
      _correct++;
      HapticFeedback.lightImpact();
      SoundService.instance.playCorrect();
    } else {
      HapticFeedback.heavyImpact();
      SoundService.instance.playWrong();
    }

    setState(() => _lastFeedback = isRight);
    Future.delayed(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      _questionIndex++;
      _nextQuestion();
    });
  }

  void _finish() {
    final score = ((_correct / _totalQuestions) * 100).round();
    Navigator.of(context).pop(
      MiniGameResult(
        skill: BrainSkill.focus,
        passed: _correct >= 7,
        score: score,
        correctCount: _correct,
        totalCount: _totalQuestions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final accent = AppColors.forSkill(BrainSkill.focus);
    final currentDisplay = (_questionIndex + 1).clamp(1, _totalQuestions);

    Color cardBorder = AppColors.border;
    if (_lastFeedback == true) cardBorder = AppColors.success;
    if (_lastFeedback == false) cardBorder = AppColors.accentCrimson;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.focus)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$currentDisplay/$_totalQuestions',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
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
                skill: BrainSkill.focus,
                caption: widget.storyCaption ?? s.skillGameDesc(BrainSkill.focus),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _timeLeft / _maxTime,
                backgroundColor: AppColors.surfaceElevated,
                color: _timeLeft < 1.0 ? AppColors.accentCrimson : accent,
                minHeight: 7,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 14),
              Text(
                s.stroopPrompt,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cardBorder, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      _wordOption.label(s.lang),
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        color: _inkOption.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${s.scoreLabel}: $_correct/$_totalQuestions',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.3,
                children: _kStroopColors.map((opt) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _handleAnswer(opt),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: opt.color.withOpacity(0.75),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: opt.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            opt.label(s.lang),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
