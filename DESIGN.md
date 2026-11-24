# MindCase — Detective Brain Training (MVP Blueprint)

## Konsep Produk
- **Target Audiens:** Dewasa / umum (18–50+ tahun)
- **Genre:** Story-Driven Brain Training (*Micro-Narrative Detective Mystery*)
- **Bahasa:** Bilingual — Indonesia (`id`) & English (`en`) sejak awal
- **Mode:** 100% Offline Gameplay (progres disimpan lokal via `SharedPreferences`)
- **Rencana Monetisasi Play Store:** Hybrid Freemium
  - Kasus #01 & #02 + Mode Latihan Harian gratis penuh tanpa iklan paksa.
  - Kasus #03+ dibuka via **Detective Pass** (sekali bayar / *One-Time IAP* via `in_app_purchase`).
  - Opsional: *Rewarded Hint* jika sedang online (tanpa iklan *interstitial* paksa).

## 4 Pilar Latihan Otak (Mini-Games)
1. **Memori TKP (*Scene Recall*):** Mengingat pola grid bukti yang menyala sekilas (melatih memori spasial & kerja).
2. **Saring Kesaksian (*Testimony Filter*):** *Stroop Test* — pilih warna tinta, bukan arti kata (melatih fokus & kontrol kognitif).
3. **Pecah Sandi (*Vault Cipher*):** Mengenali pola deret & logika angka (melatih penalaran logis).
4. **Audit Angka (*Ledger Audit*):** Aritmetika cepat & angka hilang (melatih kecepatan proses & berhitung).

## Struktur Folder Kode
- `lib/theme/` — Tema *Modern Noir* (warna, tipografi, style kartu)
- `lib/l10n/` — Kamus 2 bahasa (`id` / `en`)
- `lib/models/` — Model kasus, stage, tersangka, progres pemain
- `lib/data/` — Data cerita kasus bilingual (siap dipindah ke JSON aset)
- `lib/services/` — Penyimpanan offline & logika progres/streak
- `lib/games/` — 4 mini-game latih otak prosedural
- `lib/screens/` — Beranda, Papan Kasus, Briefing, Deduksi Akhir, Latihan, Profil Otak (Radar Chart)
- `lib/widgets/` — Radar Chart & komponen UI bersama

## Roadmap Menuju Rilis Google Play Store
1. [x] MVP offline 2 bahasa + 3 kasus + 4 mini-game + Radar Chart + simulasi Detective Pass
2. [ ] Tambahkan efek suara ringan (`audioplayers`) & toggle SFX/Haptic di pengaturan
3. [ ] Integrasi `in_app_purchase` (Google Play Billing) untuk membuka Detective Pass
4. [ ] Tambah kasus baru (Kasus #04–#10) berbasis JSON eksternal di `assets/cases/`
5. [ ] Siapkan Adaptive Icon, Splash Screen, Privacy Policy, dan Play Store Listing (ID & EN)
