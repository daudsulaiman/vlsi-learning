# Problem 07 — Dua Jalur Pengolahan Independen

Level: **Design · reusable modules dan hierarchy**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Sebuah subsystem memiliki dua lane pengolahan yang berfungsi sama tetapi menerima input dan konfigurasi berbeda. Lane berarti jalur data paralel yang memiliki hasilnya sendiri. Keluaran keduanya dikemas menjadi satu bus untuk pemantauan.

Latihan ini membawa perilaku pengolahan dua operand ke tingkat integrasi. Sebagian rancangan wajib menggunakan module yang sama lebih dari sekali. Kamu menentukan sendiri responsibility dan interface module tersebut.

## 2. Specification

Lane A dan B masing-masing menerima operand kiri, operand kanan, dua bit keabsahan, serta konfigurasi 11-bit.

| Bit konfigurasi | Arti |
|---|---|
| `[10]` | Lane diaktifkan |
| `[9:8]` | Kode operasi |
| `[7:0]` | Mask hasil |

Untuk `a_input_valid` dan `b_input_valid`, bit 0 menyatakan operand kiri valid dan bit 1 menyatakan operand kanan valid.

Perilaku operasi identik pada kedua lane:

| Kode | Hasil sebelum mask | Operand wajib valid |
|---|---|---|
| `00` | Operand kiri | Kiri saja |
| `01` | Operand kanan | Kanan saja |
| `10` | Nilai unsigned yang lebih besar; jika sama, nilai bersama itu | Keduanya |
| `11` | Bit 1 pada posisi tempat bit kiri dan kanan berbeda; selainnya 0 | Keduanya |

Seluruh operand unsigned 8-bit. Mask diterapkan **setelah** operasi: bit mask 1 mempertahankan posisi bit, bit mask 0 memaksanya nol.

Kontrak keluaran gabungan:

| Bagian output | Makna |
|---|---|
| `result_bus[7:0]` | Hasil akhir lane A |
| `result_bus[15:8]` | Hasil akhir lane B |
| Bit 0 pada seluruh map | Status lane A |
| Bit 1 pada seluruh map | Status lane B |

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `a_left` | 8 | Operand kiri lane A |
| Input | `a_right` | 8 | Operand kanan lane A |
| Input | `a_input_valid` | 2 | Keabsahan kanan dan kiri lane A |
| Input | `a_config` | 11 | Konfigurasi lane A |
| Input | `b_left` | 8 | Operand kiri lane B |
| Input | `b_right` | 8 | Operand kanan lane B |
| Input | `b_input_valid` | 2 | Keabsahan kanan dan kiri lane B |
| Input | `b_config` | 11 | Konfigurasi lane B |
| Output | `result_bus` | 16 | Dua hasil sesuai posisi byte yang ditentukan |
| Output | `valid_map` | 2 | Status hasil valid per lane |
| Output | `zero_map` | 2 | Status hasil valid bernilai nol per lane |
| Output | `input_equal_map` | 2 | Status operand asli sama per lane |
| Output | `pair_equal` | 1 | Kedua hasil valid dan hasil akhirnya sama |

## 4. Behavioral Requirements

1. Lane yang tidak diaktifkan menghasilkan byte hasil nol dan ketiga bit status lane tersebut nol.
2. Lane aktif menghasilkan hasil valid hanya jika operand yang dibutuhkan operasi terpilih valid.
3. Jika operasi lane tidak valid, byte hasil, bit `valid_map`, dan bit `zero_map` lane itu bernilai nol.
4. Untuk operasi valid, hasil mengikuti operasi lalu mask. Hasil nol tetap valid.
5. Bit `zero_map` aktif hanya ketika lane menghasilkan hasil valid yang bernilai nol setelah mask.
6. Bit `input_equal_map` aktif hanya ketika lane aktif, kedua operand lane valid, dan kedua nilai asli sama. Bit ini tidak bergantung pada kode operasi atau mask.
7. Perubahan input satu lane tidak mengubah byte hasil atau status individual lane lain.
8. `pair_equal` aktif hanya ketika kedua hasil lane valid dan kedua byte hasil akhir sama. Dua byte nol dari lane yang tidak valid tidak memenuhi syarat ini.
9. Semua nilai kode operasi dan semua pola mask sah.

## 5. Engineering Questions — Before Coding

1. Perilaku apa yang berulang antara lane A dan B, dan informasi apa yang berbeda?
2. Bagaimana kamu memilih responsibility reusable module agar cukup bermakna dan mudah diuji?
3. Port dan width apa yang perlu melewati batas module pilihanmu? Apakah arah signalnya konsisten?
4. Apa perbedaan kesamaan operand dalam satu lane dan kesamaan hasil antara dua lane?
5. Bagaimana kamu membuktikan dua instance tidak saling memengaruhi status individual?
6. Apa yang kamu prediksi terjadi pada hardware ketika satu definisi module dipakai pada dua instance? Bagaimana synthesis dapat memengaruhi bentuk akhirnya?

