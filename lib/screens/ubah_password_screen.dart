import 'package:flutter/material.dart';

class UbahPasswordScreen extends StatelessWidget {
  const UbahPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Password'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Formulir ubah password akan ditampilkan di sini.'),
      ),
    );
  }
}
