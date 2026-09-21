# Notes — Problem 04

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

---

## BAGIAN B — Engineering Notes

Isi singkat dengan bahasamu sendiri; poin atau gambar cukup. Simpan prediction awal, lalu catat koreksi penting di Result.

### 1. Understanding Check

1. Jika sumber yang diminta dan sumber 0 sama-sama tersedia, sumber mana yang harus digunakan? Apa peran `allow_fallback`?
2. Jika sumber 0 diminta tetapi tidak tersedia, apakah sumber lain yang tersedia boleh menggantikannya?
3. Apakah `routed_data=0` cukup untuk menyatakan tidak ada sample sah?
4. Apakah `source_id=0` selalu berarti fallback? Bagaimana membedakan arti nilai itu pada kondisi berbeda?
5. Bagaimana memastikan data, identitas sumber, dan status keluaran menggambarkan keputusan penyaluran yang sama?

Jawaban saya:

---

### 2. Data / Logic Flow

Boleh langsung beri anotasi pada diagram bagian 3; tidak perlu menggambar dua kali.

Alur sample dan identitas sumber menuju output dengan bahasa / gambar saya:

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

Gunakan case asli berikut. Urutan input: (`available`, `select`, `allow_fallback`, `route_on`). Isi semua kolom output sebelum RTL dan simulation.

Untuk setiap case: `data_0=8'h00`, `data_1=8'h3C`, `data_2=8'hA5`, `data_3=8'h96`.

| Case | Input | `routed_data` | `routed_valid` | `source_id` | `used_fallback` |
|---|---|---|---|---|---|
| 1 | `(4'b1111, 2'b00, 1, 1)` |  |  |  |  |
| 2 | `(4'b1111, 2'b10, 1, 1)` |  |  |  |  |
| 3 | `(4'b1011, 2'b10, 1, 1)` |  |  |  |  |
| 4 | `(4'b1011, 2'b10, 0, 1)` |  |  |  |  |
| 5 | `(4'b1010, 2'b10, 1, 1)` |  |  |  |  |
| 6 | `(4'b1110, 2'b00, 1, 1)` |  |  |  |  |
| 7 | `(4'b1000, 2'b11, 0, 1)` |  |  |  |  |
| 8 | `(4'b0000, 2'b01, 1, 1)` |  |  |  |  |
| 9 | `(4'b1111, 2'b11, 1, 0)` |  |  |  |  |
| 10 | `(4'b0001, 2'b01, 1, 1)` |  |  |  |  |

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
