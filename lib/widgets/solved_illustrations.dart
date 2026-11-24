import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import 'optional_asset_image.dart';

/// Hilarious, unexpected comic-panel plot twist artwork shown when a Case is solved!
/// Automatically displays `assets/images/<caseId>_twist.png` if present,
/// otherwise falls back to custom-painted comic artwork.
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
            color: AppColors.accentAmber.withOpacity(0.65),
            width: 1.8,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: OptionalAssetImage(
            basePath: 'assets/images/${caseId}_twist',
            fallback: CustomPaint(
              painter: _CaseTwistPainter(caseId: caseId),
            ),
          ),
        ),
      ),
    );
  }
}

/// Funny, story-specific comic panel shown right after solving a stage mini-game.
/// Automatically displays `assets/images/<stageId>_evidence.png` if present,
/// otherwise renders a tailored comic scene depicting that exact evidence!
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
      painter: _StageComicPainter(skill: skill, stageId: stageId),
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

class _CaseTwistPainter extends CustomPainter {
  final String caseId;
  _CaseTwistPainter({required this.caseId});

  @override
  void paint(Canvas canvas, Size size) {
    switch (caseId) {
      case 'case_01':
        _paintCase1CatTwist(canvas, size);
        break;
      case 'case_02':
        _paintCase2RendangTwist(canvas, size);
        break;
      case 'case_03':
        _paintCase3AuctionTwist(canvas, size);
        break;
      default:
        _paintCase1CatTwist(canvas, size);
    }
  }

