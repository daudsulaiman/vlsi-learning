# Notes — Problem 02

## BAGIAN A — Concept Reference

Satu `module` dapat memiliki beberapa output. Port ditulis sebagai `input wire` atau `output wire`; `wire` internal menyambungkan logic di dalam module. Setiap bit memiliki satu penggerak yang jelas.

`assign z = p ^ q;` adalah contoh generik continuous assignment: hubungan terus berlaku, bukan instruksi yang hanya dijalankan sekali. Beberapa `assign` menggambarkan hubungan yang berjalan bersamaan, bukan urutan langkah software.

- `~`, `&`, `|`, `^`: bitwise NOT, AND, OR, XOR; bekerja pada setiap posisi bit.
- `!`, `&&`, `||`: operasi logical, menghasilkan 1 bit.
- Pada vector, `~` berbeda dari `!`, dan `&` berbeda dari `&&`.
- `1'b0` dan `1'b1`: literal 1-bit. Nama signal sebagai status tidak membuatnya menyimpan nilai.

Nama `p`, `q`, dan `z` hanya contoh; expression tersebut bukan rancangan problem.

---

## BAGIAN B — Engineering Notes

Isi singkat dengan bahasamu sendiri; poin atau gambar cukup. Simpan prediction awal, lalu catat koreksi penting di Result.

### 1. Understanding Check

1. Apakah kedua channel bersaing, atau dapat memperoleh grant bersamaan? Apa akibatnya jika hanya B diblokir?
2. Apa beda channel yang tidak meminta dengan channel yang meminta tetapi ditolak?
3. Saat `system_on=0`, bagaimana makna `denied` untuk keadaan ada permintaan dan tidak ada permintaan?
4. Bisakah `activity` dan `denied` aktif bersamaan? Jelaskan situasi yang mendukung jawabanmu.

Jawaban saya:

---

### 2. Logic Design

Behavior utama dengan bahasa saya:

---

Logic equation untuk keputusan dan status saya:

---

Logic circuit / diagram saya:

---

### 3. Prediction

Gunakan case asli berikut. Urutan input: (`system_on`, `req_a`, `req_b`, `ready_a`, `ready_b`, `block_a`, `block_b`). Isi semua kolom output sebelum RTL dan simulation. Tidak perlu menulis 128 baris secara manual; pengujian exhaustive tetap mengikuti `problem.md`.

| Case | Input | `grant_a` | `grant_b` | `activity` | `denied` |
|---|---|---|---|---|---|
| 1 | `(1, 0, 0, 1, 1, 0, 0)` |  |  |  |  |
| 2 | `(1, 1, 0, 1, 0, 0, 1)` |  |  |  |  |
| 3 | `(1, 1, 1, 1, 1, 0, 0)` |  |  |  |  |
| 4 | `(1, 1, 1, 1, 0, 0, 0)` |  |  |  |  |
| 5 | `(1, 1, 1, 1, 1, 1, 0)` |  |  |  |  |
| 6 | `(0, 1, 1, 1, 1, 0, 0)` |  |  |  |  |
| 7 | `(0, 0, 0, 1, 1, 1, 1)` |  |  |  |  |
| 8 | `(1, 0, 1, 0, 1, 1, 1)` |  |  |  |  |

Alasan / perhitungan untuk case penting:

---

### 4. Implementation Plan

Rencana RTL singkat:

---

### 5. Result

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
