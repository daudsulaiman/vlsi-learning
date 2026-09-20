## my prediction
|Case|a|b|sel|y|
|----|-|-|---|-|
| 1  |0|1| 0 |0|
| 2  |0|1| 1 |1|
| 3  |1|0| 0 |1|
| 4  |1|0| 1 |0|
| 5  |1|1| 0 |1|
| 6  |0|0| 1 |0|

if sel = 0 and only b changes, y is not changing because in sel = 0, y = a.

assign y = sel ? b : a;
artinya y adalah nilai sel itu apa? jika true/1 maka b jika false/0 maka a. ditulis dalam syntax seperti diatas

# 01 — Multiplexer dan Testbench Dasar

## 1. Target Belajar

Saya ingin paham cara kerja mux 2-to-1, menulis Verilog-nya sendiri,
dan menguji hasilnya lewat simulasi.

## 2. Apa Itu Multiplexer?

Multiplexer atau mux adalah rangkaian untuk memilih satu dari beberapa
input, lalu meneruskannya ke output.

Pada mux 2-to-1, ada:
- a dan b: dua input data.
- sel: sinyal untuk menentukan input mana yang dipilih.
- y: output hasil pemilihan.

Aturannya:
- sel = 0 → y mengikuti a.
- sel = 1 → y mengikuti b.

Jadi sel itu penentunya, bukan data yang langsung dimasukkan ke y.

Kalau sel = 0 dan hanya b yang berubah, y tidak berubah karena yang
sedang dipilih adalah a.

Mux ini termasuk combinational circuit: output ditentukan oleh input
saat itu. Tidak ada clock dan tidak menyimpan keadaan sebelumnya.

Contoh penggunaan: memilih apakah data yang diteruskan berasal dari
sumber A atau sumber B.

## 3. Syntax Verilog yang Saya Pakai

```verilog
module mux2(input a, input b, input sel, output y);

assign y = sel ? b : a;

endmodule
```

Penjelasan:
- module mux2: mendefinisikan rangkaian bernama mux2.
- input dan output: menentukan arah port.
- assign: membuat hubungan logika yang terus aktif.
- endmodule: menutup definisi module.

Bentuk conditional operator:

```verilog
condition ? value_if_true : value_if_false
```

Jadi:

```verilog
assign y = sel ? b : a;
```

Saya membacanya:
“y mengikuti b jika sel = 1, dan mengikuti a jika sel = 0.”

Assign bukan perintah yang hanya dijalankan sekali. Ketika input berubah,
output akan diperbarui sesuai hubungan logikanya dalam simulasi.

## 4. Bedanya input a dan input wire a

Dalam deklarasi Verilog yang saya pakai, keduanya sama:

```verilog
input a
input wire a
```

- input menjelaskan arah port: masuk ke module.
- wire menjelaskan jenis sinyalnya.

Kalau wire tidak ditulis pada deklarasi input ini, default-nya sudah wire.

## 5. Bedanya wire dan reg

Cara saya membedakannya sekarang:

- wire: nilainya berasal dari driver, misalnya assign atau output module.
- reg: variabel yang bisa diberi nilai di dalam initial atau always.

Di testbench saya:

```verilog
reg a;
reg b;
reg sel;
wire y;
```

a, b, dan sel memakai reg karena nilainya saya atur lewat initial.
y memakai wire karena nilainya diberikan oleh output mux.

Hal penting:
reg tidak otomatis berarti register fisik.

Hardware yang terbentuk bergantung pada perilaku keseluruhan kode.
Di testbench ini, reg digunakan sebagai variabel simulasi.

## 6. Apa Itu Testbench?

Testbench adalah kode untuk memberikan input ke desain dan mengamati
outputnya.

Kalau mux dianggap sebagai board yang diuji, testbench berperan sebagai
pemberi sinyal dan alat pengamatnya.

Di HDLBits, pengujiannya sudah disediakan. Di Ubuntu, saya menyediakan
testbench sendiri.

Testbench saya membuat input dari dalam, jadi module mux2_tb tidak
memerlukan port input/output eksternal.

## 7. Menghubungkan Testbench dengan Desain

```verilog
mux2 dut (
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);
```

- mux2: nama module yang digunakan.
- dut: nama instance, singkatan dari Device Under Test.
- instance: penggunaan module tersebut di dalam module lain.

Bentuk koneksi port:

```verilog
.nama_port_desain(nama_sinyal_testbench)
```

Jadi .a(a) berarti port a milik mux2 dihubungkan ke sinyal a
di dalam testbench.

Namanya sama supaya mudah dibaca, tetapi berada di lingkup module berbeda.

## 8. Alur Testbench Saya

1. Membuat instance mux2.
2. Memberikan nilai ke a, b, dan sel.
3. Mux menentukan y sesuai input tersebut.
4. Menampilkan dan merekam perubahan sinyal.
5. Menunggu 10 ns sebelum memberi kombinasi berikutnya.
6. Mengakhiri simulasi setelah semua kombinasi dicoba.

### initial

```verilog
initial begin
    ...
end
```

