import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';

class _ClueTileData {
  final IconData icon;
  final Color color;
  final double rotationRad;
  final int dotCount;
  final bool isOdd;

  const _ClueTileData({
    required this.icon,
    required this.color,
    required this.rotationRad,
    required this.dotCount,
    required this.isOdd,
  });
}

class _AnomalyRound {
  final int gridSize;
  final List<_ClueTileData> tiles;
  final int oddIndex;

  const _AnomalyRound({
    required this.gridSize,
    required this.tiles,
    required this.oddIndex,
  });
}

class AnomalyLogicGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;
  final String? caseId;
  final String? storyCaption;

  const AnomalyLogicGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
    this.caseId,
    this.storyCaption,
  });

  @override
  State<AnomalyLogicGameScreen> createState() => _AnomalyLogicGameScreenState();
}

class _AnomalyLogicGameScreenState extends State<AnomalyLogicGameScreen> {
  final _rng = math.Random();
  static const int _totalRounds = 6;

  static const _iconPairs = <(IconData, IconData)>[
    (Icons.key_rounded, Icons.vpn_key_off_rounded),
    (Icons.lock_rounded, Icons.lock_open_rounded),
    (Icons.local_cafe_rounded, Icons.local_bar_rounded),
    (Icons.fingerprint_rounded, Icons.qr_code_2_rounded),
    (Icons.visibility_rounded, Icons.visibility_off_rounded),
    (Icons.schedule_rounded, Icons.hourglass_bottom_rounded),
    (Icons.shield_rounded, Icons.gpp_maybe_rounded),
  ];

  static const _rotatableIcons = <IconData>[
    Icons.navigation_rounded,
    Icons.key_rounded,
    Icons.send_rounded,
    Icons.push_pin_rounded,
  ];

  static const _palette = <Color>[
    AppColors.accentTeal,
    AppColors.accentAmber,
    AppColors.accentSky,
    AppColors.accentIndigo,
    AppColors.accentCrimson,
  ];

  int _roundIndex = 0;
  int _correct = 0;
  late _AnomalyRound _round;
  int? _pickedIndex;
  bool _locked = false;
  late double _timeLeft;
  late double _maxTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _maxTime = (11.5 - (widget.difficulty * 1.4)).clamp(6.5, 11.5);
    _loadNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _AnomalyRound _generateRound() {
    final gridSize = (widget.difficulty >= 3 || _roundIndex >= 4) ? 4 : 3;
    final total = gridSize * gridSize;
    final oddIdx = _rng.nextInt(total);
    final ruleType = _rng.nextInt(4);

    final baseColor = _palette[_rng.nextInt(_palette.length)];
    final altColors = _palette.where((c) => c != baseColor).toList();
    final oddColor = altColors[_rng.nextInt(altColors.length)];

    late List<_ClueTileData> tiles;

    if (ruleType == 0) {
      // Rule 0: Imposter symbol (all share Icon A, one has similar Icon B)
      final pair = _iconPairs[_rng.nextInt(_iconPairs.length)];
      final swap = _rng.nextBool();
      final normalIcon = swap ? pair.$1 : pair.$2;
      final oddIcon = swap ? pair.$2 : pair.$1;
      tiles = List.generate(total, (i) {
        final isOdd = i == oddIdx;
        return _ClueTileData(
          icon: isOdd ? oddIcon : normalIcon,
          color: baseColor,
          rotationRad: 0,
          dotCount: 0,
          isOdd: isOdd,
        );
      });
    } else if (ruleType == 1) {
      // Rule 1: Odd rotation angle!
      final icon = _rotatableIcons[_rng.nextInt(_rotatableIcons.length)];
      final baseQuarter = _rng.nextInt(4);
      final oddQuarter = (baseQuarter + 1 + _rng.nextInt(3)) % 4;
      tiles = List.generate(total, (i) {
        final isOdd = i == oddIdx;
        return _ClueTileData(
          icon: icon,
          color: baseColor,
          rotationRad: (isOdd ? oddQuarter : baseQuarter) * (math.pi / 2),
          dotCount: 0,
          isOdd: isOdd,
        );
      });
    } else if (ruleType == 2) {
      // Rule 2: Odd dot-stamp count under the icon!
      final icon = _iconPairs[_rng.nextInt(_iconPairs.length)].$1;
      final baseDots = 2 + _rng.nextInt(2); // 2 or 3
      final oddDots = baseDots == 2 ? 3 : 1;
      tiles = List.generate(total, (i) {
        final isOdd = i == oddIdx;
        return _ClueTileData(
          icon: icon,
          color: baseColor,
          rotationRad: 0,
          dotCount: isOdd ? oddDots : baseDots,
          isOdd: isOdd,
        );
      });
    } else {
      // Rule 3: Subtle accent color mismatch with mixed icons
      final iconA = _iconPairs[_rng.nextInt(_iconPairs.length)].$1;
      tiles = List.generate(total, (i) {
        final isOdd = i == oddIdx;
        return _ClueTileData(
          icon: iconA,
          color: isOdd ? oddColor : baseColor,
          rotationRad: 0,
          dotCount: 2,
          isOdd: isOdd,
        );
      });
    }

    return _AnomalyRound(gridSize: gridSize, tiles: tiles, oddIndex: oddIdx);
  }

