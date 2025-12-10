MyMoney Wallet

Aplikasi manajemen keuangan sederhana berbasis Flutter, yang memungkinkan pengguna mencatat pemasukan/pengeluaran, memantau saldo, mengatur anggaran bulanan, dan melihat ringkasan transaksi secara mudah.

👤 Identitas Pembuat

Nama: Ridho
NIM: (isi di sini)
Kelas: (isi di sini)

📌 Deskripsi Singkat

MyMoney Wallet adalah aplikasi dompet digital sederhana yang dirancang untuk membantu pengguna mengelola keuangan pribadi.
Pengguna dapat menambah transaksi, melihat pemasukan dan pengeluaran, memantau saldo secara otomatis, serta mengecek apakah pengeluaran sudah melewati batas anggaran bulanan.

✨ Fitur Utama
1. Dashboard Keuangan
-Menampilkan saldo saat ini
-Total pemasukan dan pengeluaran
-Ringkasan keuangan harian

2. Manajemen Transaksi
-Tambah transaksi baru (pemasukan/pengeluaran)
-Pilih kategori transaksi
-Tanggal otomatis
-Hapus transaksi dengan long-press
-Tampilan list transaksi lengkap

3. Tambah Transaksi
-Input judul, jumlah, kategori
-Pilihan jenis transaksi: Pemasukan / Pengeluaran
-Diformat otomatis dengan format rupiah (Rp)

4. Anggaran Bulanan
-Menampilkan batas anggaran
-Progress bar persentase penggunaan anggaran
-Peringatan jika anggaran hampir atau sudah habis

5. Halaman Profil
-Informasi akun sederhana
-Menu Pengaturan, Keamanan, dan Info Aplikasi

🛠️ Teknologi yang Digunakan
-Flutter
-Dart
-Intl Package (untuk format rupiah)

📂 Struktur Navigasi
Aplikasi menggunakan BottomNavigationBar dengan 5 menu:
1.Dashboard
2.Transaksi
3.Tambah
4.Anggaran
5.Profil

▶️ Cara Menjalankan Aplikasi
Pastikan Flutter sudah terinstall.
1. Clone / Download Project
git clone https://github.com/username/mymoney_wallet.git
cd mymoney_wallet
2. Install Dependencies
flutter pub get
3. Jalankan di Emulator/HP
flutter run
4. Build APK (opsional)
flutter build apk --release
