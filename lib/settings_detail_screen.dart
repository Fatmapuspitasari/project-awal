import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AkunDetailScreen extends StatelessWidget {
  const AkunDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final username = box.read('username') ?? 'Pengguna';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Akun'),
        backgroundColor: Colors.blue[500],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Informasi Pribadi',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            _buildInfoTile('Nama Pengguna', username),
            _buildInfoTile('ID Pengguna', username),
            _buildInfoTile('Email', '$username@email.com'),
            _buildInfoTile('Nomor Telepon', '08123456789'),
            const SizedBox(height: 24),
            const Text(
              'Riwayat Penggunaan',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            _buildInfoTile('Total Poin', '250 poin'),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Edit Profil'),
                      content: const Text('Fitur edit profil akan segera hadir!'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Edit Profil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KeamananScreen extends StatefulWidget {
  const KeamananScreen({super.key});

  @override
  State<KeamananScreen> createState() => _KeamananScreenState();
}

class _KeamananScreenState extends State<KeamananScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isBiometricsEnabled = false;
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        backgroundColor: Colors.blue[500],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Ubah Kata Sandi',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _currentPasswordController,
            obscureText: _obscureCurrentPassword,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Saat Ini',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureCurrentPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Baru',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Kata Sandi Baru',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_currentPasswordController.text.isEmpty ||
                  _newPasswordController.text.isEmpty ||
                  _confirmPasswordController.text.isEmpty) {
                _showAlert('Semua kolom harus diisi.');
                return;
              }

              if (_newPasswordController.text != _confirmPasswordController.text) {
                _showAlert('Kata sandi baru dan konfirmasi tidak cocok.');
                return;
              }

              _showAlert('Kata sandi berhasil diubah!', isSuccess: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Simpan Kata Sandi Baru',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Pengaturan Keamanan Lainnya',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Aktifkan Biometrik'),
            subtitle: const Text('Gunakan sidik jari atau wajah untuk login'),
            value: _isBiometricsEnabled,
            onChanged: (value) {
              setState(() {
                _isBiometricsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi Login'),
            subtitle: const Text('Dapatkan notifikasi ketika akun diakses dari perangkat baru'),
            value: _isNotificationEnabled,
            onChanged: (value) {
              setState(() {
                _isNotificationEnabled = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Hapus Akun', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Tindakan ini tidak dapat dibatalkan'),
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showAlert(String message, {bool isSuccess = false}) {
    Get.dialog(
      AlertDialog(
        title: Text(isSuccess ? 'Berhasil' : 'Perhatian'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text(
          'Anda yakin ingin menghapus akun? Semua data akan hilang permanen dan tidak dapat dipulihkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _showAlert('Fitur ini belum tersedia saat ini.');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class KebijakanPrivasiScreen extends StatelessWidget {
  const KebijakanPrivasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
        backgroundColor: Colors.blue[500],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Kebijakan Privasi Ardefva Shoes Care',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Terakhir diperbarui: 1 Mei 2025',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 24),
          Text(
            'Ardefva Shoes Care ("kami", "kita", atau "Perusahaan") menghargai privasi pengguna aplikasi mobile kami. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan mengungkapkan informasi pribadi Anda ketika Anda menggunakan aplikasi Ardefva Shoes Care ("Aplikasi").',
          ),
          SizedBox(height: 16),
          Text(
            '1. Informasi yang Kami Kumpulkan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Kami mengumpulkan informasi yang Anda berikan secara langsung kepada kami ketika mendaftar akun, menggunakan layanan kami, atau berkomunikasi dengan kami. Informasi ini mungkin termasuk:',
          ),
          SizedBox(height: 8),
          Text(
            '• Informasi identitas (seperti nama, alamat email, nomor telepon)\n'
            '• Informasi pengiriman (seperti alamat rumah atau bisnis)\n'
            '• Informasi pembayaran (diproses oleh penyedia layanan pembayaran pihak ketiga)\n'
            '• Konten yang Anda unggah ke Aplikasi (seperti foto sepatu Anda)\n'
            '• Komunikasi dengan kami',
          ),
          SizedBox(height: 16),
          Text(
            '2. Bagaimana Kami Menggunakan Informasi Anda',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Kami menggunakan informasi yang kami kumpulkan untuk:'),
          SizedBox(height: 8),
          Text(
            '• Menyediakan, memelihara, dan meningkatkan layanan kami\n'
            '• Memproses dan menyelesaikan transaksi\n'
            '• Mengirimkan informasi teknis, pembaruan, dan pesan dukungan\n'
            '• Merespons pertanyaan, komentar, dan permintaan Anda\n'
            '• Memantau dan menganalisis tren, penggunaan, dan aktivitas',
          ),
          SizedBox(height: 16),
          Text(
            '3. Keamanan Data',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Keamanan informasi Anda penting bagi kami. Kami menggunakan tindakan keamanan teknis dan organisasi yang dirancang untuk melindungi informasi pribadi Anda dari akses yang tidak sah dan penyalahgunaan.',
          ),
          SizedBox(height: 16),
          Text(
            '4. Perubahan pada Kebijakan Privasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Kami akan memberi tahu Anda tentang perubahan dengan memperbarui tanggal "Terakhir diperbarui" di bagian atas Kebijakan Privasi ini.',
          ),
          SizedBox(height: 16),
          Text(
            '5. Hubungi Kami',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Jika Anda memiliki pertanyaan tentang Kebijakan Privasi ini, silakan hubungi kami di:',
          ),
          SizedBox(height: 8),
          Text(
            'Email: info@ardefvashoescare.com\nTelepon: 021-12345678\nAlamat: Jl. Sepatu Indah No. 123, Jakarta',
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
