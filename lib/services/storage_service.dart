import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import '../widgets/optional_asset_image.dart';
import 'sound_service.dart';

class AppStateController extends ChangeNotifier {
  static const _kLang = 'mindcase_lang';
  static const _kSoundEnabled = 'mindcase_sound_enabled';
  static const _kCompletedStages = 'mindcase_completed_stages';
  static const _kSolvedCases = 'mindcase_solved_cases';
  static const _kSkillMemory = 'mindcase_skill_memory';
  static const _kSkillFocus = 'mindcase_skill_focus';
  static const _kSkillLogic = 'mindcase_skill_logic';
  static const _kSkillMath = 'mindcase_skill_math';
  static const _kStreak = 'mindcase_streak';
  static const _kLastPlayed = 'mindcase_last_played';
  static const _kTotalSessions = 'mindcase_total_sessions';
  static const _kPremium = 'mindcase_premium';

  AppLanguage _language = AppLanguage.id;
  bool _soundEnabled = true;
  PlayerProgress _progress = PlayerProgress.initial();
  bool _loaded = false;

  AppLanguage get language => _language;
  bool get soundEnabled => _soundEnabled;
  PlayerProgress get progress => _progress;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    await BundledImageRegistry.load();
    final prefs = await SharedPreferences.getInstance();
    final langStr = prefs.getString(_kLang);
    _language = langStr == 'en' ? AppLanguage.en : AppLanguage.id;
    _soundEnabled = prefs.getBool(_kSoundEnabled) ?? true;
    SoundService.instance.setEnabled(_soundEnabled);

    final completed = (prefs.getStringList(_kCompletedStages) ?? []).toSet();
    final solved = (prefs.getStringList(_kSolvedCases) ?? []).toSet();
    final skillScores = <BrainSkill, int>{
      BrainSkill.memory: prefs.getInt(_kSkillMemory) ?? 20,
      BrainSkill.focus: prefs.getInt(_kSkillFocus) ?? 20,
      BrainSkill.logic: prefs.getInt(_kSkillLogic) ?? 20,
      BrainSkill.math: prefs.getInt(_kSkillMath) ?? 20,
    };

    _progress = PlayerProgress(
      completedStageIds: completed,
      solvedCaseIds: solved,
      skillScores: skillScores,
      streakDays: prefs.getInt(_kStreak) ?? 0,
      lastPlayedDate: prefs.getString(_kLastPlayed),
      totalSessions: prefs.getInt(_kTotalSessions) ?? 0,
      isPremiumUnlocked: prefs.getBool(_kPremium) ?? false,
    );
    _loaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLang, lang == AppLanguage.en ? 'en' : 'id');
  }

  Future<void> toggleLanguage() async {
    await setLanguage(
      _language == AppLanguage.id ? AppLanguage.en : AppLanguage.id,
    );
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    SoundService.instance.setEnabled(_soundEnabled);
    notifyListeners();
    if (_soundEnabled) {
      SoundService.instance.playTap();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSoundEnabled, _soundEnabled);
  }

  Future<void> recordMiniGameResult(
    MiniGameResult result, {
    String? stageId,
  }) async {
    final today = _todayKey();
    int nextStreak = _progress.streakDays;
    final last = _progress.lastPlayedDate;

    if (last == null) {
      nextStreak = 1;
    } else if (last == today) {
      nextStreak = nextStreak == 0 ? 1 : nextStreak;
    } else if (last == _yesterdayKey()) {
      nextStreak = nextStreak + 1;
    } else {
      nextStreak = 1;
    }

    final updatedScores = Map<BrainSkill, int>.from(_progress.skillScores);
    final currentScore = updatedScores[result.skill] ?? 20;
    final blended = result.passed
        ? ((currentScore * 0.72) + (result.score * 0.28)).round().clamp(10, 100)
        : ((currentScore * 0.9) + (result.score * 0.1)).round().clamp(10, 100);
    updatedScores[result.skill] = result.passed && blended <= currentScore
        ? (currentScore + 2).clamp(10, 100)
        : blended;

    final updatedStages = Set<String>.from(_progress.completedStageIds);
    if (result.passed && stageId != null) {
      updatedStages.add(stageId);
    }

    _progress = _progress.copyWith(
      completedStageIds: updatedStages,
      skillScores: updatedScores,
      streakDays: nextStreak,
      lastPlayedDate: today,
      totalSessions: _progress.totalSessions + 1,
    );
    notifyListeners();
    await _persist();
  }

  Future<void> markCaseSolved(String caseId) async {
    final updatedSolved = Set<String>.from(_progress.solvedCaseIds)..add(caseId);
    _progress = _progress.copyWith(solvedCaseIds: updatedSolved);
    notifyListeners();
    await _persist();
  }

  Future<void> unlockPremiumPass() async {
    _progress = _progress.copyWith(isPremiumUnlocked: true);
    notifyListeners();
    await _persist();
  }

  Future<void> resetAllProgress() async {
    _progress = PlayerProgress.initial();
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kCompletedStages,
      _progress.completedStageIds.toList(),
    );
    await prefs.setStringList(
      _kSolvedCases,
      _progress.solvedCaseIds.toList(),
    );
    await prefs.setInt(
        _kSkillMemory, _progress.skillScores[BrainSkill.memory] ?? 20);
    await prefs.setInt(
        _kSkillFocus, _progress.skillScores[BrainSkill.focus] ?? 20);
    await prefs.setInt(
        _kSkillLogic, _progress.skillScores[BrainSkill.logic] ?? 20);
    await prefs.setInt(
        _kSkillMath, _progress.skillScores[BrainSkill.math] ?? 20);
    await prefs.setInt(_kStreak, _progress.streakDays);
    if (_progress.lastPlayedDate != null) {
      await prefs.setString(_kLastPlayed, _progress.lastPlayedDate!);
    } else {
      await prefs.remove(_kLastPlayed);
    }
    await prefs.setInt(_kTotalSessions, _progress.totalSessions);
    await prefs.setBool(_kPremium, _progress.isPremiumUnlocked);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _yesterdayKey() {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return '${y.year}-${y.month.toString().padLeft(2, '0')}-${y.day.toString().padLeft(2, '0')}';
  }
}
