enum AppLanguage { id, en }

enum BrainSkill { memory, focus, logic, math }

class LocalizedText {
  final String id;
  final String en;

  const LocalizedText({required this.id, required this.en});

  String of(AppLanguage lang) => lang == AppLanguage.id ? id : en;
}

class CaseStage {
  final String id;
  final int order;
  final BrainSkill skill;
  final int difficulty; // 1..5
  final LocalizedText location;
  final LocalizedText title;
  final LocalizedText briefing;
  final LocalizedText detectiveQuip;
  final LocalizedText evidenceTitle;
  final LocalizedText evidenceDetail;
  final LocalizedText evidenceFunnyCaption;

  const CaseStage({
    required this.id,
    required this.order,
    required this.skill,
    required this.difficulty,
    required this.location,
    required this.title,
    required this.briefing,
    required this.detectiveQuip,
    required this.evidenceTitle,
    required this.evidenceDetail,
    required this.evidenceFunnyCaption,
  });
}

class Suspect {
  final String id;
  final String name;
  final String initials;
  final String avatarEmoji;
  final LocalizedText role;
  final LocalizedText alibi;
  final LocalizedText funnyNote;
  final bool isCulprit;

  const Suspect({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarEmoji,
    required this.role,
    required this.alibi,
    required this.funnyNote,
    required this.isCulprit,
  });
}

class DetectiveCase {
  final String id;
  final String code;
  final String imageAsset;
  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText synopsis;
  final bool isPremium;
  final List<CaseStage> stages;
  final List<Suspect> suspects;
  final LocalizedText deductionPrompt;
  final LocalizedText twistTitle;
  final LocalizedText twistCaption;
  final LocalizedText resolution;

  const DetectiveCase({
    required this.id,
    required this.code,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.synopsis,
    required this.isPremium,
    required this.stages,
    required this.suspects,
    required this.deductionPrompt,
    required this.twistTitle,
    required this.twistCaption,
    required this.resolution,
  });
}

class MiniGameResult {
  final BrainSkill skill;
  final bool passed;
  final int score; // 0..100
  final int correctCount;
  final int totalCount;

  const MiniGameResult({
    required this.skill,
    required this.passed,
    required this.score,
    required this.correctCount,
    required this.totalCount,
  });
}

class PlayerProgress {
  final Set<String> completedStageIds;
  final Set<String> solvedCaseIds;
  final Map<BrainSkill, int> skillScores; // 0..100
  final int streakDays;
  final String? lastPlayedDate; // YYYY-MM-DD
  final int totalSessions;
  final bool isPremiumUnlocked;

  const PlayerProgress({
    required this.completedStageIds,
    required this.solvedCaseIds,
    required this.skillScores,
    required this.streakDays,
    required this.lastPlayedDate,
    required this.totalSessions,
    required this.isPremiumUnlocked,
  });

  factory PlayerProgress.initial() => const PlayerProgress(
        completedStageIds: {},
        solvedCaseIds: {},
        skillScores: {
          BrainSkill.memory: 20,
          BrainSkill.focus: 20,
          BrainSkill.logic: 20,
          BrainSkill.math: 20,
        },
        streakDays: 0,
        lastPlayedDate: null,
        totalSessions: 0,
        isPremiumUnlocked: false,
      );

  int get brainIndex {
    final total = skillScores.values.fold<int>(0, (sum, v) => sum + v);
    return (total / BrainSkill.values.length).round();
  }

  PlayerProgress copyWith({
    Set<String>? completedStageIds,
    Set<String>? solvedCaseIds,
    Map<BrainSkill, int>? skillScores,
    int? streakDays,
    String? lastPlayedDate,
    int? totalSessions,
    bool? isPremiumUnlocked,
  }) {
    return PlayerProgress(
      completedStageIds: completedStageIds ?? this.completedStageIds,
      solvedCaseIds: solvedCaseIds ?? this.solvedCaseIds,
      skillScores: skillScores ?? this.skillScores,
      streakDays: streakDays ?? this.streakDays,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      totalSessions: totalSessions ?? this.totalSessions,
      isPremiumUnlocked: isPremiumUnlocked ?? this.isPremiumUnlocked,
    );
  }
}