  void _loadNext() {
    _timer?.cancel();
    if (_roundIndex >= _totalRounds) {
      final score = ((_correct / _totalRounds) * 100).round();
      Navigator.of(context).pop(
        MiniGameResult(
          skill: BrainSkill.logic,
          passed: _correct >= 4,
          score: score,
          correctCount: _correct,
          totalCount: _totalRounds,
        ),
      );
      return;
    }

    _round = _generateRound();
    _pickedIndex = null;
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
        _onTileTap(-1);
      }
    });
  }

  void _onTileTap(int index) {
    if (_locked) return;
    _locked = true;
    _timer?.cancel();

    final isRight = index == _round.oddIndex;
    if (isRight) {
      _correct++;
      HapticFeedback.mediumImpact();
      SoundService.instance.playCorrect();
    } else {
      HapticFeedback.heavyImpact();
      SoundService.instance.playWrong();
    }

    setState(() => _pickedIndex = index);
    Future.delayed(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      _roundIndex++;
      _loadNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final accent = AppColors.forSkill(BrainSkill.logic);
    final currentDisplay = (_roundIndex + 1).clamp(1, _totalRounds);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.logic)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$currentDisplay/$_totalRounds',
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
                skill: BrainSkill.logic,
                caption: widget.storyCaption ?? s.anomalyPrompt,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _timeLeft / _maxTime,
                backgroundColor: AppColors.surfaceElevated,
                color: _timeLeft < 2.2 ? AppColors.accentCrimson : accent,
                minHeight: 7,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      s.anomalyPrompt,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${s.scoreLabel}: $_correct/$_totalRounds',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _round.gridSize,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _round.tiles.length,
                    itemBuilder: (context, index) {
                      final tile = _round.tiles[index];
                      Color bg = AppColors.surfaceElevated;
                      Color border = AppColors.border;

                      if (_locked) {
                        if (tile.isOdd) {
                          bg = AppColors.success.withOpacity(0.24);
                          border = AppColors.success;
                        } else if (index == _pickedIndex) {
                          bg = AppColors.accentCrimson.withOpacity(0.24);
                          border = AppColors.accentCrimson;
                        }
                      }

                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _onTileTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border, width: 1.6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.rotate(
                                angle: tile.rotationRad,
                                child: Icon(
                                  tile.icon,
                                  color: tile.color,
                                  size: _round.gridSize == 3 ? 34 : 26,
                                ),
                              ),
                              if (tile.dotCount > 0) ...[
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    tile.dotCount,
                                    (_) => Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: tile.color.withOpacity(0.85),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
