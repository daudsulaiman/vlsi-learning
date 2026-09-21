# Notes — Problem 08

## BAGIAN A — Syntax / Concept Reference

Reference ini mengingatkan syntax yang sudah dipelajari. Nama dan contoh bersifat generik, bukan rancangan untuk problem. Kamu menentukan sendiri expression, hardware, serta batas module yang sesuai spesifikasi.

### Module, port, dan wire

`module` mendefinisikan satu jenis blok. Port menjadi batas input-output blok tersebut. `wire` menyatakan sambungan signal; deklarasinya sendiri tidak berarti ada penyimpanan.

Contoh generik berikut hanya menunjukkan bentuk module dan port:

```verilog
module demo_wire (
    input  wire [4:0] in_bus,
    output wire [4:0] out_bus
);
    assign out_bus = in_bus;
endmodule
```

### Continuous assignment

`assign` menyatakan hubungan yang terus berlaku. Saat nilai di sisi kanan berubah, simulator menjadwalkan pembaruan sisi kiri; ini bukan langkah program yang hanya dijalankan sekali.

```verilog
wire sig_p;
wire sig_q;
wire sig_r;
assign sig_r = sig_p & sig_q;
```

Contoh-contoh dalam reference adalah potongan terpisah. Signal input contoh harus mempunyai penggerak jika dipakai dalam rancangan nyata.

### Operators dan literal

| Syntax | Makna umum |
|---|---|
| `~` | Bitwise NOT: membalik setiap bit operand |
| `&`, `\|`, `^` | Bitwise AND, OR, XOR pada posisi bit yang bersesuaian |
| `!` | Logical NOT: memeriksa apakah operand bernilai logis salah |
| `&&`, `\|\|` | Logical AND, OR; menghasilkan keputusan logis 1-bit |
| `==`, `!=` | Memeriksa kesamaan atau ketidaksamaan nilai |
| `>`, `<`, `>=`, `<=` | Perbandingan; interpretasi signed/unsigned harus konsisten |
| `1'b0` | Literal 1-bit dalam binary |
| `5'b10110` | Literal 5-bit dalam binary |
| `12'h35A` | Literal 12-bit dalam hexadecimal |

Gunakan tanda kurung agar maksud pengelompokan expression jelas. Untuk latihan ini, deklarasikan data sebagai unsigned dan hindari mencampur width tanpa alasan yang dapat kamu jelaskan.

### Width hasil expression

Bitwise operation bekerja per bit, sedangkan logical operation dan comparison menghasilkan keputusan 1-bit. Jangan menganggap `~` sama dengan `!`, atau `&` sama dengan `&&`, pada vector.

Output yang ditulis melalui `assign` dapat dideklarasikan sebagai `output wire`. Pemberian nama sebuah signal sebagai status tidak membuatnya menjadi register; jenis hardware mengikuti perilaku yang dijelaskan RTL.

### Vector, bit-select, dan part-select

```verilog
wire [11:0] sample_bus;
wire single_bit;
wire [2:0] portion;

assign single_bit = sample_bus[8];
assign portion = sample_bus[6:4];
```

`[11:0]` memiliki 12 posisi bit. Bit-select mengambil satu bit; part-select mengambil rentang tetap. Pada deklarasi menurun seperti ini, tulis part-select dengan indeks tinggi di kiri.

### Concatenation dan replication

```verilog
wire [2:0] triad;
wire [4:0] quintet;
wire [7:0] joined_bus;
wire [5:0] repeated_bus;

assign joined_bus = {triad, quintet};
assign repeated_bus = {3{2'b10}};
```

Concatenation menggabungkan bit tanpa penjumlahan. Elemen paling kiri mengisi posisi bit paling tinggi. Width gabungan adalah jumlah width semua elemen. Replication mengulang pola dengan jumlah tetap.

### Conditional operator

```verilog
assign line_r = cond_x ? line_p : line_q;
```

Pada kondisi 0/1, expression memilih nilai alternatif sesuai kondisi. Usahakan kedua alternatif mempunyai width yang sesuai dengan tujuan assignment. Contoh ini tidak menentukan architecture problem.

### Module instantiation dan named port connection

