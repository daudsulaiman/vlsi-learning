# Notes — Problem 08

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

Module instantiation membuat instance dari sebuah definisi. Contoh ini hanya menunjukkan syntax koneksi:

```verilog
module demo_link (
    input  wire [4:0] in_port,
    output wire [4:0] out_port
);
    assign out_port = in_port;
endmodule
```

Di dalam module lain, jika `local_x` dan `local_y` adalah signal 5-bit:

```verilog
demo_link u_demo (
    .in_port(local_x),
    .out_port(local_y)
);
```

`demo_link` adalah jenis module; `u_demo` adalah nama instance. Pada `.in_port(local_x)`, kiri adalah nama port submodule, dalam kurung adalah signal di module induk. Named port connection memakai nama, bukan urutan; arah dan width tetap harus cocok.

Satu definisi yang dipakai beberapa kali membentuk beberapa instance hardware sebelum optimasi. Hierarchy adalah susunan module dan instance, bukan urutan eksekusi. Deklarasi `wire` saja belum memberikan penggerak.

---

## BAGIAN B — Engineering Notes

Isi singkat dengan bahasamu sendiri; poin atau gambar cukup. Simpan prediction awal, lalu catat koreksi penting di Result.

### 1. Understanding Check

1. Apa beda penghasil command A/B, sumber data, dan lane tujuan? Bagaimana penomoran bit `accepted` berbeda dari `out_valid`?
2. Apa beda command hadir, layak dipertimbangkan, dan diterima? Bagaimana membedakan tidak hadir dengan ditolak?
3. Jika command berprioritas tinggi tidak layak, apa dampaknya pada command lain yang layak menuju lane yang sama?
4. Bagaimana keputusan berubah untuk tujuan sama versus berbeda? Bit prioritas mana yang relevan, dan apakah yang kalah boleh pindah lane?
5. Bagaimana menjaga data, tag, owner, dan status berasal dari command yang sama, termasuk saat hasil setelah mask nol?
6. Apa ketergantungan keputusan antar-block pilihanmu? Apakah ada ketergantungan melingkar atau kebutuhan mengingat pemenang sebelumnya?

Jawaban saya:

---

### 2. Architecture

Tunjukkan minimal tiga jenis module termasuk top, responsibility yang jelas, serta minimal satu jenis submodule dalam dua instance atau lebih. Tandai nama instance dan bagian reusable; pembagian block kamu tentukan sendiri.

Hierarchy / block diagram saya:

---

Responsibility setiap block — input yang diperlukan, output yang dijanjikan, dan kondisi gagal yang ditangani:

---

Signal, arah port, dan width yang melewati batas module:

---

### 3. Data and Control Flow

Tunjukkan perjalanan data, tag / identitas command, valid / status, dan decision / control sampai lane keluaran. Boleh anotasi diagram architecture yang sama.

Alur dan ketergantungan menurut saya:

---

### 4. Logic Design

Logic equation / aturan keputusan yang saya turunkan:

---

Logic circuit / datapath / arbitration saya:

---

### 5. Prediction

Gunakan baseline dan 15 Prediction Cases pada bagian 6 `problem.md`. Setiap case dimulai lagi dari baseline, lalu hanya perubahan pada baris itu diterapkan. Jangan mewarisi nilai dari case sebelumnya.

Isi sebelum RTL dan simulation:

- Uraian setiap command: (present, destination, source, operation, tag, mask).
- Prediksi semua output: (`out_data`, `out_tag`, `out_valid`, `out_owner`, `out_zero`, `accepted`, `rejected`).
- Alasan A / B: alasan penerimaan atau penolakan masing-masing command.

Tulis tuple sesuai urutan tersebut; input tidak perlu disalin ulang.

| Case | Uraian command A / B | Prediksi semua output | Alasan A / B |
|---|---|---|---|
| 1 |  |  |  |
| 2 |  |  |  |
| 3 |  |  |  |
| 4 |  |  |  |
| 5 |  |  |  |
| 6 |  |  |  |
| 7 |  |  |  |
| 8 |  |  |  |
| 9 |  |  |  |
| 10 |  |  |  |
| 11 |  |  |  |
| 12 |  |  |  |
| 13 |  |  |  |
| 14 |  |  |  |
| 15 |  |  |  |

### 6. Verification Plan

Pilih beberapa kondisi yang paling rawan salah pada desainmu dan cara mengeceknya. Target lengkap tetap mengikuti `problem.md`; tidak perlu menyalin seluruh daftar.

Kondisi penting dan cara memeriksanya:

---

Urutan pengujian submodule dan integrasi top:

---

### 7. Result

Simulation — PASS / FAIL + catatan penting:

---

Waveform — hal penting yang diamati:

---

Synthesis — hardware / cell utama yang ditemukan:

---

Architecture vs synthesis — perbedaan penting:

---

Bug / mistake:

---

What I learned:

---