  void _paintCase1CatTwist(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF141B2D), Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final beam = Path()
      ..moveTo(w * 0.12, 0)
      ..lineTo(w * 0.25, h)
      ..lineTo(w * 0.78, h)
      ..lineTo(w * 0.42, 0)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.accentAmber.withOpacity(0.32),
            AppColors.accentAmber.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.75, w, h * 0.25),
      Paint()..color = const Color(0xFF0B1120),
    );

    final ledgerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.48, h * 0.74), width: 130, height: 34),
      const Radius.circular(6),
    );
    canvas.drawRRect(ledgerRect, Paint()..color = const Color(0xFF334155));
    canvas.drawRRect(
      ledgerRect,
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawLabel(
      canvas,
      'BUKU ARISAN',
      Offset(w * 0.48, h * 0.74),
      color: AppColors.accentAmber,
      fontSize: 10,
      bold: true,
    );

    final cx = w * 0.48;
    final cy = h * 0.54;
    final catOrange = Paint()..color = const Color(0xFFFB923C);
    final catStripe = Paint()
      ..color = const Color(0xFFC2410C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 6), width: 96, height: 52),
      catOrange,
    );
    canvas.drawLine(Offset(cx - 12, cy - 16), Offset(cx - 10, cy - 4), catStripe);
    canvas.drawLine(Offset(cx, cy - 18), Offset(cx, cy - 5), catStripe);
    canvas.drawLine(Offset(cx + 12, cy - 16), Offset(cx + 10, cy - 4), catStripe);

    final tail = Path()
      ..moveTo(cx + 44, cy + 12)
      ..quadraticBezierTo(cx + 68, cy - 2, cx + 56, cy - 16);
    canvas.drawPath(
      tail,
      Paint()
        ..color = const Color(0xFFFB923C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );

    final hx = cx - 32;
    final hy = cy - 4;
    canvas.drawCircle(Offset(hx, hy), 22, catOrange);
    final leftEar = Path()
      ..moveTo(hx - 17, hy - 10)
      ..lineTo(hx - 20, hy - 30)
      ..lineTo(hx - 4, hy - 19)
      ..close();
    final rightEar = Path()
      ..moveTo(hx + 17, hy - 10)
      ..lineTo(hx + 18, hy - 30)
      ..lineTo(hx + 4, hy - 19)
      ..close();
    canvas.drawPath(leftEar, catOrange);
    canvas.drawPath(rightEar, catOrange);

    final eyePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(hx - 7, hy - 2), width: 8, height: 6),
      0,
      math.pi,
      false,
      eyePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(hx + 7, hy - 2), width: 8, height: 6),
      0,
      math.pi,
      false,
      eyePaint,
    );
    canvas.drawCircle(Offset(hx - 13, hy + 4), 3.5,
        Paint()..color = const Color(0xFFF43F5E).withOpacity(0.45));
    canvas.drawCircle(Offset(hx + 13, hy + 4), 3.5,
        Paint()..color = const Color(0xFFF43F5E).withOpacity(0.45));

    final tie = Path()
      ..moveTo(hx, hy + 19)
      ..lineTo(hx - 5, hy + 30)
      ..lineTo(hx, hy + 37)
      ..lineTo(hx + 5, hy + 30)
      ..close();
    canvas.drawPath(tie, Paint()..color = AppColors.accentCrimson);

    _drawLabel(canvas, 'Zzz...', Offset(hx - 26, hy - 34),
        color: AppColors.accentSky, fontSize: 13, bold: true);

    for (int i = 0; i < 3; i++) {
      final cupY = h * 0.72 - i * 19;
      final cupX = w * 0.80 + (i.isEven ? -2 : 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cupX, cupY), width: 22, height: 17),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFF8FAFC),
      );
      canvas.drawRect(
        Rect.fromCenter(center: Offset(cupX, cupY), width: 22, height: 5),
        Paint()..color = const Color(0xFF92400E),
      );
    }

    _drawSpeechBubble(canvas, Offset(w * 0.79, h * 0.22), '3x ESPRESSO!',
        bg: AppColors.accentAmber, fg: const Color(0xFF111418));
  }

  void _paintCase2RendangTwist(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1E293B), Color(0xFF0B1120)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final center = Offset(w * 0.46, h * 0.54);
    for (int i = 0; i < 12; i++) {
      final angle = (math.pi * 2 / 12) * i;
      final p = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + math.cos(angle) * 140,
            center.dy + math.sin(angle) * 140)
        ..lineTo(center.dx + math.cos(angle + 0.16) * 140,
            center.dy + math.sin(angle + 0.16) * 140)
        ..close();
      canvas.drawPath(
        p,
        Paint()..color = AppColors.accentAmber.withOpacity(0.11),
      );
    }

    final lid = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.46, h * 0.34), width: 126, height: 48),
      const Radius.circular(8),
    );
    canvas.drawRRect(lid, Paint()..color = const Color(0xFF334155));
    canvas.drawRRect(
      lid,
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawLabel(canvas, 'TOP SECRET', Offset(w * 0.46, h * 0.28),
        color: AppColors.accentCrimson, fontSize: 10, bold: true);

    final base = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.46, h * 0.74), width: 132, height: 48),
      const Radius.circular(8),
    );
    canvas.drawRRect(base, Paint()..color = const Color(0xFF1E293B));
    canvas.drawRRect(
      base,
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    final rx = w * 0.46;
    final tierColors = [
      const Color(0xFFCBD5E1),
      const Color(0xFFE2E8F0),
      const Color(0xFF94A3B8),
    ];
    for (int i = 0; i < 3; i++) {
      final ty = h * 0.68 - i * 17;
      final tierRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(rx, ty), width: 52, height: 15),
        const Radius.circular(4),
      );
      canvas.drawRRect(tierRect, Paint()..color = tierColors[i]);
      canvas.drawRRect(
        tierRect,
        Paint()
          ..color = const Color(0xFF475569)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(rx, h * 0.53), width: 60, height: 64),
        const Radius.circular(8),
      ),
      Paint()
        ..color = AppColors.accentTeal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );

    final steamPaint = Paint()
      ..color = Colors.white.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final dx in [-14.0, 0.0, 14.0]) {
      final sp = Path()
        ..moveTo(rx + dx, h * 0.25)
        ..quadraticBezierTo(rx + dx - 6, h * 0.16, rx + dx + 4, h * 0.09);
      canvas.drawPath(sp, steamPaint);
    }

    canvas.save();
    canvas.translate(w * 0.77, h * 0.46);
    canvas.rotate(0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 78, height: 48),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFDE047),
    );
    _drawLabel(canvas, 'RENDANG\nNENEK ❤️', Offset.zero,
        color: const Color(0xFF1E293B), fontSize: 10.5, bold: true);
    canvas.restore();

    _drawSpeechBubble(canvas, Offset(w * 0.16, h * 0.30), 'LOH?! 🤤',
        bg: AppColors.accentTeal, fg: const Color(0xFF0F172A));
  }

  void _paintCase3AuctionTwist(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF1F162B), Color(0xFF171D2E), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final confettiColors = [
      AppColors.accentAmber,
      AppColors.accentTeal,
      AppColors.accentCrimson,
      AppColors.accentSky,
    ];
    for (int i = 0; i < 18; i++) {
      final cx = ((i * 53 + 17) % 94) / 100.0 * w;
      final cy = ((i * 37 + 11) % 72) / 100.0 * h;
      canvas.drawCircle(
        Offset(cx, cy),
        3,
        Paint()..color = confettiColors[i % confettiColors.length].withOpacity(0.7),
      );
    }

    canvas.save();
    canvas.translate(w * 0.50, h * 0.50);
    canvas.rotate(-0.04);
    final frame = Rect.fromCenter(center: Offset.zero, width: 76, height: 92);
    canvas.drawRRect(
      RRect.fromRectAndRadius(frame, const Radius.circular(6)),
      Paint()..color = const Color(0xFF283447),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(frame, const Radius.circular(6)),
      Paint()
        ..color = AppColors.accentAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawCircle(const Offset(0, -8), 16, Paint()..color = const Color(0xFFF3C89B));
    canvas.drawCircle(const Offset(-5, -10), 2.2, Paint()..color = Colors.black);
    canvas.drawCircle(const Offset(5, -10), 2.2, Paint()..color = Colors.black);
    final stache = Path()
      ..moveTo(-16, 4)
      ..quadraticBezierTo(-5, -5, 0, 2)
      ..quadraticBezierTo(8, -10, 18, -1);
    canvas.drawPath(
      stache,
      Paint()
        ..color = const Color(0xFF0F172A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, 30), width: 82, height: 22),
        const Radius.circular(5),
      ),
      Paint()..color = AppColors.accentCrimson,
    );
    _drawLabel(canvas, 'SOLD! 2M', const Offset(0, 30),
        color: Colors.white, fontSize: 11, bold: true);
    canvas.restore();

    final vx = w * 0.19;
    final vy = h * 0.62;
    canvas.drawCircle(Offset(vx, vy), 16, Paint()..color = const Color(0xFFF3C89B));
    canvas.drawRect(
      Rect.fromCenter(center: Offset(vx, vy - 22), width: 22, height: 22),
      Paint()..color = const Color(0xFF0F172A),
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(vx, vy - 12), width: 34, height: 4),
      Paint()..color = AppColors.accentAmber,
    );
    canvas.drawLine(
      Offset(vx + 18, vy + 10),
      Offset(vx + 22, vy - 26),
      Paint()
        ..color = AppColors.accentAmber
        ..strokeWidth = 3.5,
    );
    canvas.drawCircle(
      Offset(vx + 22, vy - 34),
      15,
      Paint()..color = AppColors.accentAmber,
    );
    _drawLabel(canvas, '❤️', Offset(vx + 22, vy - 34), fontSize: 13);

    final fx = w * 0.81;
    final fy = h * 0.62;
    canvas.drawCircle(Offset(fx, fy), 16, Paint()..color = const Color(0xFFF3C89B));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(fx + 2, fy - 15), width: 32, height: 12),
      Paint()..color = AppColors.accentCrimson,
    );
    final cuffPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6;
    canvas.drawCircle(Offset(fx - 9, fy + 28), 7, cuffPaint);
    canvas.drawCircle(Offset(fx + 9, fy + 28), 7, cuffPaint);
    canvas.drawLine(Offset(fx - 2, fy + 28), Offset(fx + 2, fy + 28), cuffPaint);

    _drawSpeechBubble(canvas, Offset(fx, h * 0.24), 'LHO?! 🎨',
        bg: AppColors.accentSky, fg: const Color(0xFF0F172A));
  }

  void _drawSpeechBubble(
    Canvas canvas,
    Offset center,
    String text, {
    required Color bg,
    required Color fg,
  }) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 84, height: 28),
      const Radius.circular(14),
    );
    canvas.drawRRect(rect, Paint()..color = bg);
    _drawLabel(canvas, text, center, color: fg, fontSize: 10.5, bold: true);
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset center, {
    Color color = Colors.white,
    double fontSize = 11,
    bool bold = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _CaseTwistPainter oldDelegate) =>
      oldDelegate.caseId != caseId;
}

