# Problem 03 — Penyusunan Word Telemetri

Level: **Medium · vector dan bit-field**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Sebuah sumber menghasilkan metadata dan satu byte payload secara paralel. Blok penerima membutuhkan satu word 16-bit dengan susunan field tertentu. Dua perangkat sumber menggunakan urutan nibble yang berbeda.

Nibble adalah kelompok 4 bit. Ini latihan pengolahan signal paralel, bukan implementasi protokol serial.

## 2. Specification

Metadata berformat berikut. Nomor bit di kiri lebih tinggi.

| Bit `meta` | Field | Arti |
|---|---|---|
| `[7]` | present | Sample tersedia |
| `[6]` | fault | Sumber melaporkan gangguan |
| `[5:4]` | target | Identitas tujuan 2-bit; semua empat nilai sah |
| `[3:0]` | tag | Identitas sample 4-bit; semua nilai sah |

Sample sah hanya ketika present aktif dan fault tidak aktif. `swap_halves` menentukan urutan dua nibble payload. Nilai `0` mempertahankan urutan; nilai `1` menukar posisi nibble atas dan bawah, tanpa membalik urutan bit di dalam nibble.

Untuk sample sah, word keluaran memiliki kontrak berikut:

| Bit `frame` | Isi |
|---|---|
| `[15:14]` | Field target |
| `[13:10]` | Field tag |
| `[9:2]` | Payload setelah penyesuaian urutan nibble |
| `[1:0]` | Penanda tetap `2'b01` |

Untuk sample tidak sah, seluruh `frame` wajib nol, termasuk lokasi penanda.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `meta` | 8 | Metadata sesuai tabel field |
| Input | `payload` | 8 | Byte sample sebelum penyesuaian urutan |
| Input | `swap_halves` | 1 | Permintaan menukar posisi dua nibble payload |
| Output | `frame` | 16 | Word keluaran sesuai format yang diminta |
| Output | `frame_valid` | 1 | Word berasal dari sample sah |

## 4. Behavioral Requirements

1. Keabsahan sample ditentukan hanya oleh field present dan fault.
2. Target, tag, payload, dan pilihan urutan nibble tidak dapat membuat sample tidak sah menjadi sah.
3. Saat sample sah, `frame_valid` aktif dan setiap posisi field harus mengikuti tabel keluaran.
4. Saat sample tidak sah, `frame_valid` tidak aktif dan `frame` seluruhnya nol.
5. Penukaran nibble hanya memengaruhi payload, bukan target, tag, atau penanda.
6. Semua bit metadata dan payload memiliki posisi yang tetap; tidak ada field dengan panjang berubah.

## 5. Engineering Questions — Before Coding

1. Apa beda field data, identitas, dan penanda keabsahan dalam input ini?
2. Berapa total bit yang dibutuhkan semua field keluaran? Bagaimana kamu memeriksa agar tidak ada bit tumpang tindih atau terlewat?
3. Apakah menukar dua nibble sama dengan membalik delapan bit? Jelaskan menggunakan contoh pilihanmu sendiri.
4. Bagaimana kamu membedakan isi payload bernilai nol dengan sample yang tidak sah?
5. Bagian pekerjaan mana yang mungkin hanya mengubah sambungan bit, dan bagian mana yang memerlukan keputusan logic? Buat prediksimu.
6. Apa tanggung jawab yang masuk akal untuk dipisahkan, jika kamu memilih beberapa module?

## 6. Prediction Cases

Prediksi `frame_valid` dan `frame`. Tulis `frame` dalam 16-bit binary dan 4 digit hexadecimal agar posisi field dapat diperiksa.

| Case | `meta` | `payload` | `swap_halves` |
|---|---|---|---:|
| 1 | `8'h9A` | `8'h3C` | 0 |
| 2 | `8'h9A` | `8'h3C` | 1 |
| 3 | `8'hB5` | `8'h96` | 1 |
| 4 | `8'hDA` | `8'h3C` | 0 |
| 5 | `8'h1A` | `8'hF0` | 1 |
| 6 | `8'h80` | `8'h00` | 0 |
| 7 | `8'hBF` | `8'hFF` | 1 |
| 8 | `8'h5F` | `8'h81` | 1 |

## 7. Architecture Task

Gambar perjalanan field dari input menuju posisi keluaran. Tunjukkan lebar signal dalam prediksimu serta bagian yang dipengaruhi control. Tentukan sendiri apakah perlu submodule.

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

## 9. Verification Targets

- Uji keempat kombinasi present dan fault.
- Uji semua nilai target dan beberapa tag, termasuk nilai terkecil dan terbesar.
- Gunakan payload dengan dua nibble berbeda dan urutan bit yang tidak simetris.
- Uji payload semua nol dan semua satu.
- Pastikan seluruh 16 bit nol pada sample tidak sah, termasuk penanda.
- Periksa bahwa mengubah tag atau target tidak mengubah lokasi bit payload.

## 10. Synthesis Questions

1. Apakah setiap perubahan posisi bit membutuhkan cell logic? Bandingkan prediksimu dengan koneksi dalam hasil synthesis.
2. Bagaimana penanda konstan direpresentasikan setelah synthesis?
3. Bagian mana yang tetap bergantung pada `swap_halves`?
4. Apakah jumlah cell saja cukup untuk memverifikasi susunan field? Bukti lain apa yang kamu perlukan?

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
