# Problem 02 — Status Dua Permintaan Independen

Level: **Warm-up · multi-output reasoning**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Dua channel menerima permintaan secara bersamaan. Setiap channel mempunyai kesiapan dan pemblokirannya sendiri. Panel pemantau membutuhkan keputusan per channel serta status gabungan.

Latihan ini memperluas keputusan izin tunggal menjadi beberapa output yang harus konsisten. Kedua channel boleh diterima bersamaan; tidak ada perebutan satu resource.

## 2. Specification

- `system_on` mengizinkan pemrosesan kedua channel.
- Sebuah channel diterima jika sistem aktif, channel tersebut diminta, channel tersebut siap, dan channel tersebut tidak diblokir.
- Ketidaksiapan atau pemblokiran satu channel tidak mengubah kelayakan channel lain.
- `activity` menunjukkan ada permintaan yang diterima.
- `denied` menunjukkan ada permintaan yang diajukan tetapi tidak diterima.

Status hanya menggambarkan input saat ini. Istilah diterima tidak berarti data telah disimpan atau dikirim pada waktu sebelumnya.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `system_on` | 1 | Pemrosesan global diaktifkan |
| Input | `req_a` | 1 | Permintaan channel A |
| Input | `req_b` | 1 | Permintaan channel B |
| Input | `ready_a` | 1 | Channel A siap |
| Input | `ready_b` | 1 | Channel B siap |
| Input | `block_a` | 1 | Channel A diblokir |
| Input | `block_b` | 1 | Channel B diblokir |
| Output | `grant_a` | 1 | Permintaan A diterima |
| Output | `grant_b` | 1 | Permintaan B diterima |
| Output | `activity` | 1 | Sedikitnya satu permintaan diterima |
| Output | `denied` | 1 | Sedikitnya satu permintaan yang diajukan ditolak |

## 4. Behavioral Requirements

1. Channel yang tidak meminta tidak boleh memperoleh grant.
2. Jika `system_on` tidak aktif, kedua grant dan `activity` tidak aktif. `denied` tetap mengikuti ada atau tidaknya permintaan yang ditolak.
3. Jika kedua channel memenuhi syarat masing-masing, keduanya memperoleh grant.
4. `activity` aktif ketika satu atau kedua grant aktif.
5. `denied` aktif ketika sedikitnya satu channel meminta tetapi tidak mendapat grant, termasuk ketika sistem tidak aktif.
6. `activity` dan `denied` boleh aktif bersamaan jika permintaan yang berbeda mengalami hasil yang berbeda.
7. Tidak ada permintaan berarti tidak ada aktivitas dan tidak ada penolakan.

## 5. Engineering Questions — Before Coding

1. Apa saja syarat yang berlaku global dan apa saja yang berlaku per channel?
2. Dalam situasi apa status aktivitas belum cukup untuk menjelaskan semua permintaan?
3. Bagaimana kamu membedakan channel yang tidak meminta dengan channel yang ditolak?
4. Output mana yang saling berkaitan secara makna, dan bagaimana kamu menguji konsistensinya?
5. Bagian penalaran apa yang mirip antara kedua channel? Apakah pemisahan menjadi module membantu pada ukuran soal ini?
6. Berapa kombinasi input yang mungkin? Susun rencana pengujian tanpa menulis kode dahulu.

## 6. Prediction Cases

Hitung semua output: `grant_a`, `grant_b`, `activity`, dan `denied`.

| Case | `system_on` | `req_a` | `req_b` | `ready_a` | `ready_b` | `block_a` | `block_b` |
|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | 1 | 0 | 0 | 1 | 1 | 0 | 0 |
| 2 | 1 | 1 | 0 | 1 | 0 | 0 | 1 |
| 3 | 1 | 1 | 1 | 1 | 1 | 0 | 0 |
| 4 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |
| 5 | 1 | 1 | 1 | 1 | 1 | 1 | 0 |
| 6 | 0 | 1 | 1 | 1 | 1 | 0 | 0 |
| 7 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
| 8 | 1 | 0 | 1 | 0 | 1 | 1 | 1 |

## 7. Architecture Task

Gambar jalur pengaruh input terhadap keputusan channel dan status gabungan. Kamu bebas memilih satu module atau beberapa module. Tuliskan alasan pilihanmu dan cara menghindari keterkaitan yang tidak diminta antara A dan B.

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

- Uji seluruh 128 kombinasi input.
- Uji penerimaan bersamaan dan penolakan bersamaan.
- Uji satu permintaan diterima sementara permintaan lain ditolak.
- Uji sistem tidak aktif, dengan dan tanpa permintaan.
- Periksa bahwa mengubah kesiapan atau pemblokiran B tidak mengubah grant A, dan sebaliknya.
- Amati perubahan status gabungan ketika jumlah permintaan berubah.

## 10. Synthesis Questions

1. Apakah logic yang kamu prediksi berulang masih terlihat dalam hasil synthesis?
2. Apakah ada fungsi gabungan yang disederhanakan atau dibagi oleh tool?
3. Bagaimana kamu membuktikan bahwa optimasi tersebut tetap memenuhi definisi `denied`?
4. Apakah ada ketergantungan antar-channel yang tidak seharusnya muncul?

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
