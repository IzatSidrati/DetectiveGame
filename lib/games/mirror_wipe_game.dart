import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../widgets/optional_asset_image.dart';

/// Bukti 1: "Usap Cermin" (Scratch/Wipe Canvas)
/// Pemain mengusap lapisan embun buram (mouse drag / touch swipe) minimal 75%
/// untuk menyingkap angka "304" dan "01:45". Semakin bersih embun, sosok samar
/// muncul di sudut cermin disertai efek getar halus.
class MirrorWipeGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;
  final String? stageId;

  const MirrorWipeGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
    this.stageId,
  });

  @override
  State<MirrorWipeGameScreen> createState() => _MirrorWipeGameScreenState();
}

class _MirrorWipeGameScreenState extends State<MirrorWipeGameScreen> {
  static const int _cols = 24;
  static const int _rows = 16;
  static const double _targetRatio = 0.75;

  late List<double> _fogGrid; // 1.0 = full fog, 0.0 = completely wiped
  final _rng = math.Random();
  double _clearedRatio = 0.0;
  double _shakeX = 0.0;
  double _shakeY = 0.0;
  bool _completed = false;
  DateTime _lastHaptic = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _fogGrid = List<double>.filled(_cols * _rows, 1.0);
  }

  void _wipeAt(Offset localPos, Size canvasSize) {
    if (_completed || canvasSize.width <= 0 || canvasSize.height <= 0) return;

    final gx = (localPos.dx / canvasSize.width) * _cols;
    final gy = (localPos.dy / canvasSize.height) * _rows;
    const brushRadius = 2.35;

    bool changed = false;
    for (int r = 0; r < _rows; r++) {
      for (int c = 0; c < _cols; c++) {
        final dx = (c + 0.5) - gx;
        final dy = (r + 0.5) - gy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist <= brushRadius) {
          final idx = r * _cols + c;
          final falloff = (1.0 - (dist / brushRadius)).clamp(0.2, 1.0);
          final nextVal = (_fogGrid[idx] - falloff * 0.75).clamp(0.0, 1.0);
          if (nextVal < _fogGrid[idx]) {
            _fogGrid[idx] = nextVal;
            changed = true;
          }
        }
      }
    }

    if (!changed) return;

    int clearedCells = 0;
    for (final v in _fogGrid) {
      if (v <= 0.35) clearedCells++;
    }
    final nextRatio = clearedCells / _fogGrid.length;

    // Subtle horror shiver & haptic pulses as the shadow emerges (>30% wiped)
    double sx = 0;
    double sy = 0;
    if (nextRatio > 0.30) {
      final intensity = ((nextRatio - 0.30) / 0.45).clamp(0.0, 1.0);
      sx = (_rng.nextDouble() * 2 - 1) * (1.5 + intensity * 3.5);
      sy = (_rng.nextDouble() * 2 - 1) * (1.2 + intensity * 2.5);

      final now = DateTime.now();
      if (now.difference(_lastHaptic).inMilliseconds > 180) {
        _lastHaptic = now;
        if (nextRatio > 0.55) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }
    }

    setState(() {
      _clearedRatio = nextRatio;
      _shakeX = sx;
      _shakeY = sy;
    });

    if (nextRatio >= _targetRatio && !_completed) {
      _finishSuccess();
    }
  }

  void _resetShake() {
    if (!mounted) return;
    setState(() {
      _shakeX = 0;
      _shakeY = 0;
    });
  }

  Future<void> _finishSuccess() async {
    _completed = true;
    HapticFeedback.heavyImpact();
    SoundService.instance.playUnlock();
    setState(() {
      for (int i = 0; i < _fogGrid.length; i++) {
        _fogGrid[i] = 0.0;
      }
      _clearedRatio = 1.0;
      _shakeX = 0;
      _shakeY = 0;
    });

    await Future.delayed(const Duration(milliseconds: 1150));
    if (!mounted) return;
    Navigator.of(context).pop(
      const MiniGameResult(
        skill: BrainSkill.memory,
        passed: true,
        score: 100,
        correctCount: 1,
        totalCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final accent = AppColors.forSkill(BrainSkill.memory);
    final pct = (_clearedRatio * 100).round().clamp(0, 100);
    // Ghost shadow opacity rises eerily between 25% and 75% wiped
    final ghostOpacity =
        ((_clearedRatio - 0.25) / 0.50).clamp(0.0, 0.88);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.memory)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$pct% / 75%',
                style: TextStyle(
                  color: _completed ? AppColors.success : accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_clearedRatio / _targetRatio).clamp(0.0, 1.0),
                backgroundColor: AppColors.surfaceElevated,
                color: _completed ? AppColors.success : accent,
                minHeight: 7,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ghostOpacity > 0.35 && !_completed
                        ? AppColors.accentCrimson.withOpacity(0.65)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _completed
                          ? Icons.visibility_rounded
                          : ghostOpacity > 0.35
                              ? Icons.warning_amber_rounded
                              : Icons.swipe_rounded,
                      color: _completed
                          ? AppColors.success
                          : ghostOpacity > 0.35
                              ? AppColors.accentCrimson
                              : AppColors.accentAmber,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _completed
                            ? s.mirrorRevealedBanner
                            : ghostOpacity > 0.35
                                ? s.mirrorShadowWarning
                                : s.wipeMirrorHint,
                        style: TextStyle(
                          color: ghostOpacity > 0.35 && !_completed
                              ? AppColors.accentCrimson
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Interactive Fogged Mirror Canvas
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(_shakeX, _shakeY),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final canvasSize = Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          );
                          return GestureDetector(
                            onPanStart: (d) =>
                                _wipeAt(d.localPosition, canvasSize),
                            onPanUpdate: (d) =>
                                _wipeAt(d.localPosition, canvasSize),
                            onPanEnd: (_) => _resetShake(),
                            onTapDown: (d) =>
                                _wipeAt(d.localPosition, canvasSize),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: _completed
                                        ? AppColors.success
                                        : AppColors.accentTeal.withOpacity(0.65),
                                    width: 2.5,
                                  ),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Base evidence image or haunted hospital mirror glass
                                    OptionalAssetImage(
                                      basePath:
                                          'assets/images/${widget.stageId ?? "c1_s1"}_evidence',
                                      fallback: CustomPaint(
                                        painter: _HauntedMirrorBasePainter(),
                                      ),
                                    ),
                                    // Cold eerie tint overlay
                                    Container(
                                      color: const Color(0xFF0A191C)
                                          .withOpacity(0.42),
                                    ),
                                    // Etched secret clue numbers: "304" and "01:45"
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '304',
                                            style: TextStyle(
                                              fontSize: 64,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 10,
                                              color: const Color(0xFFD6F5F0)
                                                  .withOpacity(0.92),
                                              shadows: const [
                                                Shadow(
                                                  color: Color(0xFF061012),
                                                  blurRadius: 12,
                                                ),
                                                Shadow(
                                                  color: AppColors.accentTeal,
                                                  blurRadius: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.45),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.accentCrimson
                                                    .withOpacity(0.75),
                                              ),
                                            ),
                                            child: const Text(
                                              '01:45',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 6,
                                                color: Color(0xFFFCA5A5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Eerie pale silhouette emerging in the corner of the mirror!
                                    if (ghostOpacity > 0.02)
                                      IgnorePointer(
                                        child: Opacity(
                                          opacity: ghostOpacity,
                                          child: CustomPaint(
                                            painter: _CornerShadowPainter(),
                                          ),
                                        ),
                                      ),
                                    // Wipeable Condensation / Fog Overlay
                                    IgnorePointer(
                                      child: CustomPaint(
                                        painter: _FogOverlayPainter(
                                          grid: _fogGrid,
                                          cols: _cols,
                                          rows: _rows,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${s.mirrorClearedLabel}: $pct%',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _HauntedMirrorBasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF0E1B1E), Color(0xFF172C30), Color(0xFF091114)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Subtle cracked mirror lines
    final crack = Paint()
      ..color = const Color(0xFF9AC7C2).withOpacity(0.22)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final p = Path()
      ..moveTo(0, h * 0.18)
      ..lineTo(w * 0.22, h * 0.34)
      ..lineTo(w * 0.15, h * 0.62);
    canvas.drawPath(p, crack);
    canvas.drawLine(Offset(w * 0.22, h * 0.34), Offset(w * 0.36, h * 0.28), crack);

    // Subtle diagonal glass reflection sheen
    canvas.drawLine(
      Offset(w * 0.10, 0),
      Offset(0, h * 0.25),
      Paint()
        ..color = Colors.white.withOpacity(0.06)
        ..strokeWidth = 28,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.84;
    final cy = h * 0.38;

    // Eerie dark silhouette head + draped shoulders in upper-right mirror corner
    final shadowPaint = Paint()
      ..color = const Color(0xFF04080A).withOpacity(0.86)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: w * 0.16, height: h * 0.26),
      shadowPaint,
    );
    final body = Path()
      ..moveTo(cx - w * 0.13, h)
      ..quadraticBezierTo(cx - w * 0.11, cy + h * 0.10, cx, cy + h * 0.10)
      ..quadraticBezierTo(cx + w * 0.14, cy + h * 0.10, w, h * 0.85)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(body, shadowPaint);

    // Faint pale staring eyes
    final eyePaint = Paint()..color = const Color(0xFFD9F3EF).withOpacity(0.85);
    canvas.drawCircle(Offset(cx - 8, cy - 3), 2.5, eyePaint);
    canvas.drawCircle(Offset(cx + 6, cy - 3), 2.5, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FogOverlayPainter extends CustomPainter {
  final List<double> grid;
  final int cols;
  final int rows;

  _FogOverlayPainter({
    required this.grid,
    required this.cols,
    required this.rows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final alpha = grid[r * cols + c];
        if (alpha <= 0.04) continue;
        final rect = Rect.fromLTWH(
          c * cellW - 1,
          r * cellH - 1,
          cellW + 2,
          cellH + 2,
        );
        canvas.drawRect(
          rect,
          Paint()
            ..color = Color.lerp(
              const Color(0xFF8FB0B2),
              const Color(0xFFC4DADB),
              ((r + c) % 3) / 3.0,
            )!
                .withOpacity(alpha * 0.94),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FogOverlayPainter oldDelegate) => true;
}
