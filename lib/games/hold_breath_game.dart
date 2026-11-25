import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';

/// Bukti 4: "Tahan Napas" (Press & Hold Tension)
/// Pemain menahan tombol "TAHAN NAPAS" selama 6 detik penuh sementara siluet
/// bayangan mendorong brankar melintas di lorong gelap.
/// Bar detak jantung naik menegangkan; jika melepas sebelum 6 detik selesai
/// atau bar detak jantung penuh (100%), layar berkedip merah & tahap diulang.
class HoldBreathGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;

  const HoldBreathGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
  });

  @override
  State<HoldBreathGameScreen> createState() => _HoldBreathGameScreenState();
}

class _HoldBreathGameScreenState extends State<HoldBreathGameScreen> {
  static const double _requiredSeconds = 6.0;

  bool _isHolding = false;
  bool _hasStartedAttempt = false;
  bool _completed = false;
  bool _redFlash = false;
  String? _failBanner;

  double _heldSeconds = 0.0;
  double _heartbeatLevel = 0.22; // 0.0 .. 1.0 (1.0 = panic fail!)
  double _flickerPhase = 0.0;
  Timer? _tickTimer;
  int _thumpTick = 0;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted || _completed) return;

      _flickerPhase += 0.25;
      _thumpTick++;

      if (_isHolding) {
        // Steady 6.0s hold raises heartbeat thrillingly from ~0.22 to ~0.91
        final nextHeld = (_heldSeconds + 0.05).clamp(0.0, _requiredSeconds);
        final nextBeat = (_heartbeatLevel + 0.0056).clamp(0.0, 1.0);

        // Rhythmic heartbeat haptic pulse (gets faster as beat rises!)
        final thumpInterval = nextBeat > 0.7 ? 7 : 11;
        if (_thumpTick % thumpInterval == 0) {
          HapticFeedback.lightImpact();
        }

        if (nextBeat >= 1.0) {
          _triggerFailure(widget.strings.holdBreathFailPanic);
          return;
        }

        setState(() {
          _heldSeconds = nextHeld;
          _heartbeatLevel = nextBeat;
        });

        if (nextHeld >= _requiredSeconds) {
          _completeSuccess();
        }
      } else {
        // While NOT holding, heartbeat gently settles back toward 0.22 unless
        // the player already hesitated after the gurney arrived.
        setState(() {
          _heartbeatLevel = (_heartbeatLevel - 0.008).clamp(0.22, 1.0);
        });
      }
    });
  }

  void _onPressStart() {
    if (_completed) return;
    HapticFeedback.mediumImpact();
    SoundService.instance.playTap();
    setState(() {
      _isHolding = true;
      _hasStartedAttempt = true;
      _failBanner = null;
      _redFlash = false;
    });
  }

  void _onPressEnd() {
    if (_completed || !_isHolding) return;
    if (_heldSeconds < _requiredSeconds && _hasStartedAttempt) {
      _triggerFailure(widget.strings.holdBreathFailRelease);
    }
  }

  void _triggerFailure(String reason) {
    HapticFeedback.heavyImpact();
    SoundService.instance.playWrong();
    setState(() {
      _isHolding = false;
      _hasStartedAttempt = false;
      _heldSeconds = 0.0;
      _heartbeatLevel = 0.28;
      _redFlash = true;
      _failBanner = reason;
    });

    Future.delayed(const Duration(milliseconds: 420), () {
      if (!mounted) return;
      setState(() => _redFlash = false);
    });
  }

  Future<void> _completeSuccess() async {
    _completed = true;
    _tickTimer?.cancel();
    HapticFeedback.heavyImpact();
    SoundService.instance.playUnlock();
    setState(() => _isHolding = false);

    await Future.delayed(const Duration(milliseconds: 950));
    if (!mounted) return;
    Navigator.of(context).pop(
      const MiniGameResult(
        skill: BrainSkill.math,
        passed: true,
        score: 100,
        correctCount: 6,
        totalCount: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final progress = (_heldSeconds / _requiredSeconds).clamp(0.0, 1.0);
    final bpm = (68 + (_heartbeatLevel * 96)).round();
    final dangerBeat = _heartbeatLevel > 0.72;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.math)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_heldSeconds.toStringAsFixed(1)}s / 6.0s',
                style: TextStyle(
                  color: _completed ? AppColors.success : AppColors.accentAmber,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    _failBanner ?? s.holdBreathTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _failBanner != null
                          ? AppColors.accentCrimson
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Atmospheric Dark Corridor Canvas with Gurney Silhouette passing!
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _completed
                                ? AppColors.success
                                : _isHolding
                                    ? AppColors.accentCrimson.withOpacity(0.7)
                                    : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(
                          painter: _GurneyCorridorPainter(
                            progress: progress,
                            flickerPhase: _flickerPhase,
                            isHolding: _isHolding,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Survive Progress (6 Seconds)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.surviveTimeLabel,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${_heldSeconds.toStringAsFixed(1)}s / 6.0s',
                        style: const TextStyle(
                          color: AppColors.accentAmber,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceElevated,
                    color: _completed
                        ? AppColors.success
                        : AppColors.accentAmber,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 14),

                  // Rising Heartbeat Tension Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            color: dangerBeat
                                ? AppColors.accentCrimson
                                : AppColors.accentTeal,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            s.heartbeatLabel,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$bpm BPM',
                        style: TextStyle(
                          color: dangerBeat
                              ? AppColors.accentCrimson
                              : AppColors.accentTeal,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: _heartbeatLevel,
                    backgroundColor: AppColors.surfaceElevated,
                    color: dangerBeat
                        ? AppColors.accentCrimson
                        : AppColors.accentTeal,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 20),

                  // Big Press & Hold "TAHAN NAPAS" Trigger
                  Listener(
                    onPointerDown: (_) => _onPressStart(),
                    onPointerUp: (_) => _onPressEnd(),
                    onPointerCancel: (_) => _onPressEnd(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _completed
                            ? AppColors.success
                            : _isHolding
                                ? AppColors.accentCrimson
                                : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _completed
                              ? AppColors.success
                              : _isHolding
                                  ? const Color(0xFFFCA5A5)
                                  : AppColors.accentAmber,
                          width: 2,
                        ),
                        boxShadow: _isHolding
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.accentCrimson.withOpacity(0.45),
                                  blurRadius: 18,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _completed
                                ? Icons.check_circle_rounded
                                : _isHolding
                                    ? Icons.air_rounded
                                    : Icons.touch_app_rounded,
                            color: _isHolding || _completed
                                ? Colors.white
                                : AppColors.accentAmber,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _completed
                                ? s.t('AMAN — SOSOK SUDAH LEWAT',
                                    'SAFE — THE SHADOW PASSED')
                                : _isHolding
                                    ? s.holdingBreathBtn
                                    : s.holdBreathBtn,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: _isHolding || _completed
                                  ? Colors.white
                                  : AppColors.accentAmber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Red Emergency Flash Overlay on Fail!
          if (_redFlash)
            IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                color: AppColors.accentCrimson.withOpacity(0.55),
              ),
            ),
        ],
      ),
    );
  }
}

