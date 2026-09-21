# Notes — Problem 05

## BAGIAN A — Concept Reference

`module` mendefinisikan blok; port `input wire` / `output wire` menjadi batasnya. `wire` menyambungkan signal. `assign` menyatakan hubungan combinational yang terus berlaku; tidak ada urutan eksekusi antar-`assign` seperti langkah software.

Contoh berikut terpisah dan generik; `bus_p` dianggap 12-bit:

| Syntax | Pengingat |
|---|---|
| `wire [11:0] bus_p;` | Vector dengan 12 posisi bit |
| `bus_p[8]` | Bit-select: mengambil 1 bit |
| `bus_p[6:4]` | Part-select tetap: mengambil 3 bit |
| `{3'b101, 2'b10}` | Concatenation: menggabungkan menjadi 5 bit; bagian kiri menempati bit tinggi |
| `{3{2'b10}}` | Replication: mengulang pola menjadi 6 bit |
| `flag_x ? bus_p : bus_q` | Untuk kondisi 0/1: pilih `bus_p` saat 1, `bus_q` saat 0; samakan width alternatif |
| `5'b10110`, `12'h35A` | Literal dengan ukuran dan basis yang eksplisit |

`~`, `&`, `|`, `^` adalah bitwise NOT, AND, OR, XOR. `!`, `&&`, `||` adalah logical NOT, AND, OR dengan hasil 1-bit. `==`, `!=`, `<`, `>`, `<=`, `>=` menghasilkan hasil perbandingan 1-bit. Gunakan data unsigned dan periksa width expression sebelum disambungkan.

Unsigned tidak memiliki bit tanda; setiap posisi bit menyumbang nilai. Jangan mengganti operasi per-bit dengan operasi logical hanya karena simbolnya mirip.

---

## BAGIAN B — Engineering Notes

Isi singkat dengan bahasamu sendiri; poin atau gambar cukup. Simpan prediction awal, lalu catat koreksi penting di Result.

### 1. Understanding Check

1. Operand mana yang wajib valid untuk setiap operasi? Apakah operand yang tidak digunakan boleh membatalkan hasil?
2. Apa beda hasil valid bernilai nol dengan hasil tidak valid, terutama pada `result_zero`?
3. Apakah mask sebelum pemilihan nilai terbesar selalu setara dengan mask sesudahnya? Cari contohmu sendiri.
4. Bagaimana unsigned memengaruhi perbandingan ketika bit tertinggi salah satu operand bernilai 1?
5. Apakah `equal_inputs` membandingkan operand asli atau hasil setelah mask? Apakah operasi terpilih memengaruhi status ini?

Jawaban saya:

---

### 2. Data / Logic Flow

Boleh langsung beri anotasi pada diagram bagian 3; tidak perlu menggambar dua kali.

Alur operand menuju hasil dan status dengan bahasa / gambar saya:

---

Field / width penting:

---

Control yang memengaruhi data:

---

### 3. Logic / Datapath Design

Logic equation / hubungan bit yang saya turunkan:

---

Logic circuit / diagram saya (beri width pada jalur penting):

---

### 4. Prediction

Gunakan case asli berikut. Urutan input: (`left_data`, `right_data`, `left_valid`, `right_valid`, `operation`, `bit_mask`, `enable`). Isi semua kolom output sebelum RTL dan simulation.

| Case | Input | `result` | `result_valid` | `result_zero` | `equal_inputs` |
|---|---|---|---|---|---|
| 1 | `(8'h3C, 8'hA5, 1, 0, 2'b00, 8'hFF, 1)` |  |  |  |  |
| 2 | `(8'h3C, 8'hA5, 0, 1, 2'b01, 8'hF0, 1)` |  |  |  |  |
| 3 | `(8'h80, 8'h7F, 1, 1, 2'b10, 8'hFF, 1)` |  |  |  |  |
| 4 | `(8'h80, 8'h7F, 1, 1, 2'b10, 8'h0F, 1)` |  |  |  |  |
| 5 | `(8'h3C, 8'hA5, 1, 1, 2'b11, 8'hF0, 1)` |  |  |  |  |
| 6 | `(8'h55, 8'h55, 1, 1, 2'b11, 8'hFF, 1)` |  |  |  |  |
| 7 | `(8'h55, 8'h55, 1, 1, 2'b10, 8'h00, 1)` |  |  |  |  |
| 8 | `(8'h3C, 8'hA5, 1, 0, 2'b10, 8'hFF, 1)` |  |  |  |  |
| 9 | `(8'h00, 8'hFF, 1, 1, 2'b00, 8'hFF, 1)` |  |  |  |  |
| 10 | `(8'h55, 8'h55, 1, 1, 2'b01, 8'hFF, 0)` |  |  |  |  |
| 11 | `(8'h55, 8'h55, 0, 1, 2'b00, 8'hFF, 1)` |  |  |  |  |
| 12 | `(8'hAA, 8'h55, 1, 1, 2'b01, 8'h00, 1)` |  |  |  |  |

Alasan / perhitungan untuk case penting:

---

### 5. RTL Plan

Rencana RTL singkat dari desain saya:

---

### 6. Result

Simulation — PASS / FAIL + catatan penting:

---

Waveform — hal penting yang diamati:

---

Synthesis — hardware / cell utama yang ditemukan:

---

Bug / mistake:

---

What I learned:

---
