import '../models/game_models.dart';

class AppStrings {
  final AppLanguage lang;

  const AppStrings(this.lang);

  bool get isId => lang == AppLanguage.id;

  String t(String id, String en) => isId ? id : en;

  // Brand & Navigation
  String get appName => t('Arsip Kelam', 'Dark Archive');
  String get appTagline => t(
        'Investigasi Horor Mistis Nusantara',
        'Indonesian Mystical Horror Investigation',
      );
  String get heroGreeting => t(
        'Raka: "Senter masih menyala... tapi lorong Lantai 3 ini terasa jauh lebih dingin dari semalam."',
        'Raka: "The flashlight still works... yet this 3rd-floor corridor feels far colder than last night."',
      );
  String get navCases => t('Arsip', 'Cases');
  String get navTraining => t('Simulasi', 'Drills');
  String get navProfile => t('Catatan Raka', 'Raka\'s Log');

  // Skills (mapped onto the 4 horror investigative pillars)
  String skillName(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return t('Observasi', 'Observation');
      case BrainSkill.focus:
        return t('Frekuensi', 'Frequency');
      case BrainSkill.logic:
        return t('Ritual', 'Ritual');
      case BrainSkill.math:
        return t('Ketahanan', 'Composure');
    }
  }

  String skillGameTitle(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return t('Usap Cermin', 'Wipe the Mirror');
      case BrainSkill.focus:
        return t('Selaraskan Pita Diktafon', 'Tune the Dictaphone');
      case BrainSkill.logic:
        return t('Susun Arah Sesajen', 'Align the Offerings');
      case BrainSkill.math:
        return t('Tahan Napas', 'Hold Your Breath');
    }
  }

  String skillGameDesc(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return t(
          'Usap lapisan embun di cermin minimal 75% untuk menyingkap tulisan tersembunyi.',
          'Wipe at least 75% of the fog off the mirror to reveal the hidden numbers.',
        );
      case BrainSkill.focus:
        return t(
          'Geser frekuensi pita diktafon (0–100) sampai suara statis hilang & rekaman 1998 terdengar jelas.',
          'Slide the tape frequency (0–100) until static clears and the 1998 recording emerges.',
        );
      case BrainSkill.logic:
        return t(
          'Susun 3 benda sesajen ke arah mata angin yang tepat sesuai petunjuk juru kunci.',
          'Place the 3 mystical offerings onto their exact cardinal slots using the caretaker\'s clues.',
        );
      case BrainSkill.math:
        return t(
          'Tahan tombol "Tahan Napas" selama 6 detik penuh saat sosok brankar melintas. Jangan lepas!',
          'Press and hold "Hold Breath" for 6 full seconds while the gurney passes. Do not let go!',
        );
    }
  }

  // Home / Cases
  String get brainIndexLabel => t('Ketajaman Insting', 'Instinct Index');
  String get streakLabel => t('Malam Aktif', 'Night Streak');
  String daysCount(int n) => isId ? '$n malam' : '$n ${n == 1 ? "night" : "nights"}';
  String get activeFiles => t('Berkas Kasus Mistis', 'Supernatural Case Files');
  String get offlineBadge => t('100% Offline', '100% Offline');
  String get freeBadge => t('GRATIS', 'FREE');
  String get premiumBadge => t('ARSIP PRO', 'PRO FILE');
  String get solvedBadge => t('TERUNGKAP', 'SOLVED');
  String evidenceProgress(int done, int total) =>
      t('$done/$total Bukti Terungkap', '$done/$total Clues Uncovered');
  String get openCase => t('Masuki Lokasi', 'Enter Location');
  String get unlockWithPass => t('Buka dengan Arsip Penuh', 'Unlock with Full Archive');

  // Case Board
  String get caseBoardTitle => t('Peta Investigasi', 'Investigation Board');
  String get collectedClues => t('Bukti Terkumpul', 'Collected Evidence');
  String get noCluesYet => t(
        'Belum ada bukti. Mulai penelusuran dari titik pertama.',
        'No evidence yet. Begin investigating the first location.',
      );
  String get investigateNow => t('Selidiki', 'Investigate');
  String get replayStage => t('Ulangi', 'Replay');
  String get lockedStage => t('Terkunci', 'Locked');
  String get accuseCulprit => t('Ungkap Kebenaran!', 'Reveal the Truth!');
  String get accuseHint => t(
        'Kumpulkan keempat bukti terlebih dahulu sebelum menyimpulkan sumber teror.',
        'Uncover all four pieces of evidence before confronting the truth.',
      );
  String get caseSolvedBanner => t(
        'Misteri Terungkap! Kebenaran gelap di balik kasus ini telah dicatat.',
        'Mystery Solved! The dark truth behind this case has been recorded.',
      );

  // Briefing & Result
  String get dossierBriefing => t('Catatan Lapangan Raka', 'Raka\'s Field Note');
  String get startAnalysis => t('Mulai Penelusuran', 'Begin Investigation');
  String get evidenceUnlocked => t('Bukti Terungkap!', 'Evidence Uncovered!');
  String get winQuip => t(
        'Raka: "Tanganku sedikit gemetar... tapi kepingan kebenarannya mulai terlihat."',
        'Raka: "My hands are shaking... but the pieces of the truth are falling into place."',
      );
  String get failQuip => t(
        'Raka: "Hampir ketahuan... tenangkan napas dulu, lalu coba sekali lagi."',
        'Raka: "Too close... steady your breathing and try again."',
      );
  String get analysisFailed => t('Penelusuran Terganggu', 'Investigation Interrupted');
  String get analysisFailedDesc => t(
        'Hawa dingin memutus fokusmu. Tarik napas dalam dan ulangi tahap ini.',
        'A sudden chill broke your focus. Catch your breath and retry this stage.',
      );
  String get backToBoard => t('Kembali ke Peta Kasus', 'Back to Case Board');
  String get tryAgain => t('Coba Lagi', 'Try Again');
  String get scoreLabel => t('Ketenangan', 'Composure');
  String get accuracyLabel => t('Capaian', 'Progress');
  String get skillBoosted => t('Insting Meningkat', 'Instinct Sharpened');

  // Deduction
  String get finalDeduction => t('Kesimpulan Akhir', 'Final Deduction');
  String get suspectsTitle => t('Sosok di Balik Peristiwa', 'Key Figures');
  String get confirmAccusation => t('Tunjuk Sumber Tragedi', 'Identify the Responsible');
  String get wrongSuspectTitle => t('Kesimpulan Keliru!', 'Wrong Conclusion!');
  String get wrongSuspectDesc => t(
        'Lampu koridor berkedip merah... Bukti-bukti yang Raka temukan tidak mengarah ke sosok ini. Periksa kembali keempat catatan bukti di atas.',
        'The corridor lights flicker red... Raka\'s collected clues do not point here. Re-examine the four pieces of evidence above.',
      );
  String get caseClosedTitle => t('Kebenaran Terungkap', 'Truth Revealed');
  String get finishCase => t('Tutup Berkas Kasus', 'Close Case File');

  // Training / Drills
  String get dailyWorkoutTitle => t('Simulasi Uji Nyali', 'Survival Instinct Drill');
  String get dailyWorkoutDesc => t(
        'Latih ketenangan, ketelitian, dan fokus di keempat mini-game horor secara offline.',
        'Practice composure, focus, and ritual logic across all 4 horror mini-games offline.',
      );
  String get startRandomDrill => t('Mulai Simulasi Acak', 'Start Random Drill');
  String get chooseSkill => t('Pilih Mini-Game', 'Choose a Mini-Game');
  String get difficultyLabel => t('Intensitas', 'Intensity');
  String get trainingComplete => t('Simulasi Selesai', 'Drill Complete');
  String get doneBtn => t('Selesai', 'Done');

  // Profile
  String get cognitiveMap => t('Profil Insting Raka', 'Raka\'s Instinct Radar');
  String get statsTitle => t('Ringkasan Penelusuran', 'Investigation Summary');
  String get totalSessions => t('Total Sesi', 'Total Sessions');
  String get casesSolved => t('Kasus Terungkap', 'Cases Solved');
  String get languageLabel => t('Bahasa / Language', 'Language / Bahasa');
  String get soundEffectsLabel => t('Efek Suara (SFX)', 'Sound Effects (SFX)');
  String get soundOn => t('Aktif', 'On');
  String get soundOff => t('Mati', 'Off');
  String get detectivePassTitle => t('Arsip Penuh (Pro)', 'Full Archive Pass');
  String get detectivePassActive => t('Aktif — Semua Berkas Kelam Terbuka', 'Active — All Dark Files Unlocked');
  String get detectivePassInactive => t(
        'Buka seluruh kasus horor lanjutan sekali bayar, 100% offline.',
        'Unlock all horror chapters with a one-time purchase, 100% offline.',
      );
  String get upgradeBtn => t('Buka Arsip', 'View Pass');
  String get resetProgress => t('Reset Catatan Lokal', 'Reset Local Data');
  String get resetConfirmTitle => t('Hapus Semua Progres?', 'Reset All Progress?');
  String get resetConfirmBody => t(
        'Seluruh bukti, progres kasus, dan catatan Raka di perangkat ini akan dihapus.',
        'All evidence, case progress, and Raka\'s log on this device will be reset.',
      );
  String get cancel => t('Batal', 'Cancel');
  String get reset => t('Reset', 'Reset');

  // Premium Modal
  String get passHeadline => t('Buka Semua Berkas Terlarang', 'Unlock Every Forbidden File');
  String get passSub => t(
        'Sekali bayar tanpa langganan bulanan — tetap 100% bisa dimainkan offline di tempat gelap sekalipun.',
        'One-time purchase with no subscription — stays 100% playable offline anywhere.',
      );
  String get passBenefit1 => t('Akses penuh Kasus #03 dan seluruh kasus mistis mendatang', 'Full access to Case #03 and all upcoming horror files');
  String get passBenefit2 => t('Bebas iklan selamanya agar atmosfer horor tak terganggu', 'Zero ads forever to preserve the horror immersion');
  String get passBenefit3 => t('Mendukung produksi cerita horor lokal Nusantara baru', 'Supports new handcrafted Indonesian horror stories');
  String get passPriceTag => t('Rp 39.000 (Sekali Bayar)', '\$2.99 (One-Time)');
  String get passSimulateBtn => t('Simulasi Buka Arsip (Mode Dev)', 'Simulate Unlock (Dev Mode)');
  String get passUnlockedToast => t('Arsip Penuh aktif! Kasus #03 terbuka.', 'Full Archive active! Case #03 unlocked.');

  // Mini-game specific prompts
  String get wipeMirrorHint => t('Usap kabut di cermin (min. 75%)', 'Wipe the fog off the mirror (min. 75%)');
  String get mirrorClearedLabel => t('Embun Bersih', 'Fog Cleared');
  String get mirrorShadowWarning => t('Ada sosok samar di sudut cermin...', 'A pale figure appears in the corner...');
  String get mirrorRevealedBanner => t('TULISAN TERUNGKAP: 304 • 01:45', 'REVEALED: 304 • 01:45');

  String get dictaphoneHint => t('Geser frekuensi (0–100) untuk menjernihkan pita 1998', 'Slide frequency (0–100) to clear the 1998 tape');
  String get frequencyLabel => t('Frekuensi', 'Frequency');
  String get staticHigh => t('STATIS KUAT — PITA TERDISTORSI', 'HEAVY STATIC — DISTORTED TAPE');
  String get staticNear => t('SINYAL MENDEKAT — SEDIKIT LAGI...', 'SIGNAL NEAR — ALMOST CLEAR...');
  String get staticClear => t('SINYAL JERNIH! TAHAN POSISI...', 'SIGNAL LOCKED! HOLDING...');
  String get lockTranscriptBtn => t('Simpan Transkrip Rekaman', 'Save Tape Transcript');

  String get ritualHint => t('Susun 3 benda sesajen ke arah Utara, Tengah, & Selatan', 'Place the 3 offerings into North, Center, & South');
  String get verifySealBtn => t('Uji Segel Pintu Ruang 304', 'Test Room 304 Seal');
  String get sealWrongMsg => t('Segel menolak susunan ini! Periksa lagi petunjuk juru kunci.', 'The seal rejects this order! Re-read the caretaker\'s clues.');
  String get sealOpenMsg => t('Segel mistis terbuka perlahan...', 'The mystical seal slowly unlocks...');

  String get holdBreathTitle => t('Sosok brankar melintas di lorong!', 'A shadow pushing a gurney approaches!');
  String get holdBreathBtn => t('TAHAN NAPAS', 'HOLD BREATH');
  String get holdingBreathBtn => t('JANGAN BERGERAK...', 'DO NOT MOVE...');
  String get holdBreathFailRelease => t('NAPASMU TERDENGAR! Sosok itu menoleh... Ulangi!', 'IT HEARD YOU BREATHE! The shadow turned... Retry!');
  String get holdBreathFailPanic => t('DETAK JANTUNG TERLALU TINGGI! Panikmu terdeteksi... Ulangi!', 'HEARTBEAT MAXED OUT! Your panic gave you away... Retry!');
  String get heartbeatLabel => t('Detak Jantung', 'Heartbeat');
  String get surviveTimeLabel => t('Bertahan', 'Survive');
}
