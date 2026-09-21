# Problem 08 — Dua Command, Dua Tujuan

Level: **Boss problem · integrated combinational mini-system**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Dua penghasil command, A dan B, menggunakan empat sumber data dan satu operand tambahan bersama. Setiap command memilih sumber, operasi, mask, tag, dan satu lane keluaran.

Jika keduanya menuju lane yang sama, hanya satu command yang boleh diterima di sana. Jika menuju lane berbeda dan memenuhi syarat masing-masing, keduanya dapat diterima bersamaan. Kamu harus merancang sistem combinational lengkap yang menjaga data, tag, pemilik, dan status penolakan tetap konsisten.

Semua command tersedia sebagai word paralel pada input. Sistem ini tidak mempunyai antrean, penyimpanan, pengiriman serial, atau riwayat prioritas.

## 2. Specification

**Format kedua command identik.** Nama A/B menunjukkan penghasil command, sedangkan lane 0/1 menunjukkan tujuan; keduanya bukan istilah yang saling menggantikan.

| Bit `cmd_a` / `cmd_b` | Field | Arti |
|---|---|---|
| `[15]` | present | Ada command saat ini |
| `[14]` | destination | Lane tujuan: 0 atau 1 |
| `[13:12]` | source | Nomor sumber data: 0, 1, 2, atau 3 |
| `[11:10]` | operation | Salah satu dari empat operasi di bawah |
| `[9:8]` | tag | Identitas command 2-bit |
| `[7:0]` | mask | Posisi bit hasil yang dipertahankan |

Bit ke-i pada `source_valid` menyatakan keabsahan `source_i`. Semua data unsigned 8-bit. Operand tambahan adalah `aux_data`, dengan keabsahan `aux_valid`.

Untuk `lane_ready`, `prefer_b`, `out_valid`, `out_owner`, dan `out_zero`, bit 0 selalu milik lane 0 dan bit 1 selalu milik lane 1. Sebaliknya, `accepted` dan `rejected` memakai bit 0 untuk command A dan bit 1 untuk command B.

| Operasi | Nilai sebelum mask | Data yang wajib valid |
|---|---|---|
| `00` | Nilai sumber yang ditunjuk field source | Sumber terpilih saja |
| `01` | Nilai operand tambahan | Operand tambahan saja |
| `10` | Nilai unsigned yang lebih besar antara sumber terpilih dan operand tambahan; jika sama, nilai bersama itu | Keduanya |
| `11` | Bit 1 pada posisi tempat bit sumber terpilih dan operand tambahan berbeda; selainnya 0 | Keduanya |

Mask diterapkan setelah operasi. Bit mask 1 mempertahankan bit hasil; bit mask 0 memaksanya nol. Hasil nol tidak mengubah keabsahan command.

**Kelayakan dan perebutan tujuan:**

- Command layak dipertimbangkan bila present aktif, sistem aktif, lane tujuannya siap, dan data yang diperlukan oleh operasinya valid.
- Jika hanya satu command layak menuju suatu lane, command itu diterima di sana.
- Jika kedua command layak menuju lane yang sama, bit `prefer_b` milik lane tersebut menentukan prioritas: 0 memprioritaskan A, 1 memprioritaskan B.
- Command yang tidak layak tidak ikut perebutan dan tidak dapat menghalangi command yang layak.
- Prioritas hanya menyelesaikan perebutan pada tujuan yang sama. Command yang kalah tidak dialihkan ke lane lain.

Seluruh nilai field source, operation, tag, destination, dan mask sah. Tidak ada kode cadangan.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `source_0` | 8 | Data sumber 0 |
| Input | `source_1` | 8 | Data sumber 1 |
| Input | `source_2` | 8 | Data sumber 2 |
| Input | `source_3` | 8 | Data sumber 3 |
| Input | `source_valid` | 4 | Keabsahan sumber 3 sampai sumber 0 |
| Input | `aux_data` | 8 | Operand tambahan bersama |
| Input | `aux_valid` | 1 | Keabsahan operand tambahan |
| Input | `cmd_a` | 16 | Command dari penghasil A |
| Input | `cmd_b` | 16 | Command dari penghasil B |
| Input | `lane_ready` | 2 | Bit 0 untuk lane 0; bit 1 untuk lane 1 |
| Input | `prefer_b` | 2 | Preferensi pemenang pada perebutan setiap lane |
| Input | `system_on` | 1 | Sistem diaktifkan |
| Output | `out_data` | 16 | Byte `[7:0]` untuk lane 0; byte `[15:8]` untuk lane 1 |
| Output | `out_tag` | 4 | Bit `[1:0]` untuk lane 0; bit `[3:2]` untuk lane 1 |
| Output | `out_valid` | 2 | Ada hasil yang diterima pada setiap lane |
| Output | `out_owner` | 2 | Untuk lane valid: 0 berarti A, 1 berarti B |
| Output | `out_zero` | 2 | Hasil lane valid dan bernilai nol setelah mask |
| Output | `accepted` | 2 | Bit 0: command A diterima; bit 1: command B diterima |
| Output | `rejected` | 2 | Bit 0: command A ditolak; bit 1: command B ditolak |

