# Notes — Problem 06

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

1. Apa arti atomic untuk destination A dan B jika hanya satu endpoint memenuhi syarat?
2. Apa batas kewenangan `override_lock` terhadap lock, ready, sistem nonaktif, dan destination tidak sah?
3. Apa beda command tidak hadir dengan command hadir tetapi ditolak? Status apa yang masih dapat aktif saat `dispatch_on=0`?
4. Untuk command satu tujuan, apakah kondisi endpoint lain boleh memengaruhi penerimaan?
5. Bagaimana pembagian tanggung jawab pilihanmu menjaga payload, tag, `accepted`, dan `rejected` tetap konsisten?

Jawaban saya:

---

### 2. Architecture

Pisahkan tanggung jawab terlebih dahulu, lalu tentukan satu atau beberapa module sesuai kebutuhan. Tabel architecture tidak wajib.

Hierarchy / block diagram saya:

---

Responsibility setiap block — input yang diperlukan, output yang dijanjikan, dan kondisi gagal yang ditangani:

---

Signal, arah port, dan width yang melewati batas module:

---

### 3. Data and Control Flow

Tunjukkan perjalanan payload, tag, serta keputusan dan status penerimaan. Boleh anotasi diagram architecture yang sama.

Alur dan ketergantungan menurut saya:

---

### 4. Logic Design

Logic equation / aturan keputusan yang saya turunkan:

---

Logic circuit / datapath saya untuk keputusan penerimaan:

---

### 5. Prediction

Isi sebelum RTL dan simulation; setiap case independen.

- Input: (`command`, `dispatch_on`, `ready`, `locked`).
- Uraian field: (present, destination, override_lock, tag, payload).
- Prediksi semua output: (`a_data`, `b_data`, `a_tag`, `b_tag`, `accepted`, `rejected`, `bad_command`).

Tulis tuple pada kolom kosong sesuai urutan tersebut.

| Case | Input | Uraian field command | Prediksi semua output |
|---|---|---|---|
| 1 | `(16'h8A35, 1, 2'b01, 2'b00)` |  |  |
| 2 | `(16'hAA35, 1, 2'b10, 2'b01)` |  |  |
| 3 | `(16'hCA35, 1, 2'b11, 2'b00)` |  |  |
| 4 | `(16'hCA35, 1, 2'b01, 2'b00)` |  |  |
| 5 | `(16'hCA35, 1, 2'b11, 2'b10)` |  |  |
| 6 | `(16'hDA35, 1, 2'b11, 2'b11)` |  |  |
| 7 | `(16'hDA35, 1, 2'b01, 2'b11)` |  |  |
| 8 | `(16'hEA35, 1, 2'b11, 2'b00)` |  |  |
| 9 | `(16'hFA35, 0, 2'b11, 2'b00)` |  |  |
| 10 | `(16'h0A35, 1, 2'b11, 2'b00)` |  |  |
| 11 | `(16'h9A35, 0, 2'b11, 2'b11)` |  |  |
| 12 | `(16'h8000, 1, 2'b01, 2'b00)` |  |  |

Alasan untuk case penting:

---

### 6. Verification Plan

Pilih beberapa kondisi yang paling rawan salah pada desainmu dan cara mengeceknya. Target lengkap tetap mengikuti `problem.md`; tidak perlu menyalin seluruh daftar.

Kondisi penting dan cara memeriksanya:

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
