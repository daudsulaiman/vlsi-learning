# Notes — Problem 03

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

1. Apa beda menukar dua nibble dengan membalik urutan delapan bit? Apakah metadata ikut berubah?
2. Apa yang menentukan sample sah? Apakah payload nol menentukan keabsahannya?
3. Saat sample tidak sah, apa yang harus terjadi pada seluruh `frame`, termasuk penanda tetap?
4. Bagaimana memeriksa total width dan posisi field agar tidak ada bit tumpang tindih atau terlewat?

Jawaban saya:

---

### 2. Data / Logic Flow

Boleh langsung beri anotasi pada diagram bagian 3; tidak perlu menggambar dua kali.

Alur field input menuju output dengan bahasa / gambar saya:

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

Gunakan case asli berikut. Urutan input: (`meta`, `payload`, `swap_halves`). Isi semua kolom output sebelum RTL dan simulation.

| Case | Input | `frame_valid` | `frame` binary 16-bit | `frame` hex 4 digit |
|---|---|---|---|---|
| 1 | `(8'h9A, 8'h3C, 0)` |  |  |  |
| 2 | `(8'h9A, 8'h3C, 1)` |  |  |  |
| 3 | `(8'hB5, 8'h96, 1)` |  |  |  |
| 4 | `(8'hDA, 8'h3C, 0)` |  |  |  |
| 5 | `(8'h1A, 8'hF0, 1)` |  |  |  |
| 6 | `(8'h80, 8'h00, 0)` |  |  |  |
| 7 | `(8'hBF, 8'hFF, 1)` |  |  |  |
| 8 | `(8'h5F, 8'h81, 1)` |  |  |  |

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
