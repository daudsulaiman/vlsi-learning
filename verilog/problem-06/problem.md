# Problem 06 — Distribusi Command ke Dua Endpoint

Level: **Design · specification decomposition**. Batas materi RTL: **Operators → Vectors → Modules**.

## 1. Context

Sebuah command 16-bit membawa tujuan, tag, dan payload untuk dua endpoint. Endpoint adalah tujuan penerima data. Sebagian command ditujukan ke satu endpoint, sedangkan yang lain harus diterima oleh keduanya secara bersamaan.

Kesulitannya adalah menyatukan aturan tujuan, kesiapan, penguncian, dan pelaporan penolakan. Ini kontrak signal parallel buatan untuk latihan, bukan protokol komunikasi yang perlu kamu pelajari.

## 2. Specification

Format command:

| Bit `command` | Field | Arti |
|---|---|---|
| `[15]` | present | Ada command yang diajukan |
| `[14:13]` | destination | `00`: A; `01`: B; `10`: A dan B; `11`: tidak sah |
| `[12]` | override_lock | Izin mengabaikan lock pada endpoint tujuan |
| `[11:8]` | tag | Identitas 4-bit yang diteruskan bersama payload |
| `[7:0]` | payload | Data 8-bit |

Pada `ready`, `locked`, dan `accepted`, bit 0 selalu mewakili A dan bit 1 selalu mewakili B.

Endpoint dapat menerima ketika siap dan tidak terkunci. `override_lock` membolehkan penerimaan saat terkunci, tetapi tidak membebaskan syarat ready, tidak mengaktifkan sistem yang dimatikan, dan tidak mengesahkan destination `11`.

Command untuk kedua endpoint bersifat **atomic**: keduanya menerima atau tidak ada yang menerima. Tidak ada penerimaan sebagian.

## 3. Interface Requirements

| Arah | Signal | Width | Arti |
|---|---|---:|---|
| Input | `command` | 16 | Command sesuai format field |
| Input | `dispatch_on` | 1 | Distribusi diaktifkan |
| Input | `ready` | 2 | Kesiapan endpoint B dan A |
| Input | `locked` | 2 | Status lock endpoint B dan A |
| Output | `a_data` | 8 | Payload yang diterima A |
| Output | `b_data` | 8 | Payload yang diterima B |
| Output | `a_tag` | 4 | Tag yang diterima A |
| Output | `b_tag` | 4 | Tag yang diterima B |
| Output | `accepted` | 2 | Endpoint yang menerima command saat ini |
| Output | `rejected` | 1 | Command yang diajukan tidak diterima |
| Output | `bad_command` | 1 | Command yang diajukan memakai destination tidak sah |

## 4. Behavioral Requirements

1. Tanpa present, tidak ada penerimaan atau penolakan; seluruh output nol, apa pun field lain.
2. Penerimaan memerlukan present aktif, `dispatch_on` aktif, destination sah, dan kesiapan serta aturan lock untuk semua endpoint yang dituju terpenuhi.
3. Destination A hanya memeriksa kondisi A. Kondisi B tidak boleh menggagalkannya. Aturan yang sama berlaku untuk destination B.
4. Destination A dan B hanya diterima jika kedua endpoint memenuhi syarat. Jika salah satunya gagal, keduanya tidak menerima.
5. Endpoint yang menerima mendapatkan payload dan tag persis dari command. Endpoint yang tidak menerima wajib memiliki data dan tag nol.
6. `rejected` aktif ketika present aktif tetapi tidak ada endpoint yang menerima. Ini mencakup sistem tidak aktif, destination tidak sah, atau syarat endpoint tidak terpenuhi.
7. `bad_command` aktif ketika present aktif dan destination `11`. Pemeriksaan ini tetap berlaku saat `dispatch_on` tidak aktif.
8. Destination tidak sah selalu menghasilkan tidak ada penerimaan. Payload, tag, dan override tidak mengubah ketidaksahannya.
9. Payload atau tag bernilai nol tetap dapat diterima; keabsahan penerimaan ditunjukkan oleh `accepted`.

