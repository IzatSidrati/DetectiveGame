import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../models/game_models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';

enum _RitualItem { kendi, melati, kemenyan }

enum _RitualSlot { north, center, south }

/// Bukti 3: "Susun Arah Sesajen" (Logic Placement)
/// 3 item mistis (Kendi Tanah Liat, Bunga Melati, Kemenyan) + 3 slot posisi
/// (Utara, Tengah, Selatan) beserta petunjuk singkat juru kunci.
/// Mendukung Drag-and-Drop maupun Tap-to-Place untuk membuka segel Ruang 304.
class RitualOfferingGameScreen extends StatefulWidget {
  final AppStrings strings;
  final int difficulty;
  final String? headerTitle;

  const RitualOfferingGameScreen({
    super.key,
    required this.strings,
    required this.difficulty,
    this.headerTitle,
  });

  @override
  State<RitualOfferingGameScreen> createState() =>
      _RitualOfferingGameScreenState();
}

class _RitualOfferingGameScreenState extends State<RitualOfferingGameScreen> {
  // Correct mystical seal arrangement:
  // Utara = Kendi Tanah Liat, Tengah = Kemenyan, Selatan = Bunga Melati
  static const Map<_RitualSlot, _RitualItem> _solution = {
    _RitualSlot.north: _RitualItem.kendi,
    _RitualSlot.center: _RitualItem.kemenyan,
    _RitualSlot.south: _RitualItem.melati,
  };

  final Map<_RitualSlot, _RitualItem?> _placed = {
    _RitualSlot.north: null,
    _RitualSlot.center: null,
    _RitualSlot.south: null,
  };

  _RitualItem? _selectedItem;
  String? _feedbackMsg;
  bool _isError = false;
  bool _solved = false;
  int _attempts = 0;

  String _itemName(_RitualItem item, AppStrings s) {
    switch (item) {
      case _RitualItem.kendi:
        return s.t('Kendi Tanah Liat', 'Clay Water Jug');
      case _RitualItem.melati:
        return s.t('Bunga Melati', 'Jasmine Petals');
      case _RitualItem.kemenyan:
        return s.t('Kemenyan', 'Incense Burner');
    }
  }

  String _itemEmoji(_RitualItem item) {
    switch (item) {
      case _RitualItem.kendi:
        return '🏺';
      case _RitualItem.melati:
        return '🤍';
      case _RitualItem.kemenyan:
        return '🕯️';
    }
  }

  String _slotName(_RitualSlot slot, AppStrings s) {
    switch (slot) {
      case _RitualSlot.north:
        return s.t('UTARA', 'NORTH');
      case _RitualSlot.center:
        return s.t('TENGAH', 'CENTER');
      case _RitualSlot.south:
        return s.t('SELATAN', 'SOUTH');
    }
  }

  void _placeItem(_RitualSlot targetSlot, _RitualItem item) {
    if (_solved) return;
    HapticFeedback.selectionClick();
    SoundService.instance.playTap();
    setState(() {
      // Remove item from any other slot first
      for (final slot in _RitualSlot.values) {
        if (_placed[slot] == item) {
          _placed[slot] = null;
        }
      }
      _placed[targetSlot] = item;
      _selectedItem = null;
      _feedbackMsg = null;
      _isError = false;
    });
  }

  void _onSlotTap(_RitualSlot slot) {
    if (_solved) return;
    if (_selectedItem != null) {
      _placeItem(slot, _selectedItem!);
    } else if (_placed[slot] != null) {
      HapticFeedback.selectionClick();
      SoundService.instance.playTap();
      setState(() {
        _placed[slot] = null;
        _feedbackMsg = null;
      });
    }
  }