## 4. Behavioral Requirements

1. Setiap command hanya dapat diterima pada lane yang ditunjuk destination-nya. Tidak ada broadcast.
2. Command tanpa present tidak diterima dan tidak ditolak. Field lainnya tidak boleh memengaruhi command lain atau output lane.
3. Kebutuhan keabsahan mengikuti operasi. Pada operasi `00`, operand tambahan yang tidak valid tidak menggagalkan command. Pada operasi `01`, sumber terpilih yang tidak valid tidak menggagalkan command.
4. Lane yang tidak siap tidak menerima command. Command tidak dipindahkan ke lane lain.
5. Jika dua command layak menuju tujuan berbeda, keduanya diterima tanpa dipengaruhi `prefer_b`.
6. Jika dua command layak menuju tujuan sama, tepat satu diterima mengikuti bit prioritas lane tujuan. Bit prioritas lane lain tidak berpengaruh.
7. Jika satu command menuju tujuan yang sama tetapi tidak layak, keputusan hanya mempertimbangkan command layak yang tersisa.
8. Lane yang menerima command mengeluarkan hasil operasi setelah mask, tag command pemenang, identitas pemilik yang sesuai, dan status valid aktif.
9. Untuk lane tanpa penerimaan, byte data, pasangan bit tag, bit valid, bit owner, dan bit zero milik lane tersebut semuanya nol.
10. `out_zero` hanya aktif pada lane valid dengan hasil akhir nol. Identitas owner nol pada lane tidak valid tidak berarti command A diterima.
11. Bit `accepted` mengikuti command yang benar-benar diterima pada lane tujuannya.
12. Bit `rejected` aktif untuk command dengan present aktif yang tidak diterima, apa pun penyebabnya: sistem mati, lane tidak siap, data yang diperlukan tidak valid, atau kalah prioritas.
13. Ketika `system_on` tidak aktif, tidak ada penerimaan dan seluruh output lane nol. Status penolakan tetap mengikuti present masing-masing command.
14. Perubahan input hanya mengubah evaluasi combinational saat ini. Tidak ada kewajiban mengingat pemenang, bergantian, atau menjamin giliran pada waktu berikutnya.

## 5. Engineering Questions — Before Coding

1. Apa perbedaan penghasil command, sumber data, dan lane tujuan? Kelompokkan semua interface berdasarkan maknanya.
2. Bagaimana kamu membedakan command hadir, command layak, dan command diterima? Tulis alasan mengapa ketiganya diperlukan secara konsep.
3. Informasi mana yang harus tetap terkait dengan satu command agar data, tag, dan owner tidak tertukar?
4. Apa urutan ketergantungan keputusan yang kamu temukan dari spesifikasi? Apakah ada risiko ketergantungan melingkar dalam architecture usulanmu?
5. Bagian mana yang dapat memakai definisi module berulang, dan bagian mana yang memiliki responsibility berbeda? Tentukan interface dan width-nya sendiri.
6. Bagaimana rencana verifikasimu membedakan kesalahan pengolahan data, keabsahan, perebutan tujuan, dan pengemasan output?

## 6. Prediction Cases

**Baseline untuk setiap case:**

| Input | Nilai |
|---|---|
| `source_0` | `8'h96` |
| `source_1` | `8'h3C` |
| `source_2` | `8'hA5` |
| `source_3` | `8'h00` |
| `source_valid` | `4'b1111` |
| `aux_data` | `8'h5A` |
| `aux_valid` | `1'b1` |
| `cmd_a` | `16'h81FF` |
| `cmd_b` | `16'hD2FF` |
| `lane_ready` | `2'b11` |
| `prefer_b` | `2'b00` |
| `system_on` | `1'b1` |

Setiap case dimulai kembali dari baseline, kemudian hanya perubahan pada baris itu diterapkan. Tidak ada nilai yang diwarisi dari case sebelumnya.

Uraikan kedua command, lalu hitung **seluruh tujuh output**. Tuliskan alasan penerimaan atau penolakan setiap command dengan bahasamu sendiri.