## 6. Prediction Cases

Pada setiap sel lane, urutan tuple adalah **(operand kiri, operand kanan, input_valid, config)**. Nilai konfigurasi ditulis dengan width 11 bit. Semua case independen.

Uraikan konfigurasi, lalu prediksi `result_bus`, `valid_map`, `zero_map`, `input_equal_map`, dan `pair_equal`.

| Case | Lane A: `(left, right, valid, config)` | Lane B: `(left, right, valid, config)` |
|---|---|---|
| 1 | `(8'h3C, 8'hA5, 2'b11, 11'h4FF)` | `(8'h81, 8'h7E, 2'b11, 11'h5F0)` |
| 2 | `(8'h3C, 8'hA5, 2'b11, 11'h5F0)` | `(8'h81, 8'h7E, 2'b11, 11'h4FF)` |
| 3 | `(8'h3C, 8'hA5, 2'b11, 11'h0FF)` | `(8'h81, 8'h7E, 2'b10, 11'h4FF)` |
| 4 | `(8'h00, 8'hA5, 2'b01, 11'h4FF)` | `(8'h81, 8'h00, 2'b10, 11'h5FF)` |
| 5 | `(8'h55, 8'h55, 2'b11, 11'h7FF)` | `(8'h00, 8'hFF, 2'b01, 11'h4FF)` |
| 6 | `(8'h80, 8'h7F, 2'b11, 11'h60F)` | `(8'h12, 8'h34, 2'b11, 11'h500)` |
| 7 | `(8'hFF, 8'h00, 2'b01, 11'h6FF)` | `(8'h3C, 8'hA5, 2'b11, 11'h7FF)` |
| 8 | `(8'hA5, 8'hA5, 2'b11, 11'h4FF)` | `(8'h00, 8'hA5, 2'b11, 11'h5FF)` |
| 9 | `(8'h96, 8'h69, 2'b11, 11'h7FF)` | `(8'h96, 8'h69, 2'b11, 11'h7FF)` |
| 10 | `(8'h00, 8'h00, 2'b00, 11'h4FF)` | `(8'h00, 8'h00, 2'b00, 11'h4FF)` |

## 7. Architecture Task

Usulkan hierarchy lengkap dengan nama module pilihanmu, responsibility, port, width, serta koneksi antar-instance. Tunjukkan asal setiap field keluaran gabungan.

Pilih sendiri bagian yang reusable. Sertakan rencana pengujian bagian tersebut secara terpisah sebelum pengujian top module. Diagram jawaban tidak disediakan.

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
- Minimal ada top module dan satu jenis submodule dengan responsibility fungsional yang bermakna.
- Minimal satu jenis submodule digunakan dalam **dua instance atau lebih**. Submodule tersebut harus melakukan sebagian keputusan atau pengolahan, bukan hanya menjadi pembungkus kosong.
- Gunakan named port connection pada seluruh instance.
- Tuliskan instance secara eksplisit; tidak memakai `generate`, parameter, array instance, atau loop.
- Port dan batas submodule kamu tentukan sendiri.

## 9. Verification Targets

- Verifikasi semua operasi dan pola validitas pada reusable module yang kamu pilih.
- Uji konfigurasi A dan B yang berbeda secara bersamaan.
- Ubah hanya input A, lalu hanya input B; periksa isolasi byte hasil dan status individual.
- Uji kesamaan hasil dengan operand asal yang berbeda.
- Uji kedua hasil valid nol serta dua byte nol karena keduanya tidak valid.
- Uji satu lane valid dan satu tidak valid.
- Periksa posisi byte A/B dan bit status dengan nilai yang tidak simetris.
- Periksa named port connection dan width semua koneksi melalui hasil compile dan pemeriksaan RTL.

## 10. Synthesis Questions

1. Apakah laporan hierarchy mengenali reusable module dan instance yang kamu buat?
2. Apa perbedaan satu definisi source code dengan beberapa instance hardware?
3. Apakah optimasi dapat mengubah batas yang kamu lihat pada netlist akhir? Bandingkan laporan hierarchy dan koneksi yang tersedia.
4. Bagian hardware apa yang diperlukan untuk status gabungan dibandingkan status individual?
5. Apakah hasil verifikasi fungsi tetap sama meskipun representasi hierarchy hasil synthesis berbeda?

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
- [ ] Reusable module sudah saya verifikasi terpisah, kemudian saya verifikasi kembali saat terhubung pada top.
- [ ] Saya dapat menjelaskan perbedaan definisi module, instance, dan koneksi signal.
