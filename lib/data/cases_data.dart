import '../models/game_models.dart';

const List<DetectiveCase> kDetectiveCases = [
  DetectiveCase(
    id: 'case_01',
    code: 'CASE #01',
    imageAsset: 'case_01',
    isPremium: false,
    title: LocalizedText(
      id: 'Bangsal Melati Lantai 3 — RSUD Cempaka Lama',
      en: 'Melati Ward Floor 3 — Old Cempaka Hospital',
    ),
    subtitle: LocalizedText(
      id: 'Protagonis: Raka • Tragedi Ruang 304 (1998)',
      en: 'Protagonist: Raka • Room 304 Tragedy (1998)',
    ),
    synopsis: LocalizedText(
      id: 'RSUD Cempaka Lama terbengkalai sejak kebakaran arsip 1998. Malam ini Raka menelusuri Bangsal Melati Lantai 3 yang selalu berbau melati dan terdengar derit roda brankar tepat pukul 01:45.',
      en: 'Old Cempaka Hospital has stood abandoned since the 1998 archive fire. Tonight, Raka investigates Melati Ward Floor 3—where jasmine scent and creaking gurney wheels echo every night at 01:45.',
    ),
    stages: [
      CaseStage(
        id: 'c1_s1',
        order: 1,
        skill: BrainSkill.memory,
        difficulty: 1,
        location: LocalizedText(
          id: 'Kamar Mandi Ujung Bangsal',
          en: 'End-of-Hall Washroom',
        ),
        title: LocalizedText(
          id: 'Usap Cermin Berembun',
          en: 'Wipe the Fogged Mirror',
        ),
        briefing: LocalizedText(
          id: 'Cermin retak di sudut bangsal tertutup embun dingin yang aneh. Raka melihat goresan jari dari balik kabut—usap permukaannya perlahan, tapi waspadai sudut kaca.',
          en: 'A cracked washroom mirror is coated in freezing fog. Raka spots finger marks beneath the mist—wipe it clear, but watch the corner of the glass.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Udara di sini kering... dari mana datangnya embun setebal ini?"',
          en: 'Raka: "The air is bone dry... where is all this cold fog coming from?"',
        ),
        evidenceTitle: LocalizedText(
          id: 'Goresan Cermin: "304 — 01:45"',
          en: 'Mirror Etching: "304 — 01:45"',
        ),
        evidenceDetail: LocalizedText(
          id: 'Di balik embun cermin tergores jelas angka Ruang "304" dan waktu "01:45", tepat saat bayangan pucat sempat menampakkan diri di sudut kaca.',
          en: 'Beneath the fog, Room "304" and "01:45" were scratched into the glass—just as a pale shadow flickered in the corner.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Goresan itu bukan dibuat dari luar... bekas kuku membekas di sisi cermin yang sedingin es.',
          en: 'Those marks were made in desperation—leaving frost along the jagged edges.',
        ),
      ),
      CaseStage(
        id: 'c1_s2',
        order: 2,
        skill: BrainSkill.focus,
        difficulty: 1,
        location: LocalizedText(
          id: 'Meja Jaga Perawat Lantai 3',
          en: 'Floor-3 Nurses\' Station',
        ),
        title: LocalizedText(
          id: 'Selaraskan Pita Diktafon 1998',
          en: 'Tune the 1998 Dictaphone',
        ),
        briefing: LocalizedText(
          id: 'Di laci meja perawat tergeletak diktafon kaset tua berdebu. Pitanya masih berputar penuh derau statis—cari titik frekuensi yang tepat agar suara dokter jaga tahun 1998 terdengar jernih.',
          en: 'A dusty 1998 cassette dictaphone sits in the nurse\'s drawer. Its tape hisses with static—tune the frequency dial until the night doctor\'s voice clears.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Baterainya sudah berkarat, tapi kasetnya tetap berputar sendiri..."',
          en: 'Raka: "The batteries are corroded, yet the reels keep spinning on their own..."',
        ),
        evidenceTitle: LocalizedText(
          id: 'Rekaman Dokter Jaga (1998)',
          en: '1998 Night Doctor Recording',
        ),
        evidenceDetail: LocalizedText(
          id: 'Transkrip jernih di frekuensi 74 Hz: "Pukul 01:45... pasien Ruang 304 bukan kabur. Pintu isolasi sengaja disegel dari luar sebelum api menyambar berkas medis."',
          en: 'Clear transcript at 74 Hz: "01:45... the Room 304 patient didn\'t escape. Someone sealed the isolation door from outside before the fire hit the records."',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Di akhir rekaman terdengar suara kunci besi diputar paksa dan gedoran lemah dari dalam.',
          en: 'At the end of the tape, a heavy bolt slams shut—followed by faint knocking from within.',
        ),
      ),
      CaseStage(
        id: 'c1_s3',
        order: 3,
        skill: BrainSkill.logic,
        difficulty: 1,
        location: LocalizedText(
          id: 'Depan Pintu Besi Ruang 304',
          en: 'Room 304 Iron Door',
        ),
        title: LocalizedText(
          id: 'Susun Arah Sesajen',
          en: 'Align the Ritual Offerings',
        ),
        briefing: LocalizedText(
          id: 'Pintu Ruang 304 dikunci segel mistis dengan 3 tatakan tua (Utara, Tengah, Selatan). Susun Kendi Tanah Liat, Bunga Melati, dan Kemenyan sesuai catatan juru kunci untuk membuka segelnya.',
          en: 'Room 304 is bound by a mystical seal with 3 stone plates (North, Center, South). Arrange the Clay Jug, Jasmine, and Incense per the caretaker\'s note.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Bau kemenyan dan melati menyengat... segel ini sengaja dipasang untuk mengurung sesuatu."',
          en: 'Raka: "Heavy scent of incense and jasmine... someone placed this seal to keep something inside."',
        ),
        evidenceTitle: LocalizedText(
          id: 'Segel 304 Terbuka & Log Shift Robek',
          en: 'Seal Broken & Torn Shift Log',
        ),
        evidenceDetail: LocalizedText(
          id: 'Begitu sesajen tersusun tepat, segel pintu terbuka. Di lantai terselip halaman log shift malam 1998 yang menunjukkan dr. Hendro menggantikan shift pukul 01:00 seorang diri.',
          en: 'With the offerings aligned, the seal clicks open. Inside lies a torn 1998 shift log showing Dr. Hendro took over Floor 3 alone at 01:00.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Asap kemenyan mendadak mengalir masuk lewat celah bawah pintu Ruang 304.',
          en: 'The incense smoke suddenly rushes inward beneath the crack of Room 304\'s door.',
        ),
      ),
      CaseStage(
        id: 'c1_s4',
        order: 4,
        skill: BrainSkill.math,
        difficulty: 1,
        location: LocalizedText(
          id: 'Lorong Gelap Bangsal Melati',
          en: 'Dark Melati Corridor',
        ),
        title: LocalizedText(
          id: 'Tahan Napas Saat Brankar Lewat',
          en: 'Hold Your Breath',
        ),
        briefing: LocalizedText(
          id: 'Lampu darurat berkedip merah! Derit roda besi menggema mendekat dari ujung lorong. Sembunyi di balik tirai dan tahan napas selama 6 detik penuh sampai sosok pendorong brankar berlalu.',
          en: 'Emergency lights flash crimson! Squeaking metal wheels echo down the hall. Hide behind the curtain and hold your breath for 6 full seconds as the gurney passes.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Jangan bersuara... jangan berkedip... tunggu sampai rodanya lewat!"',
          en: 'Raka: "Don\'t make a sound... don\'t move... wait until the wheels pass!"',
        ),
        evidenceTitle: LocalizedText(
          id: 'Kartu Nama Jatuh dari Brankar',
          en: 'ID Tag Dropped by the Gurney',
        ),
        evidenceDetail: LocalizedText(
          id: 'Sosok gelap itu menghilang di tikungan, menjatuhkan kartu identitas dokter yang hangus sebagian: milik dr. Hendro Wirawan, penandatangan laporan palsu Ruang 304.',
          en: 'The shadow vanished around the bend, dropping a charred physician badge: Dr. Hendro Wirawan—the signer of the falsified Room 304 report.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Saat Raka mengembuskan napas, roda brankar berhenti mendadak tepat di ujung lorong yang kosong.',
          en: 'The moment Raka exhaled, the creaking stopped dead in an empty hallway.',
        ),
      ),
    ],
    suspects: [
      Suspect(
        id: 'c1_sus_1',
        name: 'Suster Ratih',
        initials: 'SR',
        avatarEmoji: '🩺',
        role: LocalizedText(id: 'Perawat Jaga Malam 1998', en: '1998 Night Nurse'),
        alibi: LocalizedText(
          id: 'Merawat pasien Ruang 304 sejak sore, namun tercatat dipindah mendadak ke IGD lantai 1 pukul 00:30 atas perintah dokter senior.',
          en: 'Cared for the Room 304 patient earlier, but was abruptly reassigned to the 1st-floor ER at 00:30 by the senior doctor.',
        ),
        funnyNote: LocalizedText(
          id: 'Ia meninggalkan catatan kecil: "Pasien 304 sangat lemah, jangan pernah tinggalkan pintu terkunci."',
          en: 'Left a hurried note: "Patient 304 is too weak—never leave the isolation door latched."',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c1_sus_2',
        name: 'dr. Hendro Wirawan',
        initials: 'HW',
        avatarEmoji: '🩻',
        role: LocalizedText(id: 'Dokter Jaga Senior 1998', en: '1998 Senior Night Doctor'),
        alibi: LocalizedText(
          id: 'Mengambil alih Bangsal Melati seorang diri pukul 01:00. Kartu identitas hangusnya jatuh dari sosok brankar, dan tanda tangannya tertera pada laporan palsu 01:45.',
          en: 'Took over Melati Ward alone at 01:00. His charred ID badge dropped from the gurney, and his signature is on the falsified 01:45 report.',
        ),
        funnyNote: LocalizedText(
          id: 'Menutup kasus malapraktik dengan menyegel Ruang 304 dari luar sebelum kebakaran arsip dimulai.',
          en: 'Covered up a fatal malpractice error by bolting Room 304 from outside before the archive fire.',
        ),
        isCulprit: true,
      ),
      Suspect(
        id: 'c1_sus_3',
        name: 'Mbah Karto',
        initials: 'MK',
        avatarEmoji: '🕯️',
        role: LocalizedText(id: 'Juru Kunci RSUD Lama', en: 'Old Hospital Caretaker'),
        alibi: LocalizedText(
          id: 'Baru memasang sesajen di depan Ruang 304 bertahun-tahun setelah RS ditutup agar arwah di lantai 3 tidak turun mengganggu warga sekitar.',
          en: 'Only placed the offerings outside Room 304 years after closure to keep the 3rd-floor unrest from spreading.',
        ),
        funnyNote: LocalizedText(
          id: 'Justru dialah yang meninggalkan catatan arah sesajen untuk siapa pun yang berani mengungkap kebenaran.',
          en: 'He left the directional ritual clues for whoever dared uncover what truly happened.',
        ),
        isCulprit: false,
      ),
    ],
    deductionPrompt: LocalizedText(
      id: 'Semua bukti di Bangsal Melati Lantai 3 telah terkumpul. Siapa yang sebenarnya menyegel Ruang 304 pada pukul 01:45 tahun 1998?',
      en: 'All clues on Melati Ward Floor 3 are assembled. Who truly sealed Room 304 at 01:45 in 1998?',
    ),
    twistTitle: LocalizedText(
      id: 'PLOT TWIST: Harta Gelap di Balik Tembok Ruang 304!',
      en: 'PLOT TWIST: Stolen Hoard Behind Room 304\'s Wall!',
    ),
    twistCaption: LocalizedText(
      id: 'Arwah suster itu ternyata bukan meneror Raka — ia menuntun Raka menangkap basah pelaku yang membongkar tembok penuh uang & emas!',
      en: 'The nurse\'s spirit wasn\'t haunting Raka — she guided him straight to catch the culprit raiding cash and gold behind the brick wall!',
    ),
    resolution: LocalizedText(
      id: 'Terbongkar tuntas! dr. Hendro Wirawan (yang tertangkap basah berbaju batik sambil memegang linggis!) menyegel Ruang 304 sejak 1998 dan menyebarkan teror angker demi menyembunyikan dana gelap rumah sakit serta batangan emas di balik tembok bata. Sosok suster di cermin dan lorong ternyata selama ini menuntun Raka agar kejahatan 1998 akhirnya terungkap!',
      en: 'Exposed at last! Dr. Hendro Wirawan (caught red-handed in his batik shirt holding a crowbar!) had sealed Room 304 since 1998 and fueled ghost rumors to stash embezzled hospital funds and gold bars behind the brick wall. The nurse\'s spirit had been guiding Raka all along to reveal the truth!',
    ),
  ),
  DetectiveCase(
    id: 'case_02',
    code: 'CASE #02',
    imageAsset: 'case_02',
    isPremium: false,
    title: LocalizedText(
      id: 'Pabrik Gula Tua Kalirejo — Ruang Ketel Uap',
      en: 'Old Kalirejo Sugar Mill — The Boiler Chamber',
    ),
    subtitle: LocalizedText(
      id: 'Protagonis: Raka • Tungku yang Menyala Sendiri',
      en: 'Protagonist: Raka • The Self-Igniting Furnace',
    ),
    synopsis: LocalizedText(
      id: 'Pabrik gula peninggalan kolonial di Kalirejo telah mati puluhan tahun, namun setiap tengah malam tungku ketelnya menyala merah dan roda gigi berputar sendiri. Raka menyusup untuk mengungkap misteri ruang bawah tanahnya.',
      en: 'Kalirejo\'s abandoned colonial sugar mill has stood dead for decades, yet every midnight its boiler furnace glows red and giant gears groan. Raka sneaks inside to uncover what hides below.',
    ),
    stages: [
      CaseStage(
        id: 'c2_s1',
        order: 1,
        skill: BrainSkill.memory,
        difficulty: 2,
        location: LocalizedText(id: 'Ruang Pengukur Tekanan Uap', en: 'Steam Gauge Chamber'),
        title: LocalizedText(id: 'Usap Pelat Besi & Kaca Uap', en: 'Wipe the Sooty Boiler Plate'),
        briefing: LocalizedText(
          id: 'Pelat kuningan di pintu ketel tertutup jelaga hitam pekat, sementara kaca pengukur tekanan berembun dingin. Usap permukaannya untuk menyingkap goresan kode tersembunyi!',
          en: 'Thick black soot coats the brass boiler plaque while cold mist fogs the steam gauge. Wipe it clean to uncover the hidden tally marks!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Ada bekas telapak tangan dari dalam kaca pengukur uap... padahal pipanya sudah mati puluhan tahun."',
          en: 'Raka: "There\'s a handprint pressing from inside the pressure gauge... yet these pipes died decades ago."',
        ),
        evidenceTitle: LocalizedText(id: 'Goresan Sandi Ruang Ketel', en: 'Etched Boiler Tally Code'),
        evidenceDetail: LocalizedText(
          id: 'Di balik jelaga ditemukan tanda hitungan pengiriman peti dan jam pengoperasian tungku secara diam-diam setiap pukul 01:45.',
          en: 'Beneath the soot lie fresh crate tally marks and a secret furnace schedule running every night at 01:45.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Jarum pengukur tekanan bergetar pelan seolah ada yang meniupnya dari dalam pipa.',
          en: 'The pressure needle twitched gently as if breathed upon from inside the pipe.',
        ),
      ),
      CaseStage(
        id: 'c2_s2',
        order: 2,
        skill: BrainSkill.focus,
        difficulty: 2,
        location: LocalizedText(id: 'Ruang Kontrol Radio Pabrik', en: 'Mill Radio Control Room'),
        title: LocalizedText(id: 'Selaraskan Radio Pengawas Tua', en: 'Tune the Old Mill Radio'),
        briefing: LocalizedText(
          id: 'Radio komunikasi kolonial di meja pengawas masih memancarkan sinyal desis aneh. Putar frekuensinya sampai suara percakapan rahasia di ruang ketel terdengar jernih.',
          en: 'The vintage mill radio still crackles with eerie static. Tune its dial until the hidden conversation from the boiler room comes through clearly.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Bayangan di luar jendela itu muncul bersamaan dengan gelombang suaranya..."',
          en: 'Raka: "Those shadows outside the cracked window appeared the moment the signal spiked..."',
        ),
        evidenceTitle: LocalizedText(id: 'Siaran Pengiriman Peti Pusaka', en: 'Smuggler Crate Broadcast'),
        evidenceDetail: LocalizedText(
          id: 'Frekuensi yang jernih menangkap koordinasi pengangkutan peti kayu berisi benda pusaka curian lewat pintu bawah tanah pabrik.',
          en: 'The cleared signal captures smugglers coordinating stolen antique heirloom crates through the mill\'s basement tunnel.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Di balik percakapan manusia, terdengar suara batuk berat seorang mandor tua.',
          en: 'Beneath the smugglers\' voices, an old factory foreman\'s heavy cough echoed over the static.',
        ),
      ),
      CaseStage(
        id: 'c2_s3',
        order: 3,
        skill: BrainSkill.logic,
        difficulty: 2,
        location: LocalizedText(id: 'Pintu Besi Rantai Beraksara', en: 'Chained Iron Boiler Door'),
        title: LocalizedText(id: 'Susun Sesajen Pembuka Segel', en: 'Align the Seal Offerings'),
        briefing: LocalizedText(
          id: 'Pintu besi ruang ketel digembok rantai berat dengan aksara merah menyala. Susun Kendi, Melati, dan Kemenyan di nampan sesajen sesuai petunjuk arah agar segelnya melunak.',
          en: 'Heavy iron chains and glowing red runes seal the boiler door. Arrange the Clay Jug, Jasmine, and Incense on the offering tray to break the ward.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Bukan cuma rantai besi... seseorang sengaja memasang segel agar warga takut mendekat."',
          en: 'Raka: "Not just iron chains... someone used local dread to keep everyone away from this door."',
        ),
        evidenceTitle: LocalizedText(id: 'Segel Rantai Terbuka', en: 'Chained Boiler Seal Broken'),
        evidenceDetail: LocalizedText(
          id: 'Asap dupa memudarkan aksara merah; gembok tua ternyata baru saja dilumasi oli segar—artinya ruangan ini rutin dibuka manusia!',
          en: 'Incense smoke dimmed the red runes—revealing fresh oil on the padlock, proving living people open this door regularly!',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Gembok karatan itu berbunyi klik tanpa paksaan begitu dupa melengkung masuk.',
          en: 'The rusted padlock clicked open on its own as incense drifted inside.',
        ),
      ),
      CaseStage(
        id: 'c2_s4',
        order: 4,
        skill: BrainSkill.math,
        difficulty: 2,
        location: LocalizedText(id: 'Jembatan Besi & Roda Gigi Raksasa', en: 'Catwalk & Giant Gears'),
        title: LocalizedText(id: 'Tahan Napas di Balik Roda Gigi', en: 'Hold Breath Behind the Gears'),
        briefing: LocalizedText(
          id: 'Tungku api menyala terang di bawah jembatan! Sosok berkerudung melintas membawa peti kayu berat—bekap mulutmu dan tahan napas 6 detik penuh di balik roda gigi raksasa!',
          en: 'The furnace blazes below the catwalk! A hooded figure crosses carrying a heavy wooden crate—cover your mouth and hold your breath for 6 full seconds!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Jangan bersuara... kalau dia menoleh ke roda gigi ini, aku tamat!"',
          en: 'Raka: "Not a sound... if they glance behind these gears, I\'m trapped!"',
        ),
        evidenceTitle: LocalizedText(id: 'Jalur Gudang Rahasia Bawah Tanah', en: 'Secret Basement Vault Trail'),
        evidenceDetail: LocalizedText(
          id: 'Raka melacak langkah sosok berkerudung menuju ruang teralis besi tempat tumpukan peti pusaka curian disimpan.',
          en: 'Raka tracked the hooded figure straight to the barred vault chamber storing the stolen heirloom crates.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Bara tungku mendadak padam tepat ketika langkah kaki itu menghilang ke lorong teralis.',
          en: 'The furnace embers died down the instant the footsteps entered the barred tunnel.',
        ),
      ),
    ],
    suspects: [
      Suspect(
        id: 'c2_sus_1',
        name: 'Mandor Slamet',
        initials: 'MS',
        avatarEmoji: '👻',
        role: LocalizedText(id: 'Arwah Mandor Pabrik Tua', en: 'Ghost of the Old Mill Foreman'),
        alibi: LocalizedText(
          id: 'Mantan mandor ruang ketel uap yang meninggal saat pabrik tutup. Sering menampakkan diri di kaca pengukur uap untuk memperingatkan penyusup.',
          en: 'Former boiler foreman who passed away when the mill closed. Appears in the steam gauge to warn outsiders.',
        ),
        funnyNote: LocalizedText(
          id: 'Ia bukan pencuri—justru ia murka karena pabrik tuanya dijadikan sarang penyelundup.',
          en: 'Not the villain—he\'s furious his old mill is being used as a smugglers\' den.',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c2_sus_2',
        name: 'Pak Danu & Komplotannya',
        initials: 'PD',
        avatarEmoji: '🗡️',
        role: LocalizedText(id: 'Sindikat Penyelundup Pusaka', en: 'Antique Heirloom Smugglers'),
        alibi: LocalizedText(
          id: 'Memakai pelumas baru pada gembok rantai, menyalakan tungku untuk menakuti warga, dan mengangkut peti kayu penuh keris serta mahkota emas curian lewat jembatan roda gigi.',
          en: 'Oiled the chained padlock, lit the furnace to scare locals off, and hauled crates of stolen keris and gold crowns across the catwalk.',
        ),
        funnyNote: LocalizedText(
          id: 'Menyamar memakai jubah berkerudung agar dikira hantu pabrik saat mengangkut peti tengah malam.',
          en: 'Wore dark hoods at midnight hoping locals would mistake them for factory ghosts.',
        ),
        isCulprit: true,
      ),
      Suspect(
        id: 'c2_sus_3',
        name: 'Mbah Wiryo',
        initials: 'MW',
        avatarEmoji: '🏮',
        role: LocalizedText(id: 'Penjaga Gerbang Luar', en: 'Outer Gate Watchman'),
        alibi: LocalizedText(
          id: 'Hanya berjaga di pos gerbang luar desa dan tidak pernah turun ke ruang ketel uap sejak 20 tahun lalu.',
          en: 'Only watches the village outer gate and hasn\'t stepped into the boiler basement in 20 years.',
        ),
        funnyNote: LocalizedText(
          id: 'Dialah yang memberi tahu Raka soal nyala api aneh di cerobong pabrik setiap pukul 01:45.',
          en: 'He tipped Raka off about the mysterious 01:45 furnace smoke.',
        ),
        isCulprit: false,
      ),
    ],
    deductionPrompt: LocalizedText(
      id: 'Semua bukti di Pabrik Gula Kalirejo sudah di tangan. Siapa dalang sebenarnya di balik nyala tungku dan peti-peti misterius di ruang ketel?',
      en: 'All clues inside Kalirejo Sugar Mill are gathered. Who is truly behind the glowing furnace and midnight crates?',
    ),
    twistTitle: LocalizedText(
      id: 'PLOT TWIST: Arwah Mandor Mengunci Para Penyelundup!',
      en: 'PLOT TWIST: The Foreman\'s Ghost Traps the Smugglers!',
    ),
    twistCaption: LocalizedText(
      id: 'Saat Raka menyorot dua penyelundup di depan peti penuh keris & emas curian, arwah Mandor Slamet menarik tuas gerbang besi agar mereka tak bisa kabur!',
      en: 'As Raka catches the two smugglers beside crates of stolen keris & gold, Foreman Slamet\'s ghost pulls the iron gate lever to lock them in!',
    ),
    resolution: LocalizedText(
      id: 'Skakmat! Pak Danu dan rekannya (yang membawa linggis!) tertangkap basah menimbun peti keris dan pusaka emas curian di ruang bawah tanah pabrik. Tepat saat mereka hendak kabur, arwah Mandor Slamet muncul di balik teralis dan menarik tuas pengunci pintu besi—membantu Raka meringkus sindikat penyelundup hingga tuntas!',
      en: 'Checkmate! Danu and his accomplice were caught red-handed stashing crates of stolen antique keris and golden heirlooms inside the basement. Just as they tried to bolt, Foreman Slamet\'s spirit appeared by the bars and pulled the iron gate lever—locking them in for Raka!',
    ),
  ),
  DetectiveCase(
    id: 'case_03',
    code: 'CASE #03',
    imageAsset: 'case_03',
    isPremium: true,
    title: LocalizedText(
      id: 'Vila Pinus Berkabut — Bayangan Kebaya Putih',
      en: 'Misty Pine Villa — The White Kebaya Shadow',
    ),
    subtitle: LocalizedText(
      id: 'Arsip Pro • Hutan Pinus & Gudang Bawah Tanah',
      en: 'Pro File • Pine Forest & Underground Cellar',
    ),
    synopsis: LocalizedText(
      id: 'Vila kolonial di tengah hutan pinus berkabut telah lama ditinggalkan sejak wafatnya Nyonya Rahayu. Warga ketakutan karena sosok berkebaya putih sering tampak di balik pintu kaca dan suara gramofon berputar sendiri saat badai.',
      en: 'An old colonial villa deep in the misty pine forest has stood empty since Lady Rahayu passed away. Locals whisper of a figure in a white kebaya behind the glass doors and an antique gramophone playing during storms.',
    ),
    stages: [
      CaseStage(
        id: 'c3_s1',
        order: 1,
        skill: BrainSkill.memory,
        difficulty: 3,
        location: LocalizedText(id: 'Kamar Utama Vila Pinus', en: 'Master Bedroom Mirror'),
        title: LocalizedText(id: 'Usap Cermin Bingkai Emas', en: 'Wipe the Gilded Mirror'),
        briefing: LocalizedText(
          id: 'Cermin antik berbingkai emas di kamar utama tertutup embun dingin. Usap permukaannya untuk membaca tanda hitungan tersembunyi—meski bayangan berkebaya putih menatap tenang dari belakangmu.',
          en: 'Cold mist coats the antique gold-framed bedroom mirror. Wipe it clear to read the hidden tally marks—while a woman in a white kebaya watches quietly behind you.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Tatapannya tidak mengancam... seolah dia ingin aku segera memeriksa sesuatu di vila ini."',
          en: 'Raka: "Her gaze isn\'t hostile... it feels like she\'s urging me to find something in this house."',
        ),
        evidenceTitle: LocalizedText(id: 'Goresan Tanggal Wasiat', en: 'Etched Will Countdown'),
        evidenceDetail: LocalizedText(
          id: 'Di balik embun cermin tergores hitungan hari menuju malam pembongkaran brankas bawah tanah vila.',
          en: 'Beneath the frost lie tally marks counting down to tonight\'s break-in at the basement safe.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Bayangan Nyonya berkebaya putih mengangguk pelan sebelum memudar di balik kaca retak.',
          en: 'The lady in the white kebaya gave a faint nod before fading into the cracked glass.',
        ),
      ),
      CaseStage(
        id: 'c3_s2',
        order: 2,
        skill: BrainSkill.focus,
        difficulty: 3,
        location: LocalizedText(id: 'Ruang Baca & Gramofon Antik', en: 'Study & Antique Gramophone'),
        title: LocalizedText(id: 'Selaraskan Suara Gramofon Tua', en: 'Tune the Antique Gramophone'),
        briefing: LocalizedText(
          id: 'Gramofon kuningan di ruang baca berputar sendiri mengeluarkan desis kabut. Cari titik frekuensi yang jernih untuk mendengar rekaman pesan terakhir Nyonya Rahayu.',
          en: 'The brass gramophone spins on its own, hissing into the mist. Tune the exact frequency to hear Lady Rahayu\'s recorded message.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Asap dingin keluar dari corong kuningan ini... tapi suaranya mulai terdengar jelas!"',
          en: 'Raka: "Cold mist is curling out of this brass horn... wait, a voice is coming through!"',
        ),
        evidenceTitle: LocalizedText(id: 'Rekaman Wasiat Warisan', en: 'Recorded Inheritance Warning'),
        evidenceDetail: LocalizedText(
          id: 'Rekaman mengungkap brankas perhiasan emas & pusaka keluarga sengaja diincar kerabat dekat yang menyebarkan isu vila berhantu.',
          en: 'The recording warns that a greedy relative spread ghost rumors to raid the family gold vault undisturbed.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Jarum gramofon terangkat sendiri begitu kalimat terakhir selesai diputar.',
          en: 'The brass needle lifted off the vinyl on its own the moment the final sentence ended.',
        ),
      ),
      CaseStage(
        id: 'c3_s3',
        order: 3,
        skill: BrainSkill.logic,
        difficulty: 3,
        location: LocalizedText(id: 'Pintu Jati Gudang Bawah Tanah', en: 'Carved Teak Cellar Door'),
        title: LocalizedText(id: 'Susun Sesajen Pintu Jati', en: 'Align the Cellar Offerings'),
        briefing: LocalizedText(
          id: 'Pintu kayu jati berukir menuju gudang bawah tanah terkunci gembok tua & segel aksara merah. Susun Kendi, Melati, dan Kemenyan di nampan sesajen untuk membuka jalannya.',
          en: 'The carved teak cellar door is locked with an old padlock and glowing red runes. Arrange the Clay Jug, Jasmine, and Incense on the tray to open it.',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Kabut hutan pinus makin pekat, tapi gembok pintu jati ini sudah mulai bergetar..."',
          en: 'Raka: "The pine-forest fog is thickening, and this heavy padlock is starting to give way..."',
        ),
        evidenceTitle: LocalizedText(id: 'Akses Gudang Bawah Tanah Terbuka', en: 'Underground Cellar Unlocked'),
        evidenceDetail: LocalizedText(
          id: 'Pintu jati terbuka memperlihatkan jejak sepatu berlumpur baru menuju ruang brankas di bawah vila.',
          en: 'The teak door opens to fresh muddy boot prints leading straight toward the basement vault.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Aroma melati segar menyambut Raka dari tangga batu menuju ruang bawah tanah.',
          en: 'A wave of fresh jasmine scent greeted Raka from the stone cellar stairs.',
        ),
      ),
      CaseStage(
        id: 'c3_s4',
        order: 4,
        skill: BrainSkill.math,
        difficulty: 3,
        location: LocalizedText(id: 'Lorong Jendela Badai Petir', en: 'Storm-Lit Hallway'),
        title: LocalizedText(id: 'Tahan Napas di Balik Tirai', en: 'Hold Breath Behind the Curtains'),
        briefing: LocalizedText(
          id: 'Petir menyambar di jendela besar! Sosok berkerudung menenteng tas kulit melintas masuk lorong—bekap mulutmu dan tahan napas 6 detik penuh di balik tirai robek!',
          en: 'Lightning splits the tall hallway window! A hooded intruder carrying a leather bag creeps inside—cover your mouth and hold your breath for 6 full seconds!',
        ),
        detectiveQuip: LocalizedText(
          id: 'Raka: "Itu bukan hantu... langkah sepatunya berat, dia bawa tas besar buat menguras brankas!"',
          en: 'Raka: "That\'s no ghost... heavy boots, carrying a duffel bag to empty the vault!"',
        ),
        evidenceTitle: LocalizedText(id: 'Jejak Tas & Linggis Menuju Brankas', en: 'Duffel & Crowbar Trail to Safe'),
        evidenceDetail: LocalizedText(
          id: 'Sosok berkerudung masuk langsung ke gudang anggur bawah tanah tempat brankas besi warisan disimpan.',
          en: 'The hooded intruder headed straight into the wine cellar where the iron heirloom safe sits.',
        ),
        evidenceFunnyCaption: LocalizedText(
          id: 'Suara besi dicongkel terdengar nyaring dari balik pintu gudang bawah tanah.',
          en: 'The sharp scrape of a crowbar pried through the silence of the cellar.',
        ),
      ),
    ],
    suspects: [
      Suspect(
        id: 'c3_sus_1',
        name: 'Arwah Nyonya Rahayu',
        initials: 'NR',
        avatarEmoji: '👻',
        role: LocalizedText(id: 'Pemilik Lama Vila Pinus', en: 'Late Owner of Pine Villa'),
        alibi: LocalizedText(
          id: 'Sosok berkebaya putih yang tampak di pintu kaca dan cermin. Tidak pernah melukai siapa pun—justru menuntun Raka menemukan rekaman gramofon & brankas.',
          en: 'The figure in white kebaya seen in the doorway and mirror. Never harmed anyone—she guided Raka to the gramophone and vault.',
        ),
        funnyNote: LocalizedText(
          id: 'Ia hanya ingin harta pusaka keluarganya tidak jatuh ke tangan kerabat yang serakah.',
          en: 'She only wanted to protect her family heirlooms from a greedy relative.',
        ),
        isCulprit: false,
      ),
      Suspect(
        id: 'c3_sus_2',
        name: 'Pak Prapto',
        initials: 'PP',
        avatarEmoji: '🗝️',
        role: LocalizedText(id: 'Kerabat & Pengurus Vila', en: 'Relative & Villa Caretaker'),
        alibi: LocalizedText(
          id: 'Menyebarkan cerita angker agar ahli waris lain takut datang, lalu menyusup saat badai membawa tas kulit dan linggis untuk membobol brankas emas.',
          en: 'Spread ghost stories to scare away other heirs, then snuck in during the storm with a duffel bag and crowbar to loot the gold safe.',
        ),
        funnyNote: LocalizedText(
          id: 'Tertangkap basah memakai baju batik sambil mencongkel brankas berisi kalung mutiara & emas!',
          en: 'Caught red-handed in his batik shirt prying open the vault of pearls and gold!',
        ),
        isCulprit: true,
      ),
      Suspect(
        id: 'c3_sus_3',
        name: 'Bi Minah',
        initials: 'BM',
        avatarEmoji: '🕯️',
        role: LocalizedText(id: 'Mantan Pengurus Rumah', en: 'Former Housekeeper'),
        alibi: LocalizedText(
          id: 'Sudah tinggal di desa bawah sejak vila ditutup dan justru menyerahkan catatan arah sesajen pintu jati kepada Raka.',
          en: 'Moved to the lower village after closure and gave Raka the cellar offering notes to save the estate.',
        ),
        funnyNote: LocalizedText(
          id: 'Mengingatkan Raka bahwa Nyonya Rahayu selalu baik hati kepada orang jujur.',
          en: 'Reminded Raka that Lady Rahayu was always kind to honest souls.',
        ),
        isCulprit: false,
      ),
    ],
    deductionPrompt: LocalizedText(
      id: 'Lampu senter Raka mengarah ke pintu gudang bawah tanah. Siapa dalang sebenarnya yang memanfaatkan teror Vila Pinus?',
      en: 'Raka\'s flashlight points at the cellar vault door. Who truly exploited the Pine Villa hauntings?',
    ),
    twistTitle: LocalizedText(
      id: 'PLOT TWIST: Nyonya Kebaya Putih Menjaga Brankas Warisan!',
      en: 'PLOT TWIST: The White Kebaya Lady Guarded the Vault!',
    ),
    twistCaption: LocalizedText(
      id: 'Pak Prapto tertangkap basah mencongkel brankas emas dengan linggis — sementara Nyonya Rahayu tersenyum tenang membukakan pintu untuk Raka!',
      en: 'Prapto is caught red-handed prying open the gold safe — while Lady Rahayu smiles serenely holding the cellar door open for Raka!',
    ),
    resolution: LocalizedText(
      id: 'Terungkap sempurna! Pak Prapto sengaja menakuti warga dengan rumor vila angker demi menguras brankas emas dan pusaka keluarga di ruang bawah tanah. Saat senter Raka menyergapnya yang masih memegang linggis, arwah Nyonya Rahayu berdiri tenang di ambang pintu dengan senyum lega—akhirnya warisan keluarganya aman!',
      en: 'Case closed! Prapto spread haunting rumors to raid the family gold and heirloom vault undisturbed. As Raka\'s flashlight catches him crowbar in hand, Lady Rahayu\'s spirit stands peacefully in the doorway with a relieved smile—her family legacy is safe at last!',
    ),
  ),
];
