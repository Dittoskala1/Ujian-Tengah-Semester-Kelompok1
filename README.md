# Functional API Automation Testing pada Fitur Login JWT dan Manajemen Akun

[![API Automation Test](https://github.com/Dittoskala1/Ujian-Tengah-Semester-Kelompok1/actions/workflows/api-test.yml/badge.svg)](https://github.com/Dittoskala1/Ujian-Tengah-Semester-Kelompok1/actions/workflows/api-test.yml)

Proyek Ujian Tengah Semester mata kuliah Software Quality Assurance (SQA), Kelompok 1: Otentikasi dan Manajemen Data Pengguna.

Pengujian fungsional otomatis terhadap fitur login berbasis JWT dan manajemen akun pada **DummyJSON Auth** (<https://dummyjson.com>), dibuat dengan **Postman**, dijalankan lewat **Newman**, dan dijadwalkan otomatis dengan **GitHub Actions**.

> **Catatan status badge:** badge di atas berwarna merah (*failing*) dan itu disengaja. Pipeline gagal karena tes berhasil mendeteksi 2 bug pada API (lihat bagian [Temuan Bug](#temuan-bug)), bukan karena pipeline atau skrip tesnya rusak.

## Ringkasan Hasil

| Item | Jumlah |
|---|---|
| Total request | 18 |
| Total assertion | 42 |
| Assertion lolos | 40 |
| Assertion gagal | 2 |
| Skipped | 0 |

## Cakupan Pengujian

### Folder Auth (login JWT)

| No | Request | Jenis | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Me - No Token | Negatif | 401 dan pesan error |
| 2 | Login - Valid | Positif | 200 dan response berisi token |
| 3 | Login - Wrong Password | Negatif | 400 dan pesan error |
| 4 | Login - Wrong Username | Negatif | 400 dan pesan error |
| 5 | Login - Empty Body | Negatif | 400 dan pesan error |
| 6 | Get Current User - Valid Token | Positif | 200, username sesuai, field penting ada, password tidak terekspos |
| 7 | Me - Invalid Token | Negatif | 401 dan pesan error |
| 8 | Refresh Token - Valid | Positif | 200 dan token baru |
| 9 | Refresh Token - Invalid | Negatif | 401 atau 403 dan pesan error |

### Folder User Management (manajemen akun)

| No | Request | Jenis | Hasil yang diharapkan |
|---|---|---|---|
| 10 | Get All Users | Positif | 200, array users, field paginasi |
| 11 | Get User by ID - Valid | Positif | 200, ID sesuai, field penting ada |
| 12 | Get User by ID - Not Found | Negatif | 404 dan pesan error |
| 13 | Add User | Positif | 201, id baru, data yang dikirim dikembalikan |
| 14 | Get Added User - Not Persisted | Observasi | 404 (data tidak tersimpan permanen) |
| 15 | Update User | Positif | 200, ID tetap, lastName berubah |
| 16 | Delete User | Positif | 200, ID sesuai, ditandai terhapus |
| 17 | Get User After Delete - Not Persisted | Observasi | 200 (data masih ada) |
| 18 | Delete User - Not Found | Negatif | 404 dan pesan error |

Token (`accessToken` dan `refreshToken`) disimpan otomatis ke variabel environment oleh skrip pada request login, lalu dipakai request berikutnya.

## Struktur Repository

```
.
├── .github/workflows/api-test.yml                      # pipeline GitHub Actions
├── DummyJSON Auth Testing.postman_collection.json      # collection Postman (request dan skrip tes)
├── DummyJSON.postman_environment.json                  # environment (base_url, username, password)
├── run-tests.sh                                        # menjalankan semua tes dengan satu perintah
├── .gitignore
└── README.md
```

## Cara Menjalankan

### 1. Lewat Postman (Collection Runner)

1. Import collection dan environment ke Postman.
2. Pilih environment **DummyJSON**.
3. Klik collection **DummyJSON Auth Testing**, lalu **Run**.

### 2. Lewat command line (Newman)

Prasyarat: Node.js dan Git Bash (Windows) atau terminal bash.

```bash
npm install -g newman newman-reporter-htmlextra
./run-tests.sh
```

Skrip ini menjalankan collection dan membuat laporan HTML di `newman/report.html`. Jika Newman belum terpasang, skrip akan memasangnya otomatis.

### 3. Otomatis lewat GitHub Actions

Workflow `api-test.yml` berjalan sendiri pada kondisi berikut:

- setiap `push` ke branch `main` atau `master`
- setiap `pull request`
- terjadwal setiap hari pukul 01:00 UTC (08:00 WIB)
- manual lewat tab **Actions**, tombol **Run workflow**

Laporan HTML tersimpan sebagai artifact bernama `newman-report` pada setiap run, dan bisa diunduh dari halaman run di tab **Actions**.

## Temuan Bug

### BUG-001: `GET /auth/me` mengembalikan password

| Atribut | Isi |
|---|---|
| Test case | Get Current User - Valid Token |
| Severity | Tinggi |
| Expected | Status 200 dan data profil tanpa field `password` |
| Actual | Status 200, tetapi response memuat field `password` |
| Dampak | Kebocoran data sensitif (*sensitive data exposure*) |

### BUG-002: Token tidak valid menghasilkan 500, bukan 401

| Atribut | Isi |
|---|---|
| Test case | Me - Invalid Token |
| Severity | Sedang |
| Expected | Status 401 Unauthorized |
| Actual | Status 500 Internal Server Error |
| Dampak | Kesalahan input client diperlakukan sebagai kegagalan server |

## Catatan Keterbatasan API

DummyJSON hanya **mensimulasikan** operasi tulis (add, update, delete) dan tidak menyimpannya secara permanen. Karena itu:

- User yang baru ditambahkan tidak bisa diambil kembali (404).
- User yang dihapus masih bisa diambil kembali (200).

Dua request observasi (nomor 14 dan 17) sengaja dibuat untuk mengonfirmasi perilaku ini. Ini keterbatasan layanan simulasi, bukan kesalahan skrip tes.

## Tools

- Postman: pembuatan collection dan skrip tes
- Newman dan newman-reporter-htmlextra: eksekusi lewat CLI dan laporan HTML
- GitHub Actions: otomasi pipeline
- Git dan GitHub: version control

## Anggota Kelompok

| Nama | NIM | Peran |
|---|---|---|
| Adytia Kusuma Putra | [isi NIM] | [isi peran] |
| [nama anggota] | [isi NIM] | [isi peran] |
