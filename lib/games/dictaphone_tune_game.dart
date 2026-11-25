import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';

/// Bukti 2: "Selaraskan Pita Diktafon" (Frequency Slider)
/// Slider frekuensi 0-100 dengan visualizer gelombang suara real-time.
/// Pemain mencari titik frekuensi tepat (default 74 ± 3) hingga statis hilang
/// dan transkrip rekaman dokter jaga tahun 1998 terbaca jernih.
class DictaphoneTuneGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;
  final String? stageId;

  const DictaphoneTuneGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
    this.stageId,
  });

  @override
  State<DictaphoneTuneGameScreen> createState() =>
      _DictaphoneTuneGameScreenState();
}

class _DictaphoneTuneGameScreenState extends State<DictaphoneTuneGameScreen> {
  static const double _tolerance = 3.0;
  late double _targetFrequency;
  double _frequency = 22.0;
  double _phase = 0.0;
  double _lockProgress = 0.0; // Fills while held inside 74 ± 3
  bool _completed = false;
  Timer? _animTimer;

  @override
  void initState() {
    super.initState();
    // Story Case #01 Stage 2 uses 74 Hz exactly per spec; other stages vary slightly.
    if (widget.stageId == null || widget.stageId == 'c1_s2') {
      _targetFrequency = 74.0;
    } else {
      _targetFrequency = (32 + math.Random().nextInt(52)).toDouble();
    }

    _animTimer = Timer.periodic(const Duration(milliseconds: 55), (_) {
      if (!mounted || _completed) return;
      final inZone = _isLockedZone;
      setState(() {
        _phase += 0.28;
        if (inZone) {
          _lockProgress = (_lockProgress + 0.045).clamp(0.0, 1.0);
        } else {
          _lockProgress = (_lockProgress - 0.06).clamp(0.0, 1.0);
        }
      });

      if (_lockProgress >= 1.0 && !_completed) {
        _completeStage();
      }
    });
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  double get _distance => (_frequency - _targetFrequency).abs();
  bool get _isLockedZone => _distance <= _tolerance;
  double get _clarity => (1.0 - (_distance / 32.0)).clamp(0.0, 1.0);

  Future<void> _completeStage() async {
    if (_completed) return;
    _completed = true;
    _animTimer?.cancel();
    HapticFeedback.heavyImpact();
    SoundService.instance.playUnlock();
    setState(() => _lockProgress = 1.0);

    await Future.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;
    Navigator.of(context).pop(
      const MiniGameResult(
        skill: BrainSkill.focus,
        passed: true,
        score: 100,
        correctCount: 1,
        totalCount: 1,
      ),
    );
  }

  String _renderTranscript(AppStrings s) {
    final fullText = s.isId
        ? '[REKAMAN 1998 — 01:45]\n"Pasien Ruang 304 bukan kabur... pintu isolasi sengaja disegel dari luar sebelum api menjalar ke ruang arsip..."'
        : '[1998 TAPE — 01:45]\n"The Room 304 patient didn\'t escape... someone bolted the isolation door from outside before the archive fire..."';

    if (_isLockedZone || _completed) return fullText;

    const noiseChars = '#@%*!?/~^=';
    final buf = StringBuffer();
    final keepRatio = (_clarity * 0.82).clamp(0.08, 0.85);
    for (int i = 0; i < fullText.length; i++) {
      final ch = fullText[i];
      if (ch == ' ' || ch == '\n') {
        buf.write(ch);
      } else {
        // Deterministic pseudo-random scramble per frequency step
        final hash = ((i * 37) + (_frequency.round() * 13)) % 100;
        if (hash < (keepRatio * 100)) {
          buf.write(ch);
        } else {
          buf.write(noiseChars[(i + _frequency.round()) % noiseChars.length]);
        }
      }
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final inZone = _isLockedZone;
    final nearZone = !inZone && _distance <= 12.0;

    final statusColor = inZone
        ? AppColors.success
        : nearZone
            ? AppColors.accentAmber
            : AppColors.accentCrimson;

    final statusText = inZone
        ? s.staticClear
        : nearZone
            ? s.staticNear
            : s.staticHigh;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.focus)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_frequency.toStringAsFixed(0)} Hz',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
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
              Text(
                s.dictaphoneHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Retro 1998 Cassette Dictaphone Visualizer Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: statusColor.withOpacity(0.65),
                    width: 1.6,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.album_rounded,
                                color: statusColor, size: 18),
                            const SizedBox(width: 6),
                            const Text(
                              'TAPE • 1998-B',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Animated Soundwave Visualizer
                    SizedBox(
                      height: 96,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _SoundwavePainter(
                          phase: _phase,
                          clarity: _clarity,
                          inZone: inZone,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: _lockProgress,
                      backgroundColor: AppColors.surfaceElevated,
                      color: AppColors.success,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Live Unscramble Transcript Display
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1013),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: inZone
                          ? AppColors.accentAmber.withOpacity(0.6)
                          : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        _renderTranscript(s),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14.5,
                          height: 1.55,
                          fontWeight:
                              inZone ? FontWeight.w700 : FontWeight.w500,
                          color: inZone
                              ? AppColors.accentAmber
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Frequency Slider (0 - 100)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '0 Hz',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    '${s.frequencyLabel}: ${_frequency.toStringAsFixed(0)} Hz',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    '100 Hz',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: statusColor,
                  inactiveTrackColor: AppColors.surfaceElevated,
                  thumbColor: AppColors.accentAmber,
                  overlayColor: AppColors.accentAmber.withOpacity(0.2),
                  trackHeight: 7,
                ),
                child: Slider(
                  value: _frequency,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: _completed
                      ? null
                      : (v) {
                          if ((v - _targetFrequency).abs() <= _tolerance &&
                              !_isLockedZone) {
                            HapticFeedback.mediumImpact();
                            SoundService.instance.playCorrect();
                          }
                          setState(() => _frequency = v);
                        },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: inZone && !_completed ? _completeStage : null,
                  icon: const Icon(Icons.hearing_rounded),
                  label: Text(s.lockTranscriptBtn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoundwavePainter extends CustomPainter {
  final double phase;
  final double clarity;
  final bool inZone;

  _SoundwavePainter({
    required this.phase,
    required this.clarity,
    required this.inZone,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    // Background grid line
    canvas.drawLine(
      Offset(0, midY),
      Offset(w, midY),
      Paint()
        ..color = AppColors.border.withOpacity(0.6)
        ..strokeWidth = 1,
    );

    final waveColor = inZone
        ? AppColors.success
        : clarity > 0.65
            ? AppColors.accentAmber
            : AppColors.accentCrimson;

    final path = Path();
    const samples = 80;
    for (int i = 0; i <= samples; i++) {
      final t = i / samples;
      final x = t * w;
      final envelope = math.sin(t * math.pi);
      // Clean voice wave
      final clean = math.sin(t * 14 + phase) * 0.55 +
          math.sin(t * 28 - phase * 1.4) * 0.25;
      // Chaotic static distortion
      final noise = math.sin(i * 19.7 + phase * 6.3) *
          math.cos(i * 7.3 - phase * 4.1);
      final distortion = 1.0 - clarity;
      final y = midY +
          (clean * (0.4 + clarity * 0.6) + noise * distortion * 1.35) *
              (h * 0.38) *
              envelope;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = waveColor.withOpacity(0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = waveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SoundwavePainter oldDelegate) => true;
}
