# Problem 01 — Izin Pengiriman Data

Level: **Warm-up · logic reasoning**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Sebuah blok pengirim menerima permintaan untuk meneruskan data. Pengiriman biasa memerlukan link yang siap, sedangkan mode lokal boleh berjalan tanpa link. Satu signal pemblokiran berlaku untuk kedua mode.

Tugasmu hanya menghasilkan keputusan izin pada saat input diamati. Blok ini tidak mengirim bit data dan tidak mengingat permintaan sebelumnya.

## 2. Specification

- Permintaan berasal dari `request`.
- `link_ready` menyatakan link biasa siap dipakai.
- `local_mode` menyatakan pengiriman menggunakan jalur lokal. Mode ini membebaskan syarat kesiapan link.
- `blocked` menyatakan seluruh pengiriman sedang dilarang.
- `send_allowed` menyatakan permintaan saat ini boleh dijalankan.

Semua signal active-high: nilai `1` menyatakan kondisi yang disebut namanya sedang berlaku.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `request` | 1 | Ada permintaan pengiriman saat ini |
| Input | `link_ready` | 1 | Link biasa siap |
| Input | `local_mode` | 1 | Pengiriman menggunakan mode lokal |
| Input | `blocked` | 1 | Larangan pengiriman untuk seluruh mode |
| Output | `send_allowed` | 1 | Permintaan saat ini mendapat izin |

## 4. Behavioral Requirements

1. Selama `blocked` bernilai `1`, izin selalu tidak aktif, apa pun input lain.
2. Tanpa permintaan, izin selalu tidak aktif, termasuk ketika mode lokal aktif.
3. Jika ada permintaan dan tidak diblokir, mode lokal boleh berjalan pada kedua nilai `link_ready`.
4. Jika ada permintaan, tidak diblokir, dan mode lokal tidak aktif, izin mengikuti kesiapan link.
5. Output tidak mempertahankan izin dari kondisi input sebelumnya.

## 5. Engineering Questions — Before Coding

1. Apa perbedaan antara adanya permintaan dan adanya izin?
2. Input mana yang dapat membatalkan izin pada kedua mode? Jelaskan dari spesifikasi.
3. Apakah mode lokal merupakan permintaan tersendiri? Apa akibat penafsiranmu?
4. Berapa kombinasi input yang mungkin, dan apakah semua dapat diuji?
5. Hardware apa yang kamu prediksi diperlukan? Turunkan alasanmu dari perilaku, bukan dari syntax.
6. Apakah keputusan memerlukan informasi dari waktu sebelumnya? Jelaskan.

## 6. Prediction Cases

Prediksi `send_allowed` untuk setiap baris. Kolom di bawah hanya berisi input.

| Case | `request` | `link_ready` | `local_mode` | `blocked` |
|---|---:|---:|---:|---:|
| 1 | 0 | 1 | 1 | 0 |
| 2 | 1 | 0 | 0 | 0 |
| 3 | 1 | 1 | 0 | 0 |
| 4 | 1 | 0 | 1 | 0 |
| 5 | 1 | 1 | 1 | 1 |
| 6 | 1 | 0 | 1 | 1 |

## 7. Architecture Task

Gambar sketsa hardware yang menurutmu menghasilkan keputusan izin. Tulis arti setiap hubungan dalam sketsa. Bentuk gambar bebas; kamu belum harus memakai simbol gate yang rapi.

## 8. RTL Requirements

- Seluruh RTL adalah **combinational logic**: output hanya bergantung pada input saat ini.
- Gunakan materi sampai Modules: module, ports, wire, continuous assignment, operators yang sudah dipelajari, vector, bit-select, part-select tetap, concatenation, replication, dan module instantiation.
- Tidak memakai `always`, `always_comb`, `always_ff`, procedural assignment, `if`, `case`, `for`, `generate`, function, atau task pada RTL.
- Tidak memakai latch, flip-flop, register sequential, clock, reset sequential, counter, FSM, memory, atau feedback yang membentuk state.
- Deklarasikan signal dan width secara eksplisit. Gunakan data unsigned dan literal dengan ukuran yang sesuai.
- Setiap output harus mempunyai nilai yang ditentukan untuk seluruh kombinasi input; tidak ada output yang dibiarkan mempertahankan nilai sebelumnya.
- Gunakan satu penggerak yang jelas untuk setiap bit signal internal dan output.
- Semua prediction dan verification fungsional dalam soal mengasumsikan input stabil bernilai `0` atau `1`; penanganan `X`, `Z`, dan glitch fisik berada di luar kontrak ini.
- Batas RTL di atas berlaku pada DUT (*design under test*, rangkaian yang diuji). Testbench adalah lingkungan simulation terpisah; paket ini menyediakan target pengujiannya tanpa kode stimulus atau jawabannya.

## 9. Verification Targets

- Uji seluruh 16 kombinasi input.
- Pastikan larangan tetap berlaku pada mode lokal.
- Pastikan kesiapan link saja tidak menciptakan permintaan.
- Ubah input dari kondisi berizin ke tidak berizin, lalu kembali lagi; periksa bahwa output selalu sesuai input saat ini.
- Di waveform, beri anotasi minimal satu contoh pengaruh setiap input.

## 10. Synthesis Questions

1. Apakah fungsi hardware hasil synthesis sesuai dengan sketsamu?
2. Jika susunan atau jumlah logic berbeda, apakah perilakunya tetap sama?
3. Adakah input yang secara keliru tidak berpengaruh sama sekali karena kesalahan RTL?
4. Apakah laporan menunjukkan elemen penyimpan? Bagaimana kaitannya dengan kebutuhan soal?

## 11. Definition of Done

- [ ] Saya memahami specification dan dapat menjelaskan arti seluruh input-output.
- [ ] Saya sudah menjawab seluruh engineering questions **sebelum coding**.
- [ ] Saya sudah menggambar atau menjelaskan architecture serta hardware prediction sebelum RTL.
- [ ] Saya sudah mengisi seluruh prediction case secara manual sebelum simulation.
- [ ] Saya menulis RTL sendiri dan dapat menjelaskan hubungan antara kode dengan hardware.
- [ ] Saya sudah menulis testbench dan mencatat secara jujur bagian yang masih memerlukan bantuan.
- [ ] Semua prediction case dan verification target sudah diuji; perbedaan prediction dan hasil sudah dijelaskan serta kesalahan RTL sudah diperbaiki.
- [ ] Saya sudah membaca waveform dan mengamati hubungan input-output pada kasus yang bermakna.
- [ ] Saya sudah menjalankan synthesis pada RTL, memeriksa diagnostic, serta memastikan tidak ada penyimpanan yang tidak diminta.
- [ ] Saya membandingkan hasil synthesis dengan prediction dan mencatat perubahan akibat optimasi yang saya pahami.
- [ ] Saya dapat menjelaskan fungsi circuit tanpa melihat kode.
