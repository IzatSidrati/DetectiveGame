import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import 'optional_asset_image.dart';

enum DetectiveMood { smug, excited, oops }

/// Illustrated Detective Juno mascot badge with expressive moods.
class DetectiveAvatar extends StatelessWidget {
  final DetectiveMood mood;
  final double size;

  const DetectiveAvatar({
    super.key,
    this.mood = DetectiveMood.smug,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DetectiveAvatarPainter(mood: mood),
      ),
    );
  }
}

class _DetectiveAvatarPainter extends CustomPainter {
  final DetectiveMood mood;
  _DetectiveAvatarPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Background circle
    final bgColor = mood == DetectiveMood.excited
        ? AppColors.success.withOpacity(0.18)
        : mood == DetectiveMood.oops
            ? AppColors.accentCrimson.withOpacity(0.18)
            : AppColors.accentAmber.withOpacity(0.16);

    canvas.drawCircle(
      Offset(cx, h / 2),
      w * 0.48,
      Paint()..color = bgColor,
    );
    canvas.drawCircle(
      Offset(cx, h / 2),
      w * 0.48,
      Paint()
        ..color = (mood == DetectiveMood.excited
                ? AppColors.success
                : mood == DetectiveMood.oops
                    ? AppColors.accentCrimson
                    : AppColors.accentAmber)
            .withOpacity(0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Coat collar
    final coatPaint = Paint()..color = const Color(0xFF334155);
    final coatPath = Path()
      ..moveTo(w * 0.22, h * 0.88)
      ..quadraticBezierTo(cx, h * 0.68, w * 0.78, h * 0.88)
      ..close();
    canvas.drawPath(coatPath, coatPaint);

    // Face
    canvas.drawCircle(
      Offset(cx, h * 0.56),
      w * 0.22,
      Paint()..color = const Color(0xFFF3C89B),
    );

    // Glasses
    final glassStroke = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.032;
    canvas.drawCircle(Offset(cx - w * 0.085, h * 0.55), w * 0.065, glassStroke);
    canvas.drawCircle(Offset(cx + w * 0.085, h * 0.55), w * 0.065, glassStroke);
    canvas.drawLine(
      Offset(cx - w * 0.02, h * 0.55),
      Offset(cx + w * 0.02, h * 0.55),
      glassStroke,
    );

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF0F172A);
    if (mood == DetectiveMood.oops) {
      // Spiral/X eyes
      final xPaint = Paint()
        ..color = const Color(0xFF0F172A)
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round;
      for (final ex in [cx - w * 0.085, cx + w * 0.085]) {
        canvas.drawLine(Offset(ex - 2.5, h * 0.55 - 2.5),
            Offset(ex + 2.5, h * 0.55 + 2.5), xPaint);
        canvas.drawLine(Offset(ex + 2.5, h * 0.55 - 2.5),
            Offset(ex - 2.5, h * 0.55 + 2.5), xPaint);
      }
    } else {
      canvas.drawCircle(Offset(cx - w * 0.085, h * 0.55), w * 0.024, eyePaint);
      canvas.drawCircle(Offset(cx + w * 0.085, h * 0.55), w * 0.024, eyePaint);
    }

    // Mouth based on mood
    final mouthPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.028
      ..strokeCap = StrokeCap.round;

    if (mood == DetectiveMood.excited) {
      final smile = Path()
        ..moveTo(cx - w * 0.08, h * 0.65)
        ..quadraticBezierTo(cx, h * 0.74, cx + w * 0.08, h * 0.65);
      canvas.drawPath(smile, mouthPaint);
    } else if (mood == DetectiveMood.oops) {
      canvas.drawCircle(Offset(cx, h * 0.68), w * 0.036, mouthPaint);
    } else {
      // Playful smirk
      final smirk = Path()
        ..moveTo(cx - w * 0.06, h * 0.67)
        ..quadraticBezierTo(cx + w * 0.02, h * 0.69, cx + w * 0.08, h * 0.64);
      canvas.drawPath(smirk, mouthPaint);
    }

    // Fedora hat brim & crown
    final hatPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, h * 0.37), width: w * 0.62, height: h * 0.09),
        const Radius.circular(8),
      ),
      hatPaint,
    );
    final crown = Path()
      ..moveTo(cx - w * 0.21, h * 0.36)
      ..lineTo(cx - w * 0.15, h * 0.19)
      ..quadraticBezierTo(cx, h * 0.23, cx + w * 0.15, h * 0.19)
      ..lineTo(cx + w * 0.21, h * 0.36)
      ..close();
    canvas.drawPath(crown, hatPaint);

    // Amber hat ribbon
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(cx, h * 0.33), width: w * 0.38, height: h * 0.045),
      Paint()..color = AppColors.accentAmber,
    );
  }

  @override
  bool shouldRepaint(covariant _DetectiveAvatarPainter oldDelegate) =>
      oldDelegate.mood != mood;
}

