# Problem 04 — Penyaluran Sample dengan Cadangan

Level: **Medium · data routing dan validity**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Empat sumber menyediakan sample 8-bit. Pengguna meminta satu sumber. Jika sumber yang diminta tidak tersedia, kebijakan tertentu membolehkan penggunaan sumber 0 sebagai cadangan.

Penerima harus mengetahui asal sample yang benar-benar diteruskan. Latihan ini menggabungkan pemilihan data, keabsahan, dan metadata keluaran.

## 2. Specification

- `select` menyatakan nomor sumber yang diminta: nilai binary `00`, `01`, `10`, dan `11` berarti sumber 0, 1, 2, dan 3.
- Bit ke-i dari `available` menyatakan keabsahan `data_i`. Jadi bit 0 untuk sumber 0, hingga bit 3 untuk sumber 3.
- `route_on` mengaktifkan fungsi penyaluran.
- Sumber yang diminta selalu diprioritaskan bila tersedia.
- Jika sumber yang diminta tidak tersedia, sumber 0 boleh dipakai hanya ketika `allow_fallback` aktif dan sumber 0 tersedia.
- Sumber 1, 2, atau 3 yang tidak diminta tidak dipakai sebagai cadangan.

Fallback berarti memakai sumber cadangan akibat sumber yang diminta tidak tersedia. Meminta sumber 0 dan menerimanya secara langsung bukan fallback.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `data_0` | 8 | Sample sumber 0 |
| Input | `data_1` | 8 | Sample sumber 1 |
| Input | `data_2` | 8 | Sample sumber 2 |
| Input | `data_3` | 8 | Sample sumber 3 |
| Input | `available` | 4 | Bit keabsahan masing-masing sumber |
| Input | `select` | 2 | Nomor sumber yang diminta |
| Input | `allow_fallback` | 1 | Cadangan sumber 0 diizinkan |
| Input | `route_on` | 1 | Penyaluran diaktifkan |
| Output | `routed_data` | 8 | Sample yang diteruskan |
| Output | `routed_valid` | 1 | Ada sample sah yang diteruskan |
| Output | `source_id` | 2 | Nomor sumber yang benar-benar digunakan |
| Output | `used_fallback` | 1 | Sample berasal dari mekanisme cadangan |

## 4. Behavioral Requirements

1. Saat `route_on` tidak aktif, semua output bernilai nol.
2. Saat aktif dan sumber yang diminta tersedia, teruskan sample sumber tersebut, nyatakan valid, dan laporkan nomor sumbernya. `used_fallback` tidak aktif.
3. Saat aktif, sumber yang diminta tidak tersedia, dan cadangan memenuhi syarat, teruskan sumber 0, nyatakan valid, dan aktifkan `used_fallback`.
4. Pada keadaan lain tidak ada sample yang diteruskan: keempat output wajib nol.
5. Jika sumber 0 diminta tetapi tidak tersedia, tidak ada sumber alternatif yang boleh dipakai.
6. Sample dengan data nol tetap merupakan sample sah jika syarat keabsahannya terpenuhi.
7. `source_id` bernilai nol ketika tidak valid; penerima harus menafsirkan identitas bersama `routed_valid`.

## 5. Engineering Questions — Before Coding

1. Mengapa nomor sumber yang diminta bisa berbeda dari nomor sumber keluaran?
2. Apa perbedaan sumber tersedia dengan sumber terpilih?
3. Apakah sample bernilai nol cukup untuk menentukan keabsahan? Jelaskan.
4. Apa yang harus terjadi jika sumber 0 diminta dan tidak tersedia, tetapi sumber lain tersedia?
5. Bagaimana kamu memastikan data, identitas, dan status selalu menggambarkan keputusan yang sama?
6. Apa kemungkinan pemisahan tanggung jawab dan intermediate signal yang berguna? Tentukan sendiri.

## 6. Prediction Cases

Pada setiap case, gunakan `data_0=8'h00`, `data_1=8'h3C`, `data_2=8'hA5`, dan `data_3=8'h96`. Semua case independen. Hitung keempat output.

| Case | `available` | `select` | `allow_fallback` | `route_on` |
|---|---|---|---:|---:|
| 1 | `4'b1111` | `2'b00` | 1 | 1 |
| 2 | `4'b1111` | `2'b10` | 1 | 1 |
| 3 | `4'b1011` | `2'b10` | 1 | 1 |
| 4 | `4'b1011` | `2'b10` | 0 | 1 |
| 5 | `4'b1010` | `2'b10` | 1 | 1 |
| 6 | `4'b1110` | `2'b00` | 1 | 1 |
| 7 | `4'b1000` | `2'b11` | 0 | 1 |
| 8 | `4'b0000` | `2'b01` | 1 | 1 |
| 9 | `4'b1111` | `2'b11` | 1 | 0 |
| 10 | `4'b0001` | `2'b01` | 1 | 1 |

## 7. Architecture Task

Susun gambar aliran data dan control yang menjelaskan cara semua output mengikuti satu kebijakan penyaluran. Tentukan sendiri hardware dan batas module. Beri width pada setiap jalur yang kamu usulkan.

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

- Uji semua 256 kombinasi `available`, `select`, `allow_fallback`, dan `route_on` dengan satu set data yang berbeda antar-sumber.
- Tambahkan set data lain, termasuk semua sumber bernilai sama dan sample valid bernilai nol.
- Uji cadangan tersedia, tidak tersedia, dan tidak diizinkan.
- Uji sumber 0 ketika diminta langsung dan ketika digunakan sebagai cadangan.
- Pastikan tidak ada pencarian ke sumber lain di luar kontrak.
- Periksa konsistensi asal data dan `used_fallback` pada waveform.

## 10. Synthesis Questions

1. Bandingkan hardware yang kamu prediksi untuk data dan untuk status.
2. Apakah hasil synthesis memperlihatkan keputusan yang digunakan bersama oleh beberapa output?
3. Perubahan input mana yang menurutmu melewati logic paling panjang sebelum sampai ke output? Jelaskan secara kualitatif.
4. Mengapa laporan jumlah cell belum memberikan waktu propagasi fisik dalam nanosecond?

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