class _StageComicPainter extends CustomPainter {
  final BrainSkill skill;
  final String? stageId;
  _StageComicPainter({required this.skill, this.stageId});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final accent = AppColors.forSkill(skill);

    // Rich comic-strip background with halftone-style accent glow
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF141B29), Color(0xFF1D273B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Bespoke comic scenes for Case #01 stages!
    if (stageId == 'c1_s1') {
      _paintC1S1KeycardScene(canvas, size);
      return;
    } else if (stageId == 'c1_s2') {
      _paintC1S2EspressoGuardScene(canvas, size);
      return;
    } else if (stageId == 'c1_s3') {
      _paintC1S3VaultPinScene(canvas, size);
      return;
    } else if (stageId == 'c1_s4') {
      _paintC1S4ParkingGateScene(canvas, size);
      return;
    }

    // General expressive comic vignettes for other stages & Free Training
    switch (skill) {
      case BrainSkill.memory:
        _paintC1S1KeycardScene(canvas, size);
        break;
      case BrainSkill.focus:
        _paintC1S2EspressoGuardScene(canvas, size);
        break;
      case BrainSkill.logic:
        final slots = [w * 0.20, w * 0.40, w * 0.60, w * 0.80];
        for (int i = 0; i < slots.length; i++) {
          final isDuck = i == 2;
          final cx = slots[i];
          final cy = h * 0.58;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(cx, cy), width: 46, height: 52),
              const Radius.circular(10),
            ),
            Paint()
              ..color = isDuck
                  ? AppColors.accentAmber.withOpacity(0.24)
                  : const Color(0xFF0F172A),
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(cx, cy), width: 46, height: 52),
              const Radius.circular(10),
            ),
            Paint()
              ..color = isDuck ? AppColors.accentAmber : AppColors.border
              ..style = PaintingStyle.stroke
              ..strokeWidth = isDuck ? 2.2 : 1.2,
          );
          _drawEmoji(canvas, isDuck ? '🦆' : '🕵️', Offset(cx, cy), 22);
        }
        _drawTag(canvas, 'KETAHUAN! 🦆', Offset(w * 0.60, h * 0.20), accent);
        break;
      case BrainSkill.math:
        _paintC1S4ParkingGateScene(canvas, size);
        break;
    }
  }

  /// c1_s1: Archive door + glowing green scanner + STAFF LT.2 keycard tapping
  /// + brass manual key crossed out with big red X!
  void _paintC1S1KeycardScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Left: Archive metal door & green glowing scanner
    final door = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.10, w * 0.36, h * 0.84),
      const Radius.circular(8),
    );
    canvas.drawRRect(door, Paint()..color = const Color(0xFF233044));
    canvas.drawRRect(
      door,
      Paint()
        ..color = const Color(0xFF475569)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Door handle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.34, h * 0.50, 14, 6),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF94A3B8),
    );

    // Glowing Electronic Keycard Scanner on wall
    final scanX = w * 0.50;
    final scanY = h * 0.48;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(scanX, scanY), width: 34, height: 50),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF0F172A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(scanX, scanY), width: 34, height: 50),
        const Radius.circular(6),
      ),
      Paint()
        ..color = AppColors.success
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    // Green LED & checkmark
    canvas.drawCircle(Offset(scanX, scanY - 12), 6, Paint()..color = AppColors.success);
    _drawEmoji(canvas, '✅', Offset(scanX, scanY + 10), 14);

    // Tilted STAFF LT.2 ID Card tapping the scanner (with funny coffee ring stain!)
    canvas.save();
    canvas.translate(w * 0.58, h * 0.62);
    canvas.rotate(-0.22);
    final card = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 64, height: 40),
      const Radius.circular(6),
    );
    canvas.drawRRect(card, Paint()..color = const Color(0xFFF8FAFC));
    canvas.drawRect(
      const Rect.fromLTWH(-32, -20, 64, 10),
      Paint()..color = AppColors.accentIndigo,
    );
    _drawSmallText(canvas, 'STAF LT.2', const Offset(0, 4), const Color(0xFF0F172A));
    // Coffee ring stain on corner of ID card!
    canvas.drawCircle(
      const Offset(20, 10),
      9,
      Paint()
        ..color = const Color(0xFF92400E).withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.restore();

    // Right side: Brass manual master key inside a crossed-out red circle!
    final kx = w * 0.83;
    final ky = h * 0.52;
    canvas.drawCircle(
      Offset(kx, ky),
      28,
      Paint()..color = AppColors.accentCrimson.withOpacity(0.14),
    );
    _drawEmoji(canvas, '🔑', Offset(kx, ky), 24);
    final crossPaint = Paint()
      ..color = AppColors.accentCrimson
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
      Offset(kx, ky),
      28,
      Paint()
        ..color = AppColors.accentCrimson
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawLine(Offset(kx - 18, ky - 18), Offset(kx + 18, ky + 18), crossPaint);

    _drawTag(canvas, 'BEEP! AKSES LT.2', Offset(w * 0.48, h * 0.16), AppColors.success);
  }

  /// c1_s2: Cartoon ghost crossed out vs sparkling luxury espresso mug!
  void _paintC1S2EspressoGuardScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Left: Silly ghost crossed out
    final gx = w * 0.24;
    final gy = h * 0.56;
    canvas.drawCircle(
      Offset(gx, gy),
      30,
      Paint()..color = AppColors.accentCrimson.withOpacity(0.14),
    );
    _drawEmoji(canvas, '👻', Offset(gx, gy), 28);
    canvas.drawLine(
      Offset(gx - 22, gy - 22),
      Offset(gx + 22, gy + 22),
      Paint()
        ..color = AppColors.accentCrimson
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Arrow from gossip -> real fact
    _drawSmallText(canvas, '➜', Offset(w * 0.46, h * 0.56), AppColors.textMuted, size: 22);

    // Right: Sparkling fancy espresso cup with golden aroma waves
    final cx = w * 0.72;
    final cy = h * 0.58;
    canvas.drawCircle(
      Offset(cx, cy),
      34,
      Paint()..color = AppColors.accentAmber.withOpacity(0.18),
    );
    _drawEmoji(canvas, '☕', Offset(cx, cy + 4), 30);
    _drawTag(canvas, 'AROMA ESPRESSO 02.10!', Offset(w * 0.54, h * 0.18), AppColors.accentAmber);
  }

  /// c1_s3: Vault screen showing 2 failed PINs ("123456 ❌") then green check!
  void _paintC1S3VaultPinScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final box = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.56), width: w * 0.74, height: h * 0.64),
      const Radius.circular(14),
    );
    canvas.drawRRect(box, Paint()..color = const Color(0xFF0F172A));
    canvas.drawRRect(
      box,
      Paint()
        ..color = AppColors.accentTeal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    _drawSmallText(canvas, '#1  123456  ❌   •   #2  000000  ❌',
        Offset(w * 0.50, h * 0.44), AppColors.accentCrimson,
        size: 11.5);
    _drawSmallText(canvas, '#3  PIN BENAR!  🔓✅',
        Offset(w * 0.50, h * 0.66), AppColors.success,
        size: 13.5);
    _drawTag(canvas, 'LOG BRANKAS TERBUKA', Offset(w * 0.50, h * 0.16), AppColors.accentTeal);
  }

  /// c1_s4: Speeding car zooming under B2 parking barrier at 02:21 leaving a ticket!
  void _paintC1S4ParkingGateScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Road floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.74, w, h * 0.26),
      Paint()..color = const Color(0xFF0B1120),
    );
    // Parking gate post + lifted striped arm
    canvas.drawRect(
      Rect.fromLTWH(w * 0.18, h * 0.44, 14, h * 0.30),
      Paint()..color = AppColors.accentAmber,
    );
    canvas.drawLine(
      Offset(w * 0.18 + 7, h * 0.46),
      Offset(w * 0.38, h * 0.22),
      Paint()
        ..color = AppColors.accentCrimson
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    // Speed lines
    for (int i = 0; i < 3; i++) {
      final y = h * (0.50 + i * 0.08);
      canvas.drawLine(
        Offset(w * 0.32, y),
        Offset(w * 0.48, y),
        Paint()
          ..color = AppColors.accentSky.withOpacity(0.75)
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
    }

    // Zooming car body
    final car = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.68, h * 0.62), width: 88, height: 32),
      const Radius.circular(10),
    );
    canvas.drawRRect(car, Paint()..color = AppColors.accentSky);
    canvas.drawCircle(Offset(w * 0.68 - 24, h * 0.62 + 16), 9,
        Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(Offset(w * 0.68 + 24, h * 0.62 + 16), 9,
        Paint()..color = const Color(0xFF0F172A));

    // Fluttering unvalidated parking ticket behind car!
    _drawEmoji(canvas, '🎫', Offset(w * 0.42, h * 0.42), 18);
    _drawTag(canvas, 'B2 EXIT • 02:21 ⏱️', Offset(w * 0.64, h * 0.20), AppColors.accentAmber);
  }

  void _drawEmoji(Canvas canvas, String emoji, Offset center, double size) {
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: size)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  void _drawSmallText(Canvas canvas, String text, Offset center, Color color,
      {double size = 9.5}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  void _drawTag(Canvas canvas, String text, Offset center, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: tp.width + 20,
        height: tp.height + 12,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.16));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _StageComicPainter oldDelegate) =>
      oldDelegate.skill != skill || oldDelegate.stageId != stageId;
}
