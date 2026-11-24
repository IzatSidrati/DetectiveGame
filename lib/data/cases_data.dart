import '../models/game_models.dart';

const List<DetectiveCase> kDetectiveCases = [
  DetectiveCase(
    id: 'case_01',
    code: 'CASE #01',
    imageAsset: 'case_01',
    isPremium: false,
    title: LocalizedText(
      id: 'Tragedi Jam 02.15 & Espresso Gaib',
      en: 'The 02:15 Clock & Phantom Espresso',
    ),
    subtitle: LocalizedText(
      id: 'Kasus Ruang Arsip • Kafein Tingkat Tinggi',
      en: 'Archive Heist • High-Caffeine Mystery',
    ),
    synopsis: LocalizedText(
      id: 'Buku besar kantor raib pukul 02.15 — parahnya, daftar utang arisan juga ikut kebawa! Pelaku meninggalkan jam dinding jatuh dan aroma espresso mahal.',
      en: 'The office ledger vanished at 02:15 — along with the office snack-fund sheet! The thief left a smashed wall clock and the scent of pricey espresso.',
    ),
    stages: [
      CaseStage(
        id: 'c1_s1',
        order: 1,
        skill: BrainSkill.memory,
        difficulty: 1,
        location: LocalizedText(id: 'Pintu Ruang Arsip', en: 'Archive Entrance'),
        title: LocalizedText(id: 'Jejak Panel Kartu', en: 'Keycard Panel Recall'),
        briefing: LocalizedText(
          id: 'Pintu arsip mulus tanpa congkelan. Pelakunya sopan banget—masuk pakai tap kartu! Ayo ingat pola sensor yang menyala.',
          en: 'Zero forced entry. What a polite burglar—they literally tapped in! Recall the sensor trace left on the reader.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Maling modern memang beda, masuk ruangan pun tetap jaga sopan santun."',
          en: 'Detective Juno: "Modern thieves have manners. Next time they\'ll probably sign the guestbook."',
        ),
        evidenceTitle: LocalizedText(id: 'Kartu Akses Lantai 2', en: 'Floor-2 Staff Keycard'),
        evidenceDetail: LocalizedText(
          id: 'Pintu dibuka pakai kartu akses resmi staf lantai 2 — bukan kunci master manual.',
          en: 'Opened using an authorized Floor-2 staff keycard — definitely not a manual master key.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Plot mini: Di panel kartu ternyata juga menempel bekas lingkaran gelas kopi!',
          en: 'Mini-twist: The keycard scanner even had a fresh coffee-cup ring stuck on it!',
        ),
      ),
      CaseStage(
        id: 'c1_s2',
        order: 2,
        skill: BrainSkill.focus,
        difficulty: 1,
        location: LocalizedText(id: 'Lorong Timur', en: 'East Corridor'),
        title: LocalizedText(id: 'Saring Gosip Satpam', en: 'Filter Guard Gossip'),
        briefing: LocalizedText(
          id: 'Pak Satpam cerita panjang lebar dari hantu koridor sampai skor bola semalam. Saring celotehannya dan tangkap fakta asli!',
          en: 'The night guard rambled about ghosts and last night\'s match. Filter the fluff and catch the real clue!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Kalau kopi kantor yang biasanya rasa air cucian tiba-tiba wangi kafe Italia, pasti ada yang mencurigakan."',
          en: 'Detective Juno: "When a cheap office smells like an Italian cafe at 2 AM, somebody\'s up to no good."',
        ),
        evidenceTitle: LocalizedText(id: 'Aroma Espresso Mahal', en: 'Fresh Fancy Espresso'),
        evidenceDetail: LocalizedText(
          id: 'Pukul 02.10 tercium aroma espresso segar, padahal kafe gedung tutup sejak pukul 20.00.',
          en: 'Freshly brewed espresso was smelled at 02:10, though the building cafe closed at 20:00.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Bukan hantu koridor—ternyata cuma aroma biji kopi single-origin yang kelewat wangi!',
          en: 'No corridor ghost—just aggressively expensive single-origin coffee beans!',
        ),
      ),
      CaseStage(
        id: 'c1_s3',
        order: 3,
        skill: BrainSkill.logic,
        difficulty: 1,
        location: LocalizedText(id: 'Brankas Dokumen', en: 'Document Vault'),
        title: LocalizedText(id: 'Pecah Log Brankas', en: 'Crack the Vault Log'),
        briefing: LocalizedText(
          id: 'Brankas ini lebih cerewet dari HRD—semua salah pencet dicatat! Cari 1 simbol log yang janggal untuk membongkar riwayat PIN-nya.',
          en: 'This vault logs every wrong tap like a petty boss. Spot the 1 odd log symbol to expose its PIN history!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Dua kali salah PIN? Untung bukan ATM, kalau nggak sudah ketelen kartunya."',
          en: 'Detective Juno: "Two wrong PINs? Good thing it wasn\'t an ATM or their card would be toast."',
        ),
        evidenceTitle: LocalizedText(id: '2 Kali Salah PIN', en: 'Two Failed PIN Tries'),
        evidenceDetail: LocalizedText(
          id: 'Pelaku salah 2 kali sebelum berhasil — artinya bukan pemegang kode harian brankas.',
          en: 'Failed twice before opening — ruling out anyone who uses the daily vault PIN regularly.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Tebakan pertama pelaku ternyata "123456". Sungguh niat yang minimalis.',
          en: 'Their first guess was literally "123456". Minimalist effort, maximum chaos.',
        ),
      ),
      CaseStage(
        id: 'c1_s4',
        order: 4,
        skill: BrainSkill.math,
        difficulty: 1,
        location: LocalizedText(id: 'Gerbang Parkir B2', en: 'Basement B2 Gate'),
        title: LocalizedText(id: 'Audit Detik Kabur', en: 'Getaway Timer Audit'),
        briefing: LocalizedText(
          id: 'Jam dinding jatuh pukul 02.15. Hitung cepat selisih waktu lift & palang parkir B2 biar tahu kapan si pencuri tancap gas!',
          en: 'The clock crashed at 02:15. Audit the minute gaps between the elevator and B2 gate to clock the getaway!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Dari arsip ke parkiran cuma 6 menit—lari maraton atau dikejar deadline?"',
          en: 'Detective Juno: "Archive to parking in 6 minutes flat—either a sprinter or dodging a Monday meeting."',
        ),
        evidenceTitle: LocalizedText(id: 'Kabur Parkir B2 — 02.21', en: 'B2 Exit — 02:21 AM'),
        evidenceDetail: LocalizedText(
          id: 'Lift turun ke B2 pukul 02.18 dan satu mobil tancap gas keluar B2 tepat pukul 02.21.',
          en: 'Elevator hit B2 at 02:18 and one car sped past the B2 exit barrier at exactly 02:21.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Saking buru-burunya kabur, pelaku malah lupa mengambil karcis parkir gratisnya!',
          en: 'In such a rush to flee, the culprit forgot to validate their free parking ticket!',
        ),
      ),
    ],
    suspects: [
      Suspect(
        id: 'c1_sus_1',
        name: 'Raka Pratama',
        initials: 'RP',
        avatarEmoji: '🗂️',
        role: LocalizedText(id: 'Kepala Arsip', en: 'Head Archivist'),
        alibi: LocalizedText(
          id: 'Hafal PIN harian brankas di luar kepala. Anti kopi (minumnya teh manis hangat), dan pulang pukul 19.05.',
          en: 'Knows the daily vault PIN by heart. Hates coffee (strictly herbal tea), and clocked out at 19:05.',
        ),
        funnyNote: LocalizedText(
          id: 'Ngaku buru-buru pulang jam 7 malam demi nonton episode terakhir drama favoritnya.',
          en: 'Claims he rushed home at 7 PM to avoid spoilers for his favorite TV finale.',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c1_sus_2',
        name: 'Nadia Kusuma',
        initials: 'NK',
        avatarEmoji: '☕',
        role: LocalizedText(id: 'Analis Keuangan', en: 'Financial Analyst'),
        alibi: LocalizedText(
          id: 'Punya kartu akses lantai 2 dan mesin espresso pribadi di mejanya. Mobilnya terekam keluar B2 pukul 02.21.',
          en: 'Holds a Floor-2 keycard and keeps a private espresso machine at her desk. Her car left B2 at 02:21.',
        ),
        funnyNote: LocalizedText(
          id: 'Beralasan lembur sampai jam 2 pagi cuma buat "cari inspirasi spreadsheet".',
          en: 'Insists she stayed till 2 AM purely for "peaceful spreadsheet inspiration."',
        ),
        isCulprit: true,
      ),
      Suspect(
        id: 'c1_sus_3',
        name: 'Bima Santoso',
        initials: 'BS',
        avatarEmoji: '🔧',
        role: LocalizedText(id: 'Teknisi Gedung', en: 'Building Technician'),
        alibi: LocalizedText(
          id: 'Cuma pegang kunci master besi (tanpa kartu elektronik lantai 2). Semalaman jaga ruang genset lantai dasar.',
          en: 'Only carries manual metal keys (no Floor-2 keycard). Spent the night guarding the ground-floor generator.',
        ),
        funnyNote: LocalizedText(
          id: 'Sibuk memprotes AC lantai 3 yang selalu disetel 16°C padahal lagi musim hujan.',
          en: 'Too busy ranting about someone setting the 3rd-floor AC to 16°C during a thunderstorm.',
        ),
        isCulprit: false,
      ),
    ],
    deductionPrompt: LocalizedText(
      id: 'Semua bukti sudah di papan. Siapa pencuri buku besar yang doyan begadang sambil ngopi mahal?',
      en: 'The clues are pinned up. Who stole the ledger fueled by midnight luxury caffeine?',
    ),
    twistTitle: LocalizedText(
      id: 'PLOT TWIST: "Bos Mochi" Ikut Terbawa!',
      en: 'PLOT TWIST: "Boss Mochi" Was an Accomplice!',
    ),
    twistCaption: LocalizedText(
      id: 'Saat bagasi Nadia dibuka, kucing oren kantor berdasi merah malah tidur pulas di atas Buku Arisan!',
      en: 'When Nadia\'s trunk popped open, the chonky office cat in a red tie was napping right on the ledger!',
    ),
    resolution: LocalizedText(
      id: 'Ketahuan! Nadia memang masuk pakai kartu lantai 2 habis minum 3 gelas espresso—tapi ternyata dia cuma mau menyembunyikan bon mesin kopinya yang kelewat mahal, dan tak sengaja membawa kabur Bos Mochi si kucing kantor yang ketiduran di atas buku arisan!',
      en: 'Busted! Nadia did sneak in after 3 espressos—only to hide her ridiculously pricey coffee receipts, and accidentally kidnapped Boss Mochi the office cat who fell asleep on the snack-fund ledger!',
    ),
  ),
  DetectiveCase(
    id: 'case_02',
    code: 'CASE #02',
    imageAsset: 'case_02',
    isPremium: false,
    title: LocalizedText(
      id: 'Koper Misterius di Kereta Malam',
      en: 'The Briefcase Swap on the Night Train',
    ),
    subtitle: LocalizedText(
      id: 'Gerbong Eksekutif 4 • 40 Detik Gelap Gulita',
      en: 'Executive Car 4 • 40-Second Blackout',
    ),
    synopsis: LocalizedText(
      id: 'Lampu Gerbong 4 padam 40 detik di terowongan. Begitu nyala, koper diplomatik sudah ditukar dengan koper isi buku manual kereta super berat!',
      en: 'Car 4 went pitch-black for 40 seconds in the tunnel. When lights returned, a diplomatic briefcase had been swapped for one stuffed with heavy rail manuals!',
    ),
    stages: [
      CaseStage(
        id: 'c2_s1',
        order: 1,
        skill: BrainSkill.focus,
        difficulty: 2,
        location: LocalizedText(id: 'Gerbong Eksekutif 4', en: 'Executive Car 4'),
        title: LocalizedText(id: 'Saring Kepanikan Penumpang', en: 'Filter Cabin Panic'),
        briefing: LocalizedText(
          id: 'Ada yang teriak soal alien, ada yang sibuk cari sandalnya. Saring kepanikan penumpang untuk tahu jendela gelap yang asli!',
          en: 'One passenger yelled about aliens, another lost a slipper. Filter the chaos to pin down the exact blackout!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "40 detik mati lampu saja hebohnya sudah kayak film bencana."',
          en: 'Detective Juno: "Forty seconds without Wi-Fi or light and everyone acts like it\'s the apocalypse."',
        ),
        evidenceTitle: LocalizedText(id: 'Gelap 40 Detik (23.40)', en: '40s Blackout (23:40)'),
        evidenceDetail: LocalizedText(
          id: 'Penukaran kilat terjadi pukul 23.40 tanpa menyalakan senter HP sama sekali.',
          en: 'The lightning-fast swap occurred at 23:40 without even using a phone flashlight.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Konfirmasi: Tidak ada alien di terowongan, hanya penumpang yang kepanikan kehilangan sinyal.',
          en: 'Confirmed: Zero aliens in the tunnel, just passengers mourning their lost 5G signal.',
        ),
      ),
      CaseStage(
        id: 'c2_s2',
        order: 2,
        skill: BrainSkill.memory,
        difficulty: 2,
        location: LocalizedText(id: 'Lorong Gerbong 4', en: 'Car 4 Aisle'),
        title: LocalizedText(id: 'Jejak Jalan Merem', en: 'Blindfolded Path Recall'),
        briefing: LocalizedText(
          id: 'Pelaku jalan di lorong gelap tanpa menyenggol satu pun cangkir penumpang! Rekonstruksi jalur "ninja" itu di grid.',
          en: 'The culprit tiptoed down a dark aisle without spilling a single drink! Recall their ninja path on the grid.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Saya saja di rumah sendiri masih sering kesandung ujung kasur. Orang ini pasti hafal banget Gerbong 4!"',
          en: 'Detective Juno: "I still stub my toe in my own living room. Whoever did this knows Car 4 blindfolded!"',
        ),
        evidenceTitle: LocalizedText(id: 'Kursi Ganjil & Hafal Gerbong', en: 'Odd Window Seat & Cabin Pro'),
        evidenceDetail: LocalizedText(
          id: 'Pelaku bergerak dari kursi baris ganjil sisi jendela dan sangat hafal tata letak Gerbong 4.',
          en: 'Moved from an odd-numbered window seat and knew every inch of Car 4\'s layout.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Kemampuan jalan merem setingkat ini cuma dimiliki kru veteran... atau orang ngigau.',
          en: 'This level of dark-aisle navigation only belongs to rail veterans... or pro sleepwalkers.',
        ),
      ),
      CaseStage(
        id: 'c2_s3',
        order: 3,
        skill: BrainSkill.math,
        difficulty: 2,
        location: LocalizedText(id: 'Rak Bagasi Atas', en: 'Overhead Rack'),
        title: LocalizedText(id: 'Audit Koper Pemberat', en: 'Decoy Weight Audit'),
        briefing: LocalizedText(
          id: 'Biar kurir tidak curiga, koper palsu dijejali buku jadul sampai resletingnya megap-megap. Hitung selisih bobotnya!',
          en: 'To fool the courier, the decoy case was crammed with vintage books until the zipper begged for mercy. Audit the weight!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Kreatif juga, buku panduan kereta tahun 1998 akhirnya kepakai buat sesuatu."',
          en: 'Detective Juno: "At least those 1998 railway manuals finally proved useful for something."',
        ),
        evidenceTitle: LocalizedText(id: 'Isi Buku Jadul (+1,4 kg)', en: 'Old Rail Manuals (+1.4 kg)'),
        evidenceDetail: LocalizedText(
          id: 'Koper palsu diisi bundel jadwal teknis kereta — benda yang cuma ada di loker kru lama.',
          en: 'Stuffed with technical rail schedules — items only found inside old railway crew lockers.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Bonus temuan: Di selipan bukunya ada stiker jadwal kereta jadul yang masih belum sobek!',
          en: 'Bonus find: An untouched 1998 ticket stub was still tucked inside the manual!',
        ),
      ),
      CaseStage(
        id: 'c2_s4',
        order: 4,
        skill: BrainSkill.logic,
        difficulty: 2,
        location: LocalizedText(id: 'Log Sinyal Stasiun', en: 'Station Signal Log'),
        title: LocalizedText(id: 'Dekode Sandi Radio', en: 'Decode Radio Ping'),
        briefing: LocalizedText(
          id: 'Dua menit selepas terowongan, muncul satu sinyal radio aneh di antara frekuensi normal. Temukan sinyal yang janggal sekarang!',
          en: 'Two minutes past the tunnel, one bizarre radio ping stood out among normal channels. Spot the odd signal!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Pakai sandi kru kereta segala—kirain cuma anak pramuka yang suka main kode."',
          en: 'Detective Juno: "Old-school railway crew ciphers—retro, dramatic, and very incriminating."',
        ),
        evidenceTitle: LocalizedText(id: 'Sandi Internal Kru', en: 'Internal Rail Cipher'),
        evidenceDetail: LocalizedText(
          id: 'Pesan singkat memakai format sandi internal kru kereta rute selatan.',
          en: 'The ping used an internal crew cipher exclusive to southern-route railway staff.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Sandi sudah terbuka—ternyata ada typo kecil karena pelakunya ngetik sambil gemetaran!',
          en: 'Cipher cracked—complete with a typo because the sender typed while panicking!',
        ),
      ),
    ],
    suspects: [
      Suspect(
        id: 'c2_sus_1',
        name: 'Dr. Hendra Wijaya',
        initials: 'HW',
        avatarEmoji: '🩴',
        role: LocalizedText(id: 'Penumpang VIP', en: 'VIP Passenger'),
        alibi: LocalizedText(
          id: 'Baru pertama kali naik rute selatan. Duduk di kursi lorong Gerbong 2 bersama asistennya.',
          en: 'First-time rider on the southern line. Seated in an aisle seat in Car 2 with his assistant.',
        ),
        funnyNote: LocalizedText(
          id: 'Sepanjang keributan cuma sibuk mencari sandal hotelnya yang hilang sebelah.',
          en: 'Spent the entire commotion frantically searching for one missing hotel slipper.',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c2_sus_2',
        name: 'Clara Vance',
        initials: 'CV',
        avatarEmoji: '🍜',
        role: LocalizedText(id: 'Jurnalis Investigasi', en: 'Investigative Journalist'),
        alibi: LocalizedText(
          id: 'Duduk di kursi 12B (baris genap). Terekam CCTV gerbong restorasi tepat pukul 23.40.',
          en: 'Seated in 12B (even row). Caught on the dining car camera at exactly 23:40.',
        ),
        funnyNote: LocalizedText(
          id: 'Terekam kamera sedang antre porsi terakhir nasi goreng kereta dengan wajah sangat serius.',
          en: 'Caught on camera fiercely guarding the last plate of midnight train fried rice.',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c2_sus_3',
        name: 'Arman Setiawan',
        initials: 'AS',
        avatarEmoji: '🚂',
        role: LocalizedText(id: 'Mantan Kondektur Rute Selatan', en: 'Former Southern Conductor'),
        alibi: LocalizedText(
          id: 'Duduk di kursi 7A (baris ganjil jendela, Gerbong 4). Hafal denah gerbong dan kode sandi internal kru.',
          en: 'Seated in 7A (odd window seat, Car 4). Knows the cabin blindfolded plus internal crew ciphers.',
        ),
        funnyNote: LocalizedText(
          id: 'Masih refleks bilang "tiketnya disiapkan ya" setiap kali ada orang lewat di sampingnya.',
          en: 'Still mutters "tickets please" by reflex whenever anyone walks past his seat.',
        ),
        isCulprit: true,
      ),
    ],
    deductionPrompt: LocalizedText(
      id: 'Siapa "ninja lorong gelap" yang menukar koper diplomatik di Gerbong 4?',
      en: 'Who is the "dark-aisle ninja" behind the briefcase swap in Car 4?',
    ),
    twistTitle: LocalizedText(
      id: 'PLOT TWIST: Koper Rahasia Isi... Rantang Rendang!',
      en: 'PLOT TWIST: Top-Secret Briefcase Full of... Grandma\'s Rendang!',
    ),
    twistCaption: LocalizedText(
      id: 'Koper "TOP SECRET" dibuka dramatis—malah keluar asap wangi 3 susun rantang rendang nenek sang diplomat!',
      en: 'The "TOP SECRET" case dramatically opened to reveal a steaming 3-tier lunchbox of grandma\'s beef rendang!',
    ),
    resolution: LocalizedText(
      id: 'Skakmat! Arman berhasil diringkus sebelum stasiun terakhir. Tapi begitu koper "TOP SECRET" itu dibuka, Arman langsung lemas: isinya bukan dokumen rahasia negara, melainkan 3 susun rantang rendang nenek sang diplomat lengkap dengan catatan "Jangan lupa dihangatin ya, Nak ❤️"!',
      en: 'Checkmate! Arman was caught before the final station—only to collapse in disbelief when the "TOP SECRET" briefcase opened to reveal a 3-tier tin of grandma\'s rendang with a sticky note saying "Don\'t forget to reheat, dear ❤️"!',
    ),
  ),
  DetectiveCase(
    id: 'case_03',
    code: 'CASE #03',
    imageAsset: 'case_03',
    isPremium: true,
    title: LocalizedText(
      id: 'Lukisan Asli Tapi Kumisnya Miring',
      en: 'The Priceless Portrait with a Crooked Mustache',
    ),
    subtitle: LocalizedText(
      id: 'Galeri Meridian • Skandal Lelang Miliaran',
      en: 'Meridian Gallery • Billion-Dollar Blunder',
    ),
    synopsis: LocalizedText(
      id: '10 menit sebelum lelang, lukisan bangsawan abad ke-19 ketahuan palsu gara-gara kumisnya miring dan bau pernisnya bikin juri bersin!',
      en: 'Ten minutes before bidding, a 19th-century portrait was exposed as a fake—its painted mustache was lopsided and fresh varnish made the judge sneeze!',
    ),
    stages: [
      CaseStage(
        id: 'c3_s1',
        order: 1,
        skill: BrainSkill.logic,
        difficulty: 3,
        location: LocalizedText(id: 'Ruang Pamer Utama', en: 'Main Exhibition Hall'),
        title: LocalizedText(id: 'Cek Stiker Lot Janggal', en: 'Suspicious Lot Code'),
        briefing: LocalizedText(
          id: 'Satu stiker seri di balik bingkai tampak janggal—terlalu rapi untuk abad ke-19! Temukan simbol lot yang berbeda dari aslinya.',
          en: 'One serial tag behind the frame looks suspiciously crisp for the 1800s! Spot the odd lot symbol!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Abad ke-19 belum ada printer laser, kecuali pelukisnya mesin waktu."',
          en: 'Detective Juno: "Pretty sure 19th-century painters didn\'t own an office laser printer."',
        ),
        evidenceTitle: LocalizedText(id: 'Stiker Printer Kantor', en: 'Office Laser-Printed Tag'),
        evidenceDetail: LocalizedText(
          id: 'Stiker lot dicetak ulang memakai printer laser internal kantor galeri sore itu.',
          en: 'The lot tag was freshly printed on the gallery office\'s internal laser printer that afternoon.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Bahkan kertas stikernya masih agak hangat dari printer kantor!',
          en: 'The sticker paper was practically still warm from the office printer!',
        ),
      ),
      CaseStage(
        id: 'c3_s2',
        order: 2,
        skill: BrainSkill.math,
        difficulty: 3,
        location: LocalizedText(id: 'Gudang Klimatologi', en: 'Climate Vault'),
        title: LocalizedText(id: 'Audit Suhu Gudang', en: 'Vault Thermal Audit'),
        briefing: LocalizedText(
          id: 'Suhu gudang melonjak sebentar sore tadi. Hitung celah menit pastinya dari catatan sensor sebelum pelaku kabur!',
          en: 'The climate vault spiked briefly this afternoon. Audit the sensor log to find the exact break-in window!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "11 menit buat nukar lukisan raksasa? Lumayan juga buat olahraga sore."',
          en: 'Detective Juno: "Eleven minutes to swap a giant portrait? That counts as afternoon cardio."',
        ),
        evidenceTitle: LocalizedText(id: 'Terbuka 11 Menit (17.05)', en: 'Open 11 Mins (17:05)'),
        evidenceDetail: LocalizedText(
          id: 'Gudang dibuka tepat pukul 17.05–17.16, persis saat petugas keamanan ganti shift.',
          en: 'Vault opened from 17:05 to 17:16, right during the security shift handover.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Sensor mencatat pintu gudang sempat diganjal pakai botol minum biar nggak kekunci!',
          en: 'The sensor log suggests the door was propped open with a reusable water bottle!',
        ),
      ),
      CaseStage(
        id: 'c3_s3',
        order: 3,
        skill: BrainSkill.memory,
        difficulty: 3,
        location: LocalizedText(id: 'Ruang Pantau CCTV', en: 'CCTV Control Room'),
        title: LocalizedText(id: 'Peta Kamera Nengok Atap', en: 'Blind-Spot Camera Map'),
        briefing: LocalizedText(
          id: 'Ada satu kamera yang entah kenapa menengok ke langit-langit. Hafalkan sektor titik butanya untuk melacak kanvas asli!',
          en: 'One CCTV camera is hilariously staring at the ceiling. Memorize the blind-spot grid to trace the real canvas!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Kamera itu setia banget mengawasi cicak di plafon selama 20 menit penuh."',
          en: 'Detective Juno: "That camera dutifully monitored an empty ceiling tile for 20 straight minutes."',
        ),
        evidenceTitle: LocalizedText(id: 'Jalur Ruang Restorasi', en: 'Restoration Studio Path'),
        evidenceDetail: LocalizedText(
          id: 'Satu-satunya titik buta mengarah lurus ke ruang restorasi bingkai di sayap utara.',
          en: 'The only CCTV blind spot leads straight into the north-wing frame restoration studio.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Pelaku mengarahkan kamera ke atas pakai gagang sapu—klasik tapi tetap ketahuan!',
          en: 'They nudged the camera upward with a broomstick—classic move, still busted!',
        ),
      ),
      CaseStage(
        id: 'c3_s4',
        order: 4,
        skill: BrainSkill.focus,
        difficulty: 3,
        location: LocalizedText(id: 'Meja Restorasi', en: 'Restoration Bench'),
        title: LocalizedText(id: 'Saring Sampel Cat', en: 'Filter Paint Samples'),
        briefing: LocalizedText(
          id: 'Meja restorasi penuh kaleng warna-warni! Fokus penuh untuk memisahkan pelapis sintetis yang bikin kumisnya miring.',
          en: 'The bench is chaos in technicolor! Stay sharp and isolate the quick-dry glaze behind that crooked mustache.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Detektif Juno: "Buruan keringin lukisan palsu? Makanya kumis bangsawannya jadi kayak kena angin ribut."',
          en: 'Detective Juno: "Rushing a fake masterpiece? No wonder the nobleman\'s mustache looks windblown."',
        ),
        evidenceTitle: LocalizedText(id: 'Pernis Cepat-Kering', en: 'Fast-Dry Gloss Varnish'),
        evidenceDetail: LocalizedText(
          id: 'Sisa pernis cepat-kering khusus ditemukan pada sarung tangan katun di ruang restorasi.',
          en: 'Traces of specialized fast-dry varnish were found on cotton gloves in the restoration room.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Satu tetes cat kumis bahkan masih menempel di ujung hidung patung pajangan dekat pintu!',
          en: 'A stray mustache brush-stroke even landed on a bust statue near the exit!',
        ),
      ),
    ],
    suspects: [
      Suspect(
        id: 'c3_sus_1',
        name: 'Victor Salim',
        initials: 'VS',
        avatarEmoji: '🎩',
        role: LocalizedText(id: 'Kolektor VIP', en: 'VIP Collector'),
        alibi: LocalizedText(
          id: 'Baru tiba di lobi galeri pukul 18.30 bersama sopirnya dan langsung duduk di barisan depan lelang.',
          en: 'Arrived at the gallery lobby at 18:30 with his driver and walked straight to front-row seating.',
        ),
        funnyNote: LocalizedText(
          id: 'Sempat memuji kumis miring di lukisan palsu sebagai "sentuhan avant-garde yang berani".',
          en: 'Accidentally praised the crooked mustache as "a bold avant-garde touch."',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c3_sus_2',
        name: 'Sinta Maharani',
        initials: 'SM',
        avatarEmoji: '🎨',
        role: LocalizedText(id: 'Restorator Bingkai Galeri', en: 'Gallery Frame Restorer'),
        alibi: LocalizedText(
          id: 'Punya akses ruang restorasi & printer kantor. Bertugas sejak pukul 16.00 dan rutin memakai pernis cepat-kering.',
          en: 'Has access to the restoration room & office printer. On site since 16:00 and uses fast-dry varnish daily.',
        ),
        funnyNote: LocalizedText(
          id: 'Ada selembar stiker lot yang masih terselip di ujung jas kerjanya — dan baunya persis pernis baru.',
          en: 'A spare lot sticker is literally stuck to her sleeve — smelling faintly of fresh varnish.',
        ),
        isCulprit: true,
      ),
      Suspect(
        id: 'c3_sus_3',
        name: 'Deni Alamsyah',
        initials: 'DA',
        avatarEmoji: '🔨',
        role: LocalizedText(id: 'Juru Lelang Tamu', en: 'Guest Auctioneer'),
        alibi: LocalizedText(
          id: 'Hanya punya akses panggung utama & ruang VIP, tidak pernah masuk area gudang atau restorasi.',
          en: 'Only had access to the main stage and VIP lounge; never stepped into the vault or restoration wing.',
        ),
        funnyNote: LocalizedText(
          id: 'Latihan teriak "Tiga! Dua! Terjual!" di cermin selama satu jam sebelum acara.',
          en: 'Spent an hour practicing "Going once! Going twice! SOLD!" in front of the greenroom mirror.',
        ),
        isCulprit: false,
      ),
    ],
    deductionPrompt: LocalizedText(
      id: 'Palu lelang siap diketuk! Siapa seniman dadakan di balik lukisan berkumis miring ini?',
      en: 'The gavel is raised! Who is the hurried forged-mustache artist at Meridian Gallery?',
    ),
    twistTitle: LocalizedText(
      id: 'PLOT TWIST: Lukisan Palsunya Malah Laku 2 Miliar!',
      en: 'PLOT TWIST: The Fake Sold for Millions Anyway!',
    ),
    twistCaption: LocalizedText(
      id: 'Victor si kolektor VIP justru jatuh cinta sama kumis miringnya dan nekat beli karya palsu Sinta!',
      en: 'VIP collector Victor fell in love with the crooked mustache and bought Sinta\'s fake on the spot!',
    ),
    resolution: LocalizedText(
      id: 'Terjual—tapi tak terduga! Sinta Maharani memang menukar kanvas asli lewat titik buta pukul 17.05. Anehnya, begitu kebenaran terungkap, kolektor VIP Victor Salim malah protes dan langsung menawar 2 Miliar untuk membeli lukisan berkumis miring bikinan Sinta! Sinta pun bingung antara bangga atau pasrah diborgol.',
      en: 'Sold—with a wild twist! Sinta did swap the original at 17:05, yet when exposed, VIP collector Victor Salim objected and bid millions for her crooked-mustache fake instead! Sinta wasn\'t sure whether to sign autographs or put on the handcuffs.',
    ),
  ),
];
