import 'package:flutter/material.dart';

class InformasiAkunScreen extends StatelessWidget {
  const InformasiAkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Akun'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Detail akun pengguna akan ditampilkan di sini.'),
      ),
    );
  }
}