/// Rich stylized illustrated banners for each Detective Case & Home Hero.
class CaseSceneArtwork extends StatelessWidget {
  final String caseId;
  final double height;
  final BorderRadius borderRadius;

  const CaseSceneArtwork({
    super.key,
    required this.caseId,
    this.height = 148,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: OptionalAssetImage(
          basePath: 'assets/images/${caseId}_cover',
          fallback: CustomPaint(
            painter: _SceneArtworkPainter(caseId: caseId),
          ),
        ),
      ),
    );
  }
}

class _SceneArtworkPainter extends CustomPainter {
  final String caseId;
  _SceneArtworkPainter({required this.caseId});

  @override
  void paint(Canvas canvas, Size size) {
    switch (caseId) {
      case 'case_01':
        _paintArchiveScene(canvas, size);
        break;
      case 'case_02':
        _paintNightTrainScene(canvas, size);
        break;
      case 'case_03':
        _paintGalleryScene(canvas, size);
        break;
      default:
        _paintArchiveScene(canvas, size);
    }
  }

  void _paintArchiveScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Midnight gradient wall
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF101827), Color(0xFF1B2436), Color(0xFF0E131D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Warm desk lamp cone
    final cone = Path()
      ..moveTo(w * 0.50, 0)
      ..lineTo(w * 0.18, h)
      ..lineTo(w * 0.82, h)
      ..close();
    canvas.drawPath(
      cone,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.accentAmber.withOpacity(0.26),
            AppColors.accentAmber.withOpacity(0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Tall filing cabinets left & right
    final cabPaint = Paint()..color = const Color(0xFF202B3D);
    final drawerStroke = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (final x in [w * 0.06, w * 0.78]) {
      final rect = Rect.fromLTWH(x, h * 0.14, w * 0.16, h * 0.82);
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)), cabPaint);
      for (int d = 0; d < 3; d++) {
        final dr =
            Rect.fromLTWH(x + 6, h * (0.20 + d * 0.24), w * 0.16 - 12, h * 0.18);
        canvas.drawRRect(
            RRect.fromRectAndRadius(dr, const Radius.circular(3)), drawerStroke);
        canvas.drawLine(
          Offset(dr.center.dx - 8, dr.center.dy),
          Offset(dr.center.dx + 8, dr.center.dy),
          Paint()
            ..color = AppColors.accentAmber.withOpacity(0.7)
            ..strokeWidth = 2,
        );
      }
    }

    // Glowing teal keycard scanner on right wall
    final scannerRect =
        RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.66, h * 0.32, 24, 34), const Radius.circular(5));
    canvas.drawRRect(scannerRect, Paint()..color = const Color(0xFF0F172A));
    canvas.drawRRect(
      scannerRect,
      Paint()
        ..color = AppColors.accentTeal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawCircle(
      Offset(w * 0.66 + 12, h * 0.32 + 12),
      4.5,
      Paint()..color = AppColors.accentTeal,
    );

    // Floor line
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.78, w, h * 0.22),
      Paint()..color = const Color(0xFF0B1018),
    );

    // Fallen crooked wall clock showing 02:15!
    canvas.save();
    canvas.translate(w * 0.44, h * 0.64);
    canvas.rotate(-0.22);
    canvas.drawCircle(Offset.zero, 30, Paint()..color = const Color(0xFFCBD5E1));
    canvas.drawCircle(
      Offset.zero,
      30,
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    // Crack line on glass
    canvas.drawLine(
      const Offset(-12, -18),
      const Offset(8, 12),
      Paint()
        ..color = const Color(0xFF64748B)
        ..strokeWidth = 1.2,
    );
    // Hands at 02:15
    final handPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, const Offset(13, -8), handPaint); // hour ~2
    canvas.drawLine(Offset.zero, const Offset(20, 0), handPaint); // minute 15
    canvas.drawCircle(Offset.zero, 3, Paint()..color = AppColors.accentCrimson);
    canvas.restore();

    // Comical fancy espresso cup + spilled coffee puddle + steam
    final coffeeX = w * 0.60;
    final coffeeY = h * 0.80;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(coffeeX + 18, coffeeY + 8), width: 46, height: 12),
      Paint()..color = const Color(0xFF5C3A21).withOpacity(0.85),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(coffeeX, coffeeY), width: 22, height: 22),
          const Radius.circular(5)),
      Paint()..color = const Color(0xFFF8FAFC),
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(coffeeX - 11, coffeeY), width: 10, height: 12),
      math.pi / 2,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFFF8FAFC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    // Steam wisps
    final steamPaint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 2; i++) {
      final sx = coffeeX - 4 + i * 8;
      final p = Path()
        ..moveTo(sx, coffeeY - 15)
        ..quadraticBezierTo(sx - 5, coffeeY - 24, sx + 2, coffeeY - 32);
      canvas.drawPath(p, steamPaint);
    }
  }

  void _paintNightTrainScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Deep tunnel interior
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF0C1322), Color(0xFF1A253A), Color(0xFF0A0F1A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Train windows with passing stars / speed streaks
    for (int i = 0; i < 3; i++) {
      final wx = w * (0.08 + i * 0.31);
      final winRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(wx, h * 0.14, w * 0.23, h * 0.36),
        const Radius.circular(10),
      );
      canvas.drawRRect(winRect, Paint()..color = const Color(0xFF070B14));
      canvas.drawRRect(
        winRect,
        Paint()
          ..color = AppColors.accentAmber.withOpacity(0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      // Motion streaks outside window
      final streakPaint = Paint()
        ..color = AppColors.accentSky.withOpacity(0.35)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(wx + 12, h * 0.24), Offset(wx + 42, h * 0.24), streakPaint);
      canvas.drawLine(Offset(wx + 24, h * 0.36), Offset(wx + 60, h * 0.36), streakPaint);
    }

    // Train aisle floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.72, w, h * 0.28),
      Paint()..color = const Color(0xFF131B29),
    );

    // Warm overhead spotlight
    final spot = Path()
      ..moveTo(w * 0.45, 0)
      ..lineTo(w * 0.22, h)
      ..lineTo(w * 0.68, h)
      ..close();
    canvas.drawPath(
      spot,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.accentAmber.withOpacity(0.28),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Comically bulging briefcase with railway manuals sticking out!
    final bx = w * 0.38;
    final by = h * 0.56;
    // Papers/books sticking out the top
    canvas.save();
    canvas.translate(bx + 18, by - 2);
    canvas.rotate(-0.18);
    canvas.drawRect(const Rect.fromLTWH(0, -14, 18, 20),
        Paint()..color = const Color(0xFFE2E8F0));
    canvas.restore();
    canvas.save();
    canvas.translate(bx + 36, by - 4);
    canvas.rotate(0.2);
    canvas.drawRect(const Rect.fromLTWH(0, -16, 16, 22),
        Paint()..color = AppColors.accentTeal);
    canvas.restore();

    // Briefcase body
    final caseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bx, by, 72, 46),
      const Radius.circular(8),
    );
    canvas.drawRRect(caseRect, Paint()..color = const Color(0xFF6B4226));
    canvas.drawRRect(
      caseRect,
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Brass clasps
    canvas.drawRect(Rect.fromLTWH(bx + 16, by + 18, 8, 8),
        Paint()..color = AppColors.accentAmber);
    canvas.drawRect(Rect.fromLTWH(bx + 48, by + 18, 8, 8),
        Paint()..color = AppColors.accentAmber);

    // Sneaky detective/culprit hat silhouette on right
    final sx = w * 0.76;
    final sy = h * 0.58;
    final silPaint = Paint()..color = const Color(0xFF090D16);
    canvas.drawCircle(Offset(sx, sy), 14, silPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(sx, sy - 12), width: 38, height: 6),
          const Radius.circular(4)),
      silPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(sx, sy + 28), width: 34, height: 34),
          const Radius.circular(12)),
      silPaint,
    );
    // Glowing sneaky eyes
    canvas.drawCircle(Offset(sx - 5, sy - 1), 2.2, Paint()..color = AppColors.accentAmber);
    canvas.drawCircle(Offset(sx + 4, sy - 1), 2.2, Paint()..color = AppColors.accentAmber);
  }

  void _paintGalleryScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Gallery wall
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF1A1424), Color(0xFF121826), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Golden spotlight onto portrait
    final spot = Path()
      ..moveTo(w * 0.50, 0)
      ..lineTo(w * 0.28, h)
      ..lineTo(w * 0.72, h)
      ..close();
    canvas.drawPath(
      spot,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.accentAmber.withOpacity(0.28),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Ornate Gold Painting Frame (slightly crooked!)
    canvas.save();
    canvas.translate(w * 0.50, h * 0.44);
    canvas.rotate(0.05);
    final frameRect = Rect.fromCenter(center: Offset.zero, width: 78, height: 92);
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFF283447),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(6)),
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // Pompous nobleman inside portrait
    canvas.drawCircle(const Offset(0, -6), 17, Paint()..color = const Color(0xFFF3C89B));
    // Fancy powdered hair
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(0, -14), width: 38, height: 24),
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xFFE2E8F0),
    );
    // Eyes + monocle
    canvas.drawCircle(const Offset(-6, -8), 2.3, Paint()..color = Colors.black);
    canvas.drawCircle(const Offset(6, -8), 2.3, Paint()..color = Colors.black);
    canvas.drawCircle(
      const Offset(6, -8),
      6,
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    // HILARIOUSLY CROOKED MUSTACHE!
    final stache = Path()
      ..moveTo(-14, 4)
      ..quadraticBezierTo(-4, -3, 0, 2)
      ..quadraticBezierTo(6, -7, 16, -2);
    canvas.drawPath(
      stache,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    // Red velvet barrier rope at bottom
    final ropePaint = Paint()
      ..color = AppColors.accentCrimson
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final rope = Path()
      ..moveTo(w * 0.14, h * 0.84)
      ..quadraticBezierTo(w * 0.50, h * 0.96, w * 0.86, h * 0.84);
    canvas.drawPath(rope, ropePaint);
    for (final px in [w * 0.14, w * 0.86]) {
      canvas.drawLine(
        Offset(px, h * 0.74),
        Offset(px, h),
        Paint()
          ..color = AppColors.accentAmber
          ..strokeWidth = 4,
      );
      canvas.drawCircle(Offset(px, h * 0.74), 5, Paint()..color = AppColors.accentAmber);
    }

    // CCTV Camera pointed hilariously UP at the ceiling!
    canvas.save();
    canvas.translate(w * 0.18, h * 0.24);
    canvas.rotate(-0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-12, -7, 26, 14), const Radius.circular(3)),
      Paint()..color = const Color(0xFF94A3B8),
    );
    canvas.drawCircle(const Offset(12, 0), 3, Paint()..color = AppColors.accentCrimson);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SceneArtworkPainter oldDelegate) =>
      oldDelegate.caseId != caseId;
}

/// Compact story-contextual illustrated banner shown inside every mini-game!
class MiniGameStoryBanner extends StatelessWidget {
  final String? caseId;
  final BrainSkill skill;
  final String caption;

  const MiniGameStoryBanner({
    super.key,
    required this.caseId,
    required this.skill,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.forSkill(skill);

    return Container(
      height: 78,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.45), width: 1.2),
      ),
      child: Row(
        children: [
          // Left illustrated scene thumbnail (Case artwork or Detective Lab)
          SizedBox(
            width: 112,
            height: 78,
            child: caseId != null
                ? CaseSceneArtwork(
                    caseId: caseId!,
                    height: 78,
                    borderRadius: BorderRadius.zero,
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF151C28),
                          accent.withOpacity(0.24),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: DetectiveAvatar(
                        mood: DetectiveMood.smug,
                        size: 54,
                      ),
                    ),
                  ),
          ),
          // Right concise story mission text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(AppColors.iconForSkill(skill),
                          size: 13, color: accent),
                      const SizedBox(width: 5),
                      Text(
                        caseId != null ? 'TKP • LIVE' : 'LAB DETEKTIF',
                        style: TextStyle(
                          color: accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