Definisi `demo_wire` pada contoh awal dapat digunakan sebagai berikut. `bus_k` dan `bus_m` merupakan nama signal lokal contoh, masing-masing 5 bit.

```verilog
demo_wire u_example (
    .in_bus(bus_k),
    .out_bus(bus_m)
);
```

`demo_wire` adalah nama jenis module; `u_example` adalah nama instance. Pada `.in_bus(bus_k)`, nama di kiri adalah port milik module yang di-instance, sedangkan nama di dalam tanda kurung adalah signal pada module yang memuat instance.

Named port connection dipasangkan berdasarkan nama, bukan urutan tulisan. Tetap periksa arah dan width. Dua instance dari satu definisi adalah dua instance hardware sebelum optimasi; ini bukan pemanggilan function yang bergantian memakai satu blok.

Intermediate signal menghubungkan output suatu instance ke input instance lain sesuai kontrak port. Mendeklarasikan `wire` saja tidak memberinya nilai; harus ada penggerak yang benar.

## BAGIAN B — My Engineering Worksheet

Isi bagian 1–11 sebelum menulis RTL. Catat prediction awal dengan jujur; jika salah, tulis koreksinya setelah simulation agar proses berpikirmu tetap terlihat. Semua ruang jawaban di bawah sengaja kosong.

### 1. What is this circuit supposed to do?

Jawaban saya:

---

### 2. Inputs

| Signal | Width | Function |
|---|---:|---|
| | | |
| | | |

### 3. Outputs

| Signal | Width | Function |
|---|---:|---|
| | | |
| | | |

### 4. Data Signals

Jawaban saya:

---

### 5. Control Signals

Jawaban saya:

---

### 6. My Hardware Prediction

Menurut saya hardware yang dibutuhkan:

---

Alasan:

---

### 7. My Architecture

Block / signal flow dan width:

---

Pilihan pembagian module dan alasan:

---

| Module / instance yang saya usulkan | Responsibility | Input dan width | Output dan width |
|---|---|---|---|
| | | | |

### 8. Intermediate Signals I May Need

| Signal | Width | Penggerak | Pengguna | Tujuan |
|---|---:|---|---|---|
| | | | | |

### 9. Answers to Pre-Coding Questions

Nomor Q di bawah mengikuti urutan pertanyaan pada bagian 5 `problem.md`.

### Q1

Jawaban saya:

---

### Q2

Jawaban saya:

---

### Q3

Jawaban saya:

---

### Q4

Jawaban saya:

---

### Q5

Jawaban saya:

---

### Q6

Jawaban saya:

---

### 10. Prediction Before Simulation

Isi seluruh output yang diminta, bukan hanya output data utama. Salin atau uraikan input tiap case dari spesifikasi.

| Case | Input | My Predicted Output |
|---|---|---|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |
| 6 | | |
| 7 | | |
| 8 | | |
| 9 | | |
| 10 | | |
| 11 | | |
| 12 | | |
| 13 | | |
| 14 | | |
| 15 | | |

Alasan atau perhitungan manual saya:

---

### 11. RTL Plan

Sebelum coding, rencana implementasi saya:

---

Rencana pengujian dan case tambahan buatan saya:

---

### 12. After Simulation

Apakah hasil simulation sama dengan prediction?

---

Jika tidak, kesalahan saya berada di:

---

| Case yang berbeda | Prediction awal | Hasil pengamatan | Penyebab dan perbaikan |
|---|---|---|---|
| | | | |

Bagian testbench yang saya tulis sendiri / masih dibantu:

---

### 13. Waveform Observation

Hal penting yang saya lihat:

---

Signal dan case yang saya periksa, beserta lokasi VCD / catatan:

---

### 14. Before Synthesis Prediction

Saya memperkirakan hardware hasil synthesis berupa:

---

Alasan dan dugaan jalur logic terpanjang:

---

### 15. After Synthesis

Command yang saya jalankan dan lokasi log:

---

Cell / logic dan hierarchy yang dihasilkan:

---

Apakah sesuai prediction? Apa yang berubah atau dioptimasi?

---

Jawaban saya atas Synthesis Questions pada problem:

---

Hal yang belum dapat disimpulkan dari laporan ini:

---

### 16. What I Learned

---

### 17. Mistakes

---

### 18. Things I Still Don't Understand

---
