import 'package:flutter/material.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.blue[500],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pusat Bantuan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jika kamu mengalami kesulitan atau memiliki pertanyaan seputar aplikasi, silakan lihat beberapa FAQ berikut atau hubungi layanan pelanggan kami.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildFaqItem(
              'Bagaimana cara mengubah password?',
              'Kamu bisa mengubah password lewat menu pengaturan akun.',
            ),
            _buildFaqItem(
              'Bagaimana mengaktifkan notifikasi?',
              'Pastikan toggle notifikasi aktif di menu pengaturan notifikasi.',
            ),
            _buildFaqItem(
              'Bagaimana cara memilih bahasa?',
              'Pilih bahasa di menu pengaturan bahasa sesuai preferensi kamu.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Kontak Layanan Pelanggan:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: support@aplikasi.com\nTelepon: 021-12345678',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
