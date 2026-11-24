import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';

class CognitiveRadarChart extends StatelessWidget {
  final Map<BrainSkill, int> scores;
  final AppStrings strings;

  const CognitiveRadarChart({
    super.key,
    required this.scores,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: CustomPaint(
        painter: _RadarPainter(
          scores: scores,
          labels: [
            strings.skillName(BrainSkill.memory),
            strings.skillName(BrainSkill.focus),
            strings.skillName(BrainSkill.logic),
            strings.skillName(BrainSkill.math),
          ],
          values: [
            (scores[BrainSkill.memory] ?? 20) / 100.0,
            (scores[BrainSkill.focus] ?? 20) / 100.0,
            (scores[BrainSkill.logic] ?? 20) / 100.0,
            (scores[BrainSkill.math] ?? 20) / 100.0,
          ],
          colors: const [
            AppColors.accentIndigo,
            AppColors.accentAmber,
            AppColors.accentTeal,
            AppColors.accentSky,
          ],
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<BrainSkill, int> scores;
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;

  _RadarPainter({
    required this.scores,
    required this.labels,
    required this.values,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    const count = 4;

    final gridPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric diamonds
    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * (ring / 4);
      final path = Path();
      for (int i = 0; i < count; i++) {
        final angle = -math.pi / 2 + (2 * math.pi * i / count);
        final pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axes
    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      final pt = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(center, pt, gridPaint);
    }

    // Draw data polygon
    final dataPath = Path();
    final vertexPoints = <Offset>[];
    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      final r = radius * values[i].clamp(0.12, 1.0);
      final pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      vertexPoints.add(pt);
      if (i == 0) {
        dataPath.moveTo(pt.dx, pt.dy);
      } else {
        dataPath.lineTo(pt.dx, pt.dy);
      }
    }
    dataPath.close();

    final fillPaint = Paint()
      ..color = AppColors.accentAmber.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = AppColors.accentAmber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    // Draw vertex dots and labels
    for (int i = 0; i < count; i++) {
      canvas.drawCircle(
        vertexPoints[i],
        4.5,
        Paint()..color = colors[i],
      );

      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      final labelDist = radius + 28;
      final labelCenter = Offset(
        center.dx + labelDist * math.cos(angle),
        center.dy + labelDist * math.sin(angle),
      );
      final scoreVal = (values[i] * 100).round();
      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${labels[i]}\n',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: '$scoreVal',
              style: TextStyle(
                color: colors[i],
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(labelCenter.dx - tp.width / 2, labelCenter.dy - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}