Blok ini berjalan sekali sejak awal simulasi.
Perintah di dalamnya berjalan berurutan.

### timescale dan delay

```verilog
`timescale 1ns/1ps
```

- 1ns: satuan waktu.
- 1ps: ketelitian waktu simulasi.

Dengan pengaturan ini:

```verilog
#10;
```

berarti menunggu 10 ns sebelum melanjutkan perintah berikutnya.

Delay ini mengatur jarak waktu pemberian input di testbench.
Bukan berarti hardware mux punya delay 10 ns.

### Perintah untuk mengamati simulasi

- $monitor: menampilkan nilai ketika sinyal yang dipantau berubah.
- $time: waktu simulasi sekarang.
- %b: menampilkan nilai binary.
- %0t: menampilkan waktu.
- $dumpfile: menentukan nama file waveform.
- $dumpvars: menentukan sinyal yang direkam.
- $finish: mengakhiri simulasi.

File VCD berisi rekaman perubahan sinyal dan bisa dibuka di GTKWave.

## 9. Hasil Pengujian

Ada tiga input, masing-masing 1 bit.
Setiap input punya dua kemungkinan binary, yaitu 0 atau 1.

Jumlah kombinasi = 2 × 2 × 2 = 8.

| a | b | sel | y yang diharapkan |
|---|---|-----|-------------------|
| 0 | 0 | 0   | 0                 |
| 0 | 0 | 1   | 0                 |
| 0 | 1 | 0   | 0                 |
| 0 | 1 | 1   | 1                 |
| 1 | 0 | 0   | 1                 |
| 1 | 0 | 1   | 0                 |
| 1 | 1 | 0   | 1                 |
| 1 | 1 | 1   | 1                 |

Hasil:
- RTL berhasil di-compile.
- Simulasi berhasil dijalankan.
- Semua delapan kombinasi menghasilkan output yang sesuai.

Saya masih membandingkan hasilnya secara manual.
Testbench belum otomatis memberikan status PASS atau FAIL.

Pengujian ini mencakup input binary 0 dan 1.
Perilaku nilai x dan z belum dibahas.

## 10. Lokasi File dan Command

Folder latihan:

```text
~/Learning/vlsi/vlsi-learning/verilog/01-mux
```

Isi folder:
- notes.md: catatan pemahaman.
- problems.md: soal latihan.
- rtl/mux2.v: desain rangkaian.
- tb/mux2_tb.v: kode pengujian.
- sim/: hasil compile dan rekaman waveform.

Masuk ke folder latihan:

```bash
cd ~/Learning/vlsi/vlsi-learning/verilog/01-mux
```

Compile desain dan testbench:

```bash
iverilog -g2012 -s mux2_tb -o sim/mux2_sim rtl/mux2.v tb/mux2_tb.v
```

- -g2012: menggunakan mode bahasa SystemVerilog 2012.
- -s mux2_tb: memilih testbench sebagai top module simulasi.
- -o: menentukan lokasi hasil compile.
- Kedua file .v disertakan supaya desain dan pengujiannya tersedia.

Jalankan simulasi:

```bash
vvp sim/mux2_sim
```

Buka waveform:

```bash
gtkwave sim/mux2.vcd
```

## 11. Masalah Tool yang Belum Selesai

Simulasi Icarus sudah berjalan dan output benar, tetapi diagnostik
editor VS Code masih bermasalah.

Yang sudah dilakukan:
- Memastikan kedua file memiliki timescale 1ns/1ps.
- Mengganti linter editor dari Verilator menjadi iverilog.
- Menambahkan argumen -y yang mengarah ke folder rtl.

Pesan yang pernah muncul:
- TIMESCALEMOD.
- Unknown module type: mux2.

Troubleshooting editor ditunda dulu.

Pelajaran:
Pemeriksaan editor dan simulasi terminal adalah proses terpisah.
Command terminal yang berhasil belum tentu berarti konfigurasi
pemeriksa editor sudah benar.

## 12. Posisi Belajar Saya Sekarang

Yang sudah saya kerjakan sendiri:
- Memprediksi output mux.
- Menjelaskan pengaruh sel.
- Menulis RTL mux menggunakan conditional operator.

Testbench awal masih dibantu.
Saya belum menganggap diri saya bisa menulis testbench mandiri dari nol.

## 13. Latihan Berikutnya

Menulis ulang mux yang sama memakai operator:
- ~ : NOT
- & : AND
- | : OR

Ketentuan:
- Tetap menggunakan assign.
- Tidak menggunakan operator ?:.
- Nama module dan port tetap sama.
- Menggunakan kembali testbench yang sudah ada.

Saya akan menurunkan ekspresi Boolean dulu, lalu menuliskannya
ke Verilog dan membandingkan hasil simulasi.

## 14. Yang Masih Perlu Saya Latih

- Menulis koneksi instance tanpa menyalin contoh.
- Mengubah stimulus testbench sendiri.
- Membaca waveform dan menghubungkannya dengan stimulus.
- Menjelaskan wire dan reg tanpa menganggap reg selalu register fisik.
- Nanti belajar membuat testbench yang memeriksa hasil secara otomatis.
