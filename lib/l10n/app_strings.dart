import '../models/game_models.dart';

class AppStrings {
  final AppLanguage lang;

  const AppStrings(this.lang);

  bool get isId => lang == AppLanguage.id;

  String t(String id, String en) => isId ? id : en;

  // Brand & Navigation
  String get appName => 'MindCase';
  String get appTagline => t(
        'Misteri Jenaka & Latih Otak',
        'Witty Mystery & Brain Training',
      );
  String get heroGreeting => t(
        'Inspektur Juno: "Kopi sudah siap, kasus aneh menanti. Ayo panaskan otakmu!"',
        'Inspector Juno: "Coffee\'s hot, weird cases await. Let\'s warm up that brain!"',
      );
  String get navCases => t('Kasus', 'Cases');
  String get navTraining => t('Latihan', 'Training');
  String get navProfile => t('Profil Otak', 'Brain Profile');

  // Skills
  String skillName(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return t('Memori', 'Memory');
      case BrainSkill.focus:
        return t('Fokus', 'Focus');
      case BrainSkill.logic:
        return t('Logika', 'Logic');
      case BrainSkill.math:
        return t('Hitung', 'Math');
    }
  }

  String skillGameTitle(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return t('Memori TKP', 'Scene Recall');
      case BrainSkill.focus:
        return t('Saring Kesaksian', 'Testimony Filter');
      case BrainSkill.logic:
        return t('Cari Bukti Janggal', 'Odd Clue Hunt');
      case BrainSkill.math:
        return t('Audit Angka', 'Ledger Audit');
    }
  }

  String skillGameDesc(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return t(
          'Ingat posisi titik bukti yang menyala sekilas di grid.',
          'Recall the glowing evidence tiles after they fade.',
        );
      case BrainSkill.focus:
        return t(
          'Pilih WARNA TINTA teksnya, bukan arti katanya (jangan terkecoh!).',
          'Pick the INK COLOR of the word, not its text (don\'t blink!).',
        );
      case BrainSkill.logic:
        return t(
          'Temukan 1 simbol bukti yang aneh/berbeda dari pola lainnya!',
          'Spot the 1 odd evidence tile that breaks the visual pattern!',
        );
      case BrainSkill.math:
        return t(
          'Verifikasi hitungan & angka hilang dengan cepat.',
          'Solve rapid ledger calculations & missing numbers.',
        );
    }
  }

  // Home / Cases
  String get brainIndexLabel => t('Indeks Otak', 'Brain Index');
  String get streakLabel => t('Streak', 'Streak');
  String daysCount(int n) => isId ? '$n hari' : '$n ${n == 1 ? "day" : "days"}';
  String get activeFiles => t('Arsip Kasus', 'Case Files');
  String get offlineBadge => t('100% Offline', '100% Offline');
  String get freeBadge => t('GRATIS', 'FREE');
  String get premiumBadge => t('PASS', 'PASS');
  String get solvedBadge => t('SELESAI', 'SOLVED');
  String evidenceProgress(int done, int total) =>
      t('$done/$total Bukti Terungkap', '$done/$total Clues Uncovered');
  String get openCase => t('Buka Berkas', 'Open Case');
  String get unlockWithPass => t('Buka dengan Detective Pass', 'Unlock with Detective Pass');

  // Case Board
  String get caseBoardTitle => t('Papan Investigasi', 'Case Board');
  String get collectedClues => t('Bukti Terkumpul', 'Collected Evidence');
  String get noCluesYet => t(
        'Belum ada bukti. Selesaikan tahap pertama untuk memulai.',
        'No clues yet. Complete the first stage to begin.',
      );
  String get investigateNow => t('Investigasi', 'Investigate');
  String get replayStage => t('Ulangi', 'Replay');
  String get lockedStage => t('Terkunci', 'Locked');
  String get accuseCulprit => t('Tentukan Pelaku!', 'Accuse the Culprit!');
  String get accuseHint => t(
        'Kumpulkan seluruh bukti dulu—jangan sampai salah tangkap orang lagi.',
        'Gather all clues first—let\'s avoid another awkward wrongful arrest.',
      );
  String get caseSolvedBanner => t(
        'Kasus Ditutup! Pelakunya sukses kamu skakmat.',
        'Case Closed! You totally outsmarted the culprit.',
      );

  // Briefing & Result
  String get dossierBriefing => t('Berkas Lapangan', 'Field Briefing');
  String get startAnalysis => t('Mulai Analisis', 'Start Analysis');
  String get evidenceUnlocked => t('Bukti Terungkap!', 'Evidence Uncovered!');
  String get winQuip => t(
        'Inspektur Juno: "Tajam banget! Kopi saya sampai kalah panas sama otakmu."',
        'Inspector Juno: "Razor sharp! Even my double espresso can\'t keep up with you."',
      );
  String get failQuip => t(
        'Inspektur Juno: "Santai, Sherlock saja pernah lupa naruh kacamata yang lagi dipakai."',
        'Inspector Juno: "No sweat—even Sherlock once searched for glasses sitting on his forehead."',
      );
  String get analysisFailed => t('Nyaris! Belum Tuntas', 'So Close! Try Again');
  String get analysisFailedDesc => t(
        'Tarik napas dulu, lalu ulangi analisis bukti ini.',
        'Take a breather and give this clue another shot.',
      );
  String get backToBoard => t('Kembali ke Papan Kasus', 'Back to Case Board');
  String get tryAgain => t('Coba Lagi', 'Try Again');
  String get scoreLabel => t('Skor', 'Score');
  String get accuracyLabel => t('Akurasi', 'Accuracy');
  String get skillBoosted => t('Kemampuan Meningkat', 'Skill Improved');

  // Deduction
  String get finalDeduction => t('Deduksi Akhir', 'Final Deduction');
  String get suspectsTitle => t('Daftar Tersangka', 'Suspect Lineup');
  String get confirmAccusation => t('Tuduh Tersangka Ini!', 'Accuse This Suspect!');
  String get wrongSuspectTitle => t('Ups, Salah Tangkap!', 'Oops, Wrong Suspect!');
  String get wrongSuspectDesc => t(
        'Dia langsung memelototi kamu dan mau menelpon pengacaranya! Cek lagi 4 bukti di atas — alibinya tidak bertentangan dengan fakta utama.',
        'They just glared and started dialing their lawyer! Re-check the 4 clues above — their alibi doesn\'t clash with the key facts.',
      );
  String get caseClosedTitle => t('Kasus Terpecahkan!', 'Case Closed!');
  String get finishCase => t('Selesai & Kembali', 'Finish & Return');

  // Training
  String get dailyWorkoutTitle => t('Latihan Cepat 2 Menit', '2-Minute Quick Drill');
  String get dailyWorkoutDesc => t(
        'Asah fokus & memori kapan saja secara offline—lebih sehat dari doomscrolling!',
        'Sharpen focus & memory anytime offline—way healthier than doomscrolling!',
      );
  String get startRandomDrill => t('Mulai Latihan Acak', 'Start Random Drill');
  String get chooseSkill => t('Pilih Fokus Latihan', 'Choose a Cognitive Skill');
  String get difficultyLabel => t('Tingkat Kesulitan', 'Difficulty');
  String get trainingComplete => t('Latihan Selesai!', 'Training Complete!');
  String get doneBtn => t('Selesai', 'Done');

  // Profile
  String get cognitiveMap => t('Peta Kekuatan Otak', 'Cognitive Radar');
  String get statsTitle => t('Ringkasan Progres', 'Progress Summary');
  String get totalSessions => t('Total Sesi', 'Total Sessions');
  String get casesSolved => t('Kasus Selesai', 'Cases Solved');
  String get languageLabel => t('Bahasa / Language', 'Language / Bahasa');
  String get soundEffectsLabel => t('Efek Suara (SFX)', 'Sound Effects (SFX)');
  String get soundOn => t('Aktif', 'On');
  String get soundOff => t('Mati', 'Off');
  String get detectivePassTitle => t('Detective Pass', 'Detective Pass');
  String get detectivePassActive => t('Aktif — Semua Kasus Terbuka', 'Active — All Cases Unlocked');
  String get detectivePassInactive => t(
        'Buka semua kasus premium sekali bayar, 100% offline.',
        'Unlock all premium cases with one-time purchase, 100% offline.',
      );
  String get upgradeBtn => t('Lihat Pass', 'View Pass');
  String get resetProgress => t('Reset Progres Lokal', 'Reset Local Progress');
  String get resetConfirmTitle => t('Reset Semua Progres?', 'Reset All Progress?');
  String get resetConfirmBody => t(
        'Semua skor otak, streak, dan progres kasus di perangkat ini akan kembali ke awal.',
        'All brain scores, streak, and case progress on this device will be reset.',
      );
  String get cancel => t('Batal', 'Cancel');
  String get reset => t('Reset', 'Reset');

  // Premium Modal
  String get passHeadline => t('Buka Semua Arsip Kasus', 'Unlock Every Case File');
  String get passSub => t(
        'Model sekali bayar (One-Time Purchase) ramah pemain — tanpa langganan bulanan, tetap 100% offline.',
        'Player-friendly one-time purchase — no monthly subscription, stays 100% offline.',
      );
  String get passBenefit1 => t('Akses penuh Kasus #03 dan seluruh kasus baru mendatang', 'Full access to Case #03 and all future case packs');
  String get passBenefit2 => t('Bebas iklan selamanya di semua mode latihan', 'Zero ads forever across all training modes');
  String get passBenefit3 => t('Mendukung pengembangan kasus misteri kocak baru', 'Supports new handcrafted witty mystery cases');
  String get passPriceTag => t('Rp 39.000 (Sekali Bayar)', '\$2.99 (One-Time)');
  String get passSimulateBtn => t('Simulasi Buka Pass (Mode Dev)', 'Simulate Unlock (Dev Mode)');
  String get passUnlockedToast => t('Detective Pass aktif! Kasus #03 terbuka.', 'Detective Pass active! Case #03 unlocked.');

  // Mini-game HUD
  String get memorizePhase => t('Hafalkan posisi bukti!', 'Memorize the evidence tiles!');
  String get recallPhase => t('Ketuk posisi yang tadi menyala', 'Tap the tiles you saw');
  String get stroopPrompt => t('Pilih WARNA TINTA teks ini:', 'Tap the INK COLOR of this text:');
  String get anomalyPrompt => t('Ketuk 1 bukti yang JANGGAL di grid!', 'Tap the 1 ODD clue on the grid!');
  String get mathPrompt => t('Selesaikan audit cepat:', 'Solve the rapid audit:');
  String roundLabel(int current, int total) => t('Ronde $current/$total', 'Round $current/$total');
}