  Future<void> _verifySeal() async {
    if (_solved) return;
    final s = widget.strings;
    _attempts++;

    bool allCorrect = true;
    for (final slot in _RitualSlot.values) {
      if (_placed[slot] != _solution[slot]) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      HapticFeedback.heavyImpact();
      SoundService.instance.playUnlock();
      setState(() {
        _solved = true;
        _isError = false;
        _feedbackMsg = s.sealOpenMsg;
      });
      await Future.delayed(const Duration(milliseconds: 950));
      if (!mounted) return;
      final score = (100 - ((_attempts - 1) * 15)).clamp(65, 100);
      Navigator.of(context).pop(
        MiniGameResult(
          skill: BrainSkill.logic,
          passed: true,
          score: score,
          correctCount: 3,
          totalCount: 3,
        ),
      );
    } else {
      HapticFeedback.heavyImpact();
      SoundService.instance.playWrong();
      setState(() {
        _isError = true;
        _feedbackMsg = s.sealWrongMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final accent = AppColors.forSkill(BrainSkill.logic);
    final allPlaced = _placed.values.every((e) => e != null);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headerTitle ?? s.skillGameTitle(BrainSkill.logic)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Caretaker's mystical clue note + 3 Directional Altar Slots (scrollable for small screens)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.accentAmber.withOpacity(0.45),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.menu_book_rounded,
                                    color: AppColors.accentAmber, size: 17),
                                const SizedBox(width: 8),
                                Text(
                                  s.t('CATATAN JURU KUNCI (SEGEL 304)',
                                      'CARETAKER\'S SEAL NOTES (304)'),
                                  style: const TextStyle(
                                    color: AppColors.accentAmber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.t(
                                '• Kemenyan harus menyala tepat di TENGAH untuk menahan hawa dingin.\n• Kendi Tanah Liat tidak boleh ditaruh di Selatan — hadapkan ke UTARA.\n• Bunga Melati menenangkan pintu dari sisi SELATAN.',
                                '• The Incense Burner must sit dead CENTER to hold back the cold.\n• Never place the Clay Jug South — face it strictly NORTH.\n• Jasmine Petals calm the door from the SOUTH plate.',
                              ),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12.5,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      ..._RitualSlot.values.map((slot) {
                        final currentItem = _placed[slot];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DragTarget<_RitualItem>(
                            onAcceptWithDetails: (details) =>
                                _placeItem(slot, details.data),
                            builder: (context, candidateData, rejectedData) {
                              final hovering = candidateData.isNotEmpty;
                              final borderColor = _solved
                                  ? AppColors.success
                                  : _isError
                                      ? AppColors.accentCrimson
                                      : hovering
                                          ? AppColors.accentAmber
                                          : currentItem != null
                                              ? accent
                                              : AppColors.border;

                              return InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _onSlotTap(slot),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: hovering
                                        ? AppColors.accentAmber
                                            .withOpacity(0.14)
                                        : _solved
                                            ? AppColors.success
                                                .withOpacity(0.14)
                                            : AppColors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: borderColor, width: 1.7),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 78,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.border),
                                        ),
                                        child: Text(
                                          _slotName(slot, s),
                                          style: TextStyle(
                                            color: accent,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: currentItem != null
                                            ? Row(
                                                children: [
                                                  Text(
                                                    _itemEmoji(currentItem),
                                                    style: const TextStyle(
                                                        fontSize: 22),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      _itemName(currentItem, s),
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .textPrimary,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 14.5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                s.t(
                                                    'Ketuk atau tarik sesajen ke sini',
                                                    'Tap or drag offering here'),
                                                style: const TextStyle(
                                                  color: AppColors.textMuted,
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                      ),
                                      if (currentItem != null && !_solved)
                                        const Icon(Icons.close_rounded,
                                            size: 18,
                                            color: AppColors.textMuted),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              if (_feedbackMsg != null) ...[
                const SizedBox(height: 8),
                Text(
                  _feedbackMsg!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isError ? AppColors.accentCrimson : AppColors.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Tray of 3 Mystical Offering Items (Draggable + Tappable)
              Row(
                children: _RitualItem.values.map((item) {
                  final isUsed = _placed.values.contains(item);
                  final isSelected = _selectedItem == item;

                  final card = Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentAmber.withOpacity(0.18)
                          : isUsed
                              ? AppColors.surface.withOpacity(0.45)
                              : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentAmber
                            : isUsed
                                ? AppColors.border.withOpacity(0.4)
                                : accent.withOpacity(0.6),
                        width: isSelected ? 2 : 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _itemEmoji(item),
                          style: TextStyle(
                            fontSize: 26,
                            color: isUsed
                                ? Colors.white.withOpacity(0.35)
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _itemName(item, s),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isUsed
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Draggable<_RitualItem>(
                        data: item,
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(width: 110, child: card),
                        ),
                        childWhenDragging: Opacity(opacity: 0.35, child: card),
                        child: GestureDetector(
                          onTap: () {
                            if (_solved) return;
                            HapticFeedback.selectionClick();
                            SoundService.instance.playTap();
                            setState(() {
                              _selectedItem =
                                  _selectedItem == item ? null : item;
                            });
                          },
                          child: card,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: allPlaced && !_solved ? _verifySeal : null,
                  icon: const Icon(Icons.lock_open_rounded),
                  label: Text(s.verifySealBtn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
