import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import 'optional_asset_image.dart';

/// Final Plot-Twist artwork shown when a Case is solved.
/// Automatically loads `assets/images/<caseId>_twist` (.png/.jpg/.jpeg/.webp)
/// if present, otherwise displays a dark atmospheric horror fallback.
class CaseSolvedTwistArtwork extends StatelessWidget {
  final String caseId;
  final double height;

  const CaseSolvedTwistArtwork({
    super.key,
    required this.caseId,
    this.height = 205,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accentCrimson.withOpacity(0.7),
            width: 1.8,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: OptionalAssetImage(
            basePath: 'assets/images/${caseId}_twist',
            fallback: CustomPaint(
              painter: _HorrorTwistFallbackPainter(caseId: caseId),
            ),
          ),
        ),
      ),
    );
  }
}

/// Evidence reveal artwork shown after completing a mini-game stage.
/// Automatically loads `assets/images/<stageId>_evidence` (.png/.jpg/.jpeg/.webp)
/// if present, otherwise displays a dark atmospheric horror fallback.
class StageSolvedComicArtwork extends StatelessWidget {
  final BrainSkill skill;
  final String? stageId;
  final double height;

  const StageSolvedComicArtwork({
    super.key,
    required this.skill,
    this.stageId,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = CustomPaint(
      painter: _HorrorEvidenceFallbackPainter(skill: skill, stageId: stageId),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.forSkill(skill).withOpacity(0.55),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: stageId != null
              ? OptionalAssetImage(
                  basePath: 'assets/images/${stageId}_evidence',
                  fallback: fallback,
                )
              : fallback,
        ),
      ),
    );
  }
}

class _HorrorTwistFallbackPainter extends CustomPainter {
  final String caseId;
  _HorrorTwistFallbackPainter({required this.caseId});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF060B0D), Color(0xFF102024), Color(0xFF09080B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Flashlight beam cone
    final beam = Path()
      ..moveTo(w * 0.14, h)
      ..lineTo(w * 0.44, 0)
      ..lineTo(w * 0.88, 0)
      ..lineTo(w * 0.62, h)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.accentAmber.withOpacity(0.24),
            Colors.transparent,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final badge = caseId == 'case_01'
        ? 'RUANG 304 • 01:45'
        : caseId == 'case_02'
            ? 'PERON 00:00'
            : 'TOPENG #304';
    _drawTag(canvas, badge, Offset(w * 0.50, h * 0.50), AppColors.accentCrimson);
  }

  @override
  bool shouldRepaint(covariant _HorrorTwistFallbackPainter oldDelegate) =>
      oldDelegate.caseId != caseId;
}

class _HorrorEvidenceFallbackPainter extends CustomPainter {
  final BrainSkill skill;
  final String? stageId;
  _HorrorEvidenceFallbackPainter({required this.skill, this.stageId});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF080E11), Color(0xFF122126)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    late String label;
    late Color color;
    switch (skill) {
      case BrainSkill.memory:
        label = 'CERMIN 304 • 01:45';
        color = AppColors.accentTeal;
        break;
      case BrainSkill.focus:
        label = 'DIKTAFON 1998 • 74 Hz';
        color = AppColors.accentAmber;
        break;
      case BrainSkill.logic:
        label = '🏺 UTARA • 🕯️ TENGAH • 🤍 SELATAN';
        color = AppColors.accentTeal;
        break;
      case BrainSkill.math:
        label = 'BRANKAR LEWAT • 6.0s';
        color = AppColors.accentCrimson;
        break;
    }
    _drawTag(canvas, label, Offset(w * 0.50, h * 0.50), color);
  }

  @override
  bool shouldRepaint(covariant _HorrorEvidenceFallbackPainter oldDelegate) =>
      oldDelegate.skill != skill || oldDelegate.stageId != stageId;
}

void _drawTag(Canvas canvas, String text, Offset center, Color color) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  final rect = RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: center,
      width: tp.width + 24,
      height: tp.height + 14,
    ),
    const Radius.circular(12),
  );
  canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.14));
  canvas.drawRRect(
    rect,
    Paint()
      ..color = color.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );
  tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
}