## 5. Engineering Questions — Before Coding

1. Aturan mana yang berkaitan dengan keabsahan command, dan aturan mana yang berkaitan dengan kemampuan endpoint menerima?
2. Mengapa kata atomic memengaruhi keputusan penerimaan untuk dua endpoint?
3. Apa batas kewenangan override menurut spesifikasi?
4. Status mana yang masih dapat aktif saat distribusi dimatikan? Jelaskan dari kontrak, bukan dari perkiraan.
5. Apa tanggung jawab terpisah yang kamu temukan, dan informasi apa yang harus melintasi setiap batas tanggung jawab?
6. Bagaimana kamu memeriksa agar payload, tag, penerimaan, dan penolakan tidak saling bertentangan?

## 6. Prediction Cases

Untuk setiap case, uraikan dulu semua field `command`, lalu prediksi **semua tujuh output**. Setiap baris independen.

| Case | `command` | `dispatch_on` | `ready` | `locked` |
|---|---|---:|---|---|
| 1 | `16'h8A35` | 1 | `2'b01` | `2'b00` |
| 2 | `16'hAA35` | 1 | `2'b10` | `2'b01` |
| 3 | `16'hCA35` | 1 | `2'b11` | `2'b00` |
| 4 | `16'hCA35` | 1 | `2'b01` | `2'b00` |
| 5 | `16'hCA35` | 1 | `2'b11` | `2'b10` |
| 6 | `16'hDA35` | 1 | `2'b11` | `2'b11` |
| 7 | `16'hDA35` | 1 | `2'b01` | `2'b11` |
| 8 | `16'hEA35` | 1 | `2'b11` | `2'b00` |
| 9 | `16'hFA35` | 0 | `2'b11` | `2'b00` |
| 10 | `16'h0A35` | 1 | `2'b11` | `2'b00` |
| 11 | `16'h9A35` | 0 | `2'b11` | `2'b11` |
| 12 | `16'h8000` | 1 | `2'b01` | `2'b00` |

## 7. Architecture Task

Buat decomposition sebelum menentukan jumlah module. Untuk setiap tanggung jawab yang kamu usulkan, tulis input yang benar-benar dibutuhkan, output yang dijanjikan, dan kondisi gagal yang ditanganinya.

Setelah itu pilih satu module atau beberapa module, lalu jelaskan trade-off keterbacaan dan pemeriksaannya. Kamu bertanggung jawab menentukan batas architecture; tidak ada bentuk diagram wajib.

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

- Uji semua destination, kedua nilai present, kedua nilai override, dan kedua nilai `dispatch_on`.
- Untuk satu tag dan payload, uji semua kombinasi ready dan locked terhadap control tersebut: total 512 kombinasi control.
- Tambahkan payload dan tag berbeda, termasuk nol dan nilai maksimum.
- Uji command satu tujuan ketika endpoint lain tidak siap atau terkunci.
- Uji command dua tujuan ketika hanya satu endpoint memenuhi syarat.
- Pastikan override tidak mengabaikan readiness atau destination tidak sah.
- Uji `bad_command` ketika sistem aktif maupun tidak aktif.
- Periksa bahwa endpoint yang tidak menerima selalu memiliki data dan tag nol.

## 10. Synthesis Questions

1. Bagaimana aturan atomic tercermin dalam ketergantungan output hasil synthesis?
2. Apakah pembagian source code yang kamu pilih masih tampak dalam laporan hierarchy?
3. Apakah tool membagi atau menyederhanakan pemeriksaan yang dipakai beberapa output?
4. Output mana yang menurutmu membutuhkan keputusan paling panjang? Bandingkan terhadap koneksi hasil synthesis, tanpa menganggap statistik cell sebagai pengukuran delay.

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
- [ ] Saya dapat menjelaskan penerimaan atomic, batas override, dan penolakan ketika sistem tidak aktif menggunakan contoh buatan sendiri.