class _GurneyCorridorPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0 as gurney crosses corridor
  final double flickerPhase;
  final bool isHolding;

  _GurneyCorridorPainter({
    required this.progress,
    required this.flickerPhase,
    required this.isHolding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Dark abandoned hospital corridor backdrop
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF060A0C), Color(0xFF0F1B1E), Color(0xFF05080A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Flickering emergency ceiling light cone
    final flicker = (math.sin(flickerPhase * 2.4) > -0.35) ? 1.0 : 0.22;
    final lightColor =
        isHolding ? AppColors.accentCrimson : AppColors.accentTeal;
    final cone = Path()
      ..moveTo(w * 0.50, 0)
      ..lineTo(w * 0.16, h * 0.86)
      ..lineTo(w * 0.84, h * 0.86)
      ..close();
    canvas.drawPath(
      cone,
      Paint()
        ..shader = LinearGradient(
          colors: [
            lightColor.withOpacity(0.28 * flicker),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Hospital corridor door & floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.80, w, h * 0.20),
      Paint()..color = const Color(0xFF080E11),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.42, h * 0.24, w * 0.16, h * 0.56),
      Paint()
        ..color = const Color(0xFF152429)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Creepy Shadow Figure Pushing Hospital Gurney (Brankar) moving left -> right!
    final gx = -w * 0.18 + progress * (w * 1.36);
    final floorY = h * 0.80;
    final silPaint = Paint()..color = const Color(0xFF030608);

    // Gurney frame (bed + legs + wheels)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(gx, floorY - 46, 98, 12),
        const Radius.circular(4),
      ),
      silPaint,
    );
    // Draped sheet lump on gurney
    final sheet = Path()
      ..moveTo(gx + 6, floorY - 46)
      ..quadraticBezierTo(gx + 34, floorY - 64, gx + 68, floorY - 52)
      ..quadraticBezierTo(gx + 86, floorY - 56, gx + 94, floorY - 46)
      ..close();
    canvas.drawPath(sheet, silPaint);
    // Legs & wheels
    final metalPaint = Paint()
      ..color = const Color(0xFF1B2B30)
      ..strokeWidth = 3.5;
    canvas.drawLine(
        Offset(gx + 14, floorY - 34), Offset(gx + 14, floorY - 8), metalPaint);
    canvas.drawLine(
        Offset(gx + 84, floorY - 34), Offset(gx + 84, floorY - 8), metalPaint);
    canvas.drawCircle(Offset(gx + 14, floorY - 6), 6, silPaint);
    canvas.drawCircle(Offset(gx + 84, floorY - 6), 6, silPaint);

    // Tall hunched shadow pushing the gurney from behind
    final px = gx - 22;
    canvas.drawCircle(Offset(px + 6, floorY - 94), 13, silPaint);
    final torso = Path()
      ..moveTo(px - 10, floorY - 4)
      ..lineTo(px - 6, floorY - 78)
      ..lineTo(px + 18, floorY - 74)
      ..lineTo(gx + 4, floorY - 46)
      ..lineTo(px + 12, floorY - 4)
      ..close();
    canvas.drawPath(torso, silPaint);

    // Eerie dim eyes on the shadow when holding
    if (isHolding) {
      canvas.drawCircle(
        Offset(px + 12, floorY - 96),
        2.0,
        Paint()..color = const Color(0xFFFCA5A5).withOpacity(0.8),
      );
    }

    // Foreground curtain edges (Raka's hiding spot!)
    final curtainPaint = Paint()..color = const Color(0xFF040709).withOpacity(0.88);
    canvas.drawRect(Rect.fromLTWH(0, 0, w * 0.08, h), curtainPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.92, 0, w * 0.08, h), curtainPaint);
  }

  @override
  bool shouldRepaint(covariant _GurneyCorridorPainter oldDelegate) => true;
}
