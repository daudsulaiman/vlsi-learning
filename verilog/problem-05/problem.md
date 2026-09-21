# Problem 05 — Pengolah Dua Operand dengan Mask

Level: **Medium · multi-function datapath**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Sebuah blok menerima dua data 8-bit yang keabsahannya dapat berbeda. Pengguna memilih satu dari empat operasi, lalu menentukan bit hasil yang boleh diteruskan.

Operand berarti data yang digunakan suatu operasi. Mask adalah pola bit yang menentukan bit hasil mana yang dipertahankan. Datapath adalah bagian rangkaian tempat data dipilih atau diolah.

## 2. Specification

Semua data ditafsirkan sebagai bilangan **unsigned** 8-bit, yaitu 0 sampai 255.

| `operation` | Hasil operasi sebelum mask | Operand yang wajib valid |
|---|---|---|
| `2'b00` | Nilai `left_data` | Kiri saja |
| `2'b01` | Nilai `right_data` | Kanan saja |
| `2'b10` | Nilai yang lebih besar antara kiri dan kanan | Kiri dan kanan |
| `2'b11` | Setiap bit bernilai 1 bila bit kiri dan kanan pada posisi itu berbeda; selainnya 0 | Kiri dan kanan |

Jika dua nilai sama pada operasi `10`, nilai hasil tetap nilai bersama tersebut. Tidak ada identitas pemenang yang perlu dikeluarkan.

Sesudah operasi dipilih, `bit_mask` diterapkan per posisi bit: bit mask 1 mempertahankan bit hasil, dan bit mask 0 memaksa posisi hasil tersebut menjadi 0. Pemilihan nilai yang lebih besar dilakukan **sebelum** mask.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `left_data` | 8 | Operand kiri |
| Input | `right_data` | 8 | Operand kanan |
| Input | `left_valid` | 1 | Operand kiri sah |
| Input | `right_valid` | 1 | Operand kanan sah |
| Input | `operation` | 2 | Operasi sesuai tabel |
| Input | `bit_mask` | 8 | Bit hasil yang dipertahankan |
| Input | `enable` | 1 | Pemrosesan diaktifkan |
| Output | `result` | 8 | Hasil akhir setelah mask |
| Output | `result_valid` | 1 | Operasi sah untuk operand yang tersedia |
| Output | `result_zero` | 1 | Hasil sah dan bernilai nol setelah mask |
| Output | `equal_inputs` | 1 | Kedua operand asli sah dan memiliki nilai sama saat blok aktif |

## 4. Behavioral Requirements

1. Ketika `enable` tidak aktif, seluruh output bernilai nol.
2. Ketika aktif, keabsahan hasil mengikuti operand yang dibutuhkan oleh operasi terpilih. Operand yang tidak digunakan tidak membatalkan hasil.
3. Jika operand yang dibutuhkan tidak valid, `result`, `result_valid`, dan `result_zero` harus nol.
4. Untuk operasi sah, hasil mengikuti tabel lalu mask. `result_valid` tetap aktif meskipun hasil akhirnya nol.
5. `result_zero` memeriksa hasil akhir setelah mask dan hanya boleh aktif pada hasil valid.
6. `equal_inputs` aktif hanya ketika blok aktif, kedua operand valid, dan nilai asli kedua operand sama. Status ini tidak dipengaruhi operasi terpilih atau mask.
7. Seluruh empat nilai `operation` sah; tidak ada kode operasi cadangan.

## 5. Engineering Questions — Before Coding

1. Bagaimana kebutuhan keabsahan operand berbeda antar-operasi?
2. Apa perbedaan hasil nol, hasil tidak valid, dan dua operand yang sama?
3. Apakah menerapkan mask sebelum memilih nilai terbesar selalu setara dengan spesifikasi? Cari contohmu sendiri.
4. Apa arti perbandingan unsigned ketika bit paling atas salah satu operand bernilai 1?
5. Bagaimana kamu menjaga agar keputusan operasi, keabsahan, dan status nol saling konsisten?
6. Tanggung jawab apa yang dapat dipisahkan, dan hardware apa yang kamu prediksi untuk setiap tanggung jawab itu?

## 6. Prediction Cases

Hitung `result`, `result_valid`, `result_zero`, dan `equal_inputs`.

| Case | `left_data` | `right_data` | `left_valid` | `right_valid` | `operation` | `bit_mask` | `enable` |
|---|---|---|---:|---:|---|---|---:|
| 1 | `8'h3C` | `8'hA5` | 1 | 0 | `2'b00` | `8'hFF` | 1 |
| 2 | `8'h3C` | `8'hA5` | 0 | 1 | `2'b01` | `8'hF0` | 1 |
| 3 | `8'h80` | `8'h7F` | 1 | 1 | `2'b10` | `8'hFF` | 1 |
| 4 | `8'h80` | `8'h7F` | 1 | 1 | `2'b10` | `8'h0F` | 1 |
| 5 | `8'h3C` | `8'hA5` | 1 | 1 | `2'b11` | `8'hF0` | 1 |
| 6 | `8'h55` | `8'h55` | 1 | 1 | `2'b11` | `8'hFF` | 1 |
| 7 | `8'h55` | `8'h55` | 1 | 1 | `2'b10` | `8'h00` | 1 |
| 8 | `8'h3C` | `8'hA5` | 1 | 0 | `2'b10` | `8'hFF` | 1 |
| 9 | `8'h00` | `8'hFF` | 1 | 1 | `2'b00` | `8'hFF` | 1 |
| 10 | `8'h55` | `8'h55` | 1 | 1 | `2'b01` | `8'hFF` | 0 |
| 11 | `8'h55` | `8'h55` | 0 | 1 | `2'b00` | `8'hFF` | 1 |
| 12 | `8'hAA` | `8'h55` | 1 | 1 | `2'b01` | `8'h00` | 1 |

## 7. Architecture Task

Tentukan sendiri architecture kasar, titik tempat keputusan control memengaruhi data, dan asal informasi setiap status. Beri width pada intermediate signal yang kamu rencanakan. Kamu boleh memakai satu module atau beberapa module dengan alasan yang jelas.

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

- Uji semua operasi untuk keempat kombinasi validitas operand.
- Uji kedua nilai enable, termasuk ketika operand sama dan valid.
- Uji mask `00`, `FF`, `0F`, `F0`, dan pola selang-seling.
- Uji nilai unsigned di sekitar `7F` dan `80`, nilai sama, nol, dan `FF`.
- Uji kondisi yang membedakan mask sebelum operasi dari mask setelah operasi.
- Pastikan operand tidak valid yang tidak digunakan tidak membatalkan operasi.
- Periksa `equal_inputs` terhadap operand asli, serta `result_zero` terhadap hasil akhir.

## 10. Synthesis Questions

1. Operasi mana yang menurutmu memerlukan logic paling banyak? Bandingkan prediksi dengan hasil synthesis.
2. Apakah semua bagian datapath yang kamu gambar masih terlihat sebagai bagian terpisah setelah optimasi?
3. Bagaimana hasil synthesis merepresentasikan keputusan keabsahan yang bergantung pada operasi?
4. Jalur combinational mana yang kamu duga paling panjang? Pisahkan dugaan struktur dari klaim delay fisik.

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
