import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';

class _MathQuestion {
  final String prompt;
  final int answer;
  final List<int> options;

  const _MathQuestion({
    required this.prompt,
    required this.answer,
    required this.options,
  });
}

class QuickMathGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;
  final String? caseId;
  final String? storyCaption;

  const QuickMathGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
    this.caseId,
    this.storyCaption,
  });

  @override
  State<QuickMathGameScreen> createState() => _QuickMathGameScreenState();
}

class _QuickMathGameScreenState extends State<QuickMathGameScreen> {
  final _rng = math.Random();
  static const int _totalQuestions = 8;

  int _index = 0;
  int _correct = 0;
  late _MathQuestion _question;
  int? _picked;
  bool _locked = false;
  late double _timeLeft;
  late double _maxTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _maxTime = (10.0 - (widget.difficulty * 1.1)).clamp(5.5, 10.0);
    _loadNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _MathQuestion _generate() {
    final op = _rng.nextInt(4);
    final range = 10 + widget.difficulty * 8;
    late String prompt;
    late int answer;

    if (op == 0) {
      final a = 6 + _rng.nextInt(range);
      final b = 5 + _rng.nextInt(range);
      prompt = '$a + $b = ?';
      answer = a + b;
    } else if (op == 1) {
      final b = 4 + _rng.nextInt(range);
      final ans = 3 + _rng.nextInt(range);
      final a = b + ans;
      prompt = '$a − $b = ?';
      answer = ans;
    } else if (op == 2) {
      final a = 3 + _rng.nextInt(5 + widget.difficulty * 2);
      final b = 3 + _rng.nextInt(7);
      prompt = '$a × $b = ?';
      answer = a * b;
    } else {
      // Missing operand audit: a + ? = c
      final a = 7 + _rng.nextInt(range);
      final ans = 4 + _rng.nextInt(range);
      final total = a + ans;
      prompt = '$a + ? = $total';
      answer = ans;
    }

    final opts = <int>{answer};
    while (opts.length < 4) {
      final delta = (_rng.nextInt(13) - 6);
      final candidate = answer + (delta == 0 ? 3 : delta);
      if (candidate > 0) opts.add(candidate);
    }
    final list = opts.toList()..shuffle(_rng);
    return _MathQuestion(prompt: prompt, answer: answer, options: list);
  }

  void _loadNext() {
    _timer?.cancel();
    if (_index >= _totalQuestions) {
      final score = ((_correct / _totalQuestions) * 100).round();
      Navigator.of(context).pop(
        MiniGameResult(
          skill: BrainSkill.math,
          passed: _correct >= 6,
          score: score,
          correctCount: _correct,
          totalCount: _totalQuestions,
        ),
      );
      return;
    }

    _question = _generate();
    _picked = null;
    _locked = false;
    _timeLeft = _maxTime;
    setState(() {});

    _timer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _timeLeft = (_timeLeft - 0.08).clamp(0, _maxTime));
      if (_timeLeft <= 0) {
        t.cancel();
        _submit(-1);
      }
    });
  }

  void _submit(int value) {
    if (_locked) return;
    _locked = true;
    _timer?.cancel();

    final isRight = value == _question.answer;
    if (isRight) {
      _correct++;
      HapticFeedback.lightImpact();
      SoundService.instance.playCorrect();
    } else {
      HapticFeedback.heavyImpact();
      SoundService.instance.playWrong();
    }
    setState(() => _picked = value);
    Future.delayed(const Duration(milliseconds: 420), () {
      if (!mounted) return;
      _index++;
      _loadNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final accent = AppColors.forSkill(BrainSkill.math);
    final currentDisplay = (_index + 1).clamp(1, _totalQuestions);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.math)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$currentDisplay/$_totalQuestions',
                style: TextStyle(color: accent, fontWeight: FontWeight.w800),
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
                skill: BrainSkill.math,
                caption: widget.storyCaption ?? s.skillGameDesc(BrainSkill.math),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _timeLeft / _maxTime,
                backgroundColor: AppColors.surfaceElevated,
                color: _timeLeft < 2.0 ? AppColors.accentCrimson : accent,
                minHeight: 7,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 14),
              Text(
                s.mathPrompt,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Text(
                      _question.prompt,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                childAspectRatio: 2.2,
                children: _question.options.map((opt) {
                  Color bg = AppColors.surfaceElevated;
                  Color border = AppColors.border;
                  if (_locked) {
                    if (opt == _question.answer) {
                      bg = AppColors.success.withOpacity(0.22);
                      border = AppColors.success;
                    } else if (opt == _picked) {
                      bg = AppColors.accentCrimson.withOpacity(0.22);
                      border = AppColors.accentCrimson;
                    }
                  }
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _submit(opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border, width: 1.6),
                      ),
                      child: Text(
                        '$opt',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
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