| Case | Perubahan dari baseline |
|---|---|
| 1 | Tidak ada perubahan |
| 2 | `cmd_b=16'h92FF` |
| 3 | `cmd_b=16'h92FF`, `prefer_b=2'b01` |
| 4 | `cmd_a=16'hADFF`, `cmd_b=16'h92FF`, `aux_valid=1'b0` |
| 5 | `source_valid=4'b1110`, `cmd_b=16'h86FF` |
| 6 | `aux_valid=1'b0`, `cmd_b=16'hF6FF` |
| 7 | `cmd_a=16'h890F`, `cmd_b=16'h52FF` |
| 8 | `cmd_a=16'hB1FF`, `cmd_b=16'hD200` |
| 9 | `cmd_b=16'h92FF`, `lane_ready=2'b10` |
| 10 | `system_on=1'b0` |
| 11 | `cmd_a=16'h01FF` |
| 12 | `cmd_a=16'hC1FF`, `prefer_b=2'b01` |
| 13 | `cmd_a=16'hC1FF`, `prefer_b=2'b10` |
| 14 | `cmd_a=16'h01FF`, `cmd_b=16'h52FF` |
| 15 | `source_0=8'h5A`, `cmd_a=16'h8DFF`, `cmd_b=16'h02FF` |

## 7. Architecture Task

Sebelum RTL, buat dokumen architecture di worksheet yang memuat:

- hierarchy pilihanmu dan responsibility setiap jenis module;
- kontrak input-output dan width semua submodule;
- perjalanan data, tag, dan identitas command menuju setiap lane;
- ketergantungan control beserta alasan tidak memerlukan state;
- penjelasan perilaku ketika kedua command menuju lane yang sama;
- urutan integrasi dan cara menguji tiap bagian sebelum menggabungkannya.

Tentukan sendiri jumlah dan batas blok di atas syarat minimum. Daftar ini adalah isi dokumen yang diminta, bukan daftar module yang harus kamu buat.

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
- Gunakan minimal **tiga jenis module termasuk top**; setiap jenis harus mempunyai responsibility fungsional yang jelas.
- Minimal satu jenis submodule digunakan dalam dua instance atau lebih.
- Jumlah tiga adalah batas minimum, bukan pembagian architecture yang diwajibkan.
- Semua instance harus memiliki named port connection dan ditulis secara eksplisit.
- Tidak memakai `generate`, parameter, array instance, loop, atau rangkaian feedback.
- Tidak ada pembagian giliran berbasis clock atau penyimpanan command. Perubahan prioritas sepenuhnya datang dari input `prefer_b`.

## 9. Verification Targets

- Uji setiap sumber, setiap operasi, setiap destination, dan beberapa mask.
- Uji validitas sumber dan operand tambahan yang diperlukan maupun yang tidak digunakan operasi.
- Uji dua command menuju tujuan berbeda, tujuan sama, dan hanya satu command hadir.
- Uji kedua nilai prioritas pada masing-masing lane, termasuk perubahan bit prioritas lane yang tidak dituju.
- Uji calon dengan prioritas tinggi tetapi tidak layak; pastikan keputusan mengikuti aturan kelayakan.
- Uji lane tidak siap serta sistem tidak aktif, lalu periksa status penolakan.
- Uji nilai unsigned di sekitar `7F` dan `80`, operand sama, dan mask yang membuat hasil nol.
- Gunakan data dan tag yang berbeda antar-command untuk mendeteksi tertukarnya identitas.
- Periksa bahwa setiap lane hanya memiliki satu pemilik ketika valid, dan setiap command diterima paling banyak sekali.
- Periksa bahwa tidak ada command yang sekaligus diterima dan ditolak, serta setiap command hadir mendapat tepat satu dari kedua status itu.
- Periksa seluruh field output lane ketika tidak valid; jangan hanya memeriksa byte data.
- Verifikasi submodule secara terpisah, lalu ulangi pengujian yang melintasi batas module pada top.

## 10. Synthesis Questions

1. Apakah hierarchy hasil synthesis sesuai pembagian responsibility yang kamu maksud?
2. Bagian mana yang berulang karena instance, dan apakah tool mengoptimasi sebagian logic yang sama?
3. Apakah metadata dan status terhubung pada keputusan yang benar dalam netlist hasil synthesis?
4. Input mana yang menurutmu memiliki jalur keputusan paling panjang menuju output? Jelaskan berdasarkan koneksi yang kamu amati.
5. Apakah source code yang singkat selalu menghasilkan hardware yang sedikit? Gunakan temuan dari desainmu.
6. Apa yang belum dapat kamu simpulkan tentang delay dan target frekuensi hanya dari synthesis generik?

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
- [ ] Seluruh kontrak submodule telah saya tulis dan verifikasi sebelum integrasi akhir.
- [ ] Saya dapat menjelaskan satu case dua tujuan berbeda dan satu case perebutan tujuan tanpa membaca RTL.
- [ ] Saya dapat mengikuti perjalanan data, tag, owner, accepted, dan rejected untuk command pilihan saya sendiri.
- [ ] Saya sudah menguji case tambahan yang saya rancang sendiri di luar daftar prediction.
