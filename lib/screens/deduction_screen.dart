import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scene_illustrations.dart';
import '../widgets/solved_illustrations.dart';

class DeductionScreen extends StatefulWidget {
  final AppStateController controller;
  final DetectiveCase detectiveCase;

  const DeductionScreen({
    super.key,
    required this.controller,
    required this.detectiveCase,
  });

  @override
  State<DeductionScreen> createState() => _DeductionScreenState();
}

class _DeductionScreenState extends State<DeductionScreen> {
  String? _selectedSuspectId;
  bool _solved = false;

  Future<void> _confirmAccusation() async {
    if (_selectedSuspectId == null) return;
    final s = AppStrings(widget.controller.language);
    final suspect = widget.detectiveCase.suspects
        .firstWhere((e) => e.id == _selectedSuspectId);

    if (suspect.isCulprit) {
      HapticFeedback.mediumImpact();
      SoundService.instance.playCaseSolved();
      await widget.controller.markCaseSolved(widget.detectiveCase.id);
      if (!mounted) return;
      setState(() => _solved = true);
    } else {
      HapticFeedback.heavyImpact();
      SoundService.instance.playWrong();
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              const DetectiveAvatar(mood: DetectiveMood.oops, size: 42),
              const SizedBox(width: 12),
              Expanded(child: Text(s.wrongSuspectTitle)),
            ],
          ),
          content: Text(
            s.wrongSuspectDesc,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () {
                SoundService.instance.playTap();
                Navigator.of(ctx).pop();
              },
              child: Text(s.tryAgain),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(widget.controller.language);
    final c = widget.detectiveCase;

    if (_solved) {
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: Text(c.code)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const DetectiveAvatar(
                              mood: DetectiveMood.excited,
                              size: 46,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.caseClosedTitle,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.success,
                                  ),
                                ),
                                Text(
                                  c.title.of(s.lang),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Unexpected Funny Plot-Twist Comic Panel!
                        Stack(
                          children: [
                            CaseSolvedTwistArtwork(
                              caseId: c.id,
                              height: 205,
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCrimson,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'PLOT TWIST!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          c.twistTitle.of(s.lang),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentAmber,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          c.twistCaption.of(s.lang),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.5,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: AppColors.success.withOpacity(0.5)),
                          ),
                          child: Text(
                            c.resolution.of(s.lang),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.5,
                              height: 1.55,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      SoundService.instance.playTap();
                      Navigator.of(context).pop(true);
                    },
                    child: Text(s.finishCase),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.finalDeduction)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              c.deductionPrompt.of(s.lang),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.collectedClues.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.accentAmber,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...c.stages.map(
                    (st) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(color: AppColors.accentAmber)),
                          Expanded(
                            child: Text(
                              '${st.evidenceTitle.of(s.lang)}: ${st.evidenceDetail.of(s.lang)}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              s.suspectsTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...c.suspects.map((sus) {
              final selected = _selectedSuspectId == sus.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    SoundService.instance.playTap();
                    setState(() => _selectedSuspectId = sus.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.accentAmber.withOpacity(0.12)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? AppColors.accentAmber : AppColors.border,
                        width: selected ? 1.8 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.accentAmber.withOpacity(0.25)
                                : AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accentAmber
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            sus.avatarEmoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sus.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sus.role.of(s.lang),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentTeal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                sus.alibi.of(s.lang),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '💬 ${sus.funnyNote.of(s.lang)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.accentAmber,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _selectedSuspectId == null ? null : _confirmAccusation,
              icon: const Icon(Icons.gavel_rounded),
              label: Text(s.confirmAccusation),
            ),
          ],
        ),
      ),
    );
  }
}
