import 'package:flutter/material.dart';

class SyaratKetentuanScreen extends StatelessWidget {
  const SyaratKetentuanScreen({super.key});

  final String syaratKetentuanText = '''
1. Pengguna wajib membaca seluruh syarat dan ketentuan sebelum menggunakan aplikasi.
2. Data yang diberikan harus valid dan dapat dipertanggungjawabkan.
3. Penggunaan aplikasi hanya untuk keperluan pribadi dan non-komersial.
4. Dilarang menyalahgunakan aplikasi untuk tindakan ilegal.
5. Kami berhak mengubah syarat dan ketentuan sewaktu-waktu tanpa pemberitahuan sebelumnya.
6. Jika ada pertanyaan, silakan hubungi layanan pelanggan kami.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Syarat dan Ketentuan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harap Baca dengan Seksama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Berikut adalah syarat dan ketentuan penggunaan aplikasi Ardefa Shoes Care. Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi semua syarat berikut:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                ...syaratKetentuanText
                    .split('\n')
                    .map(
                      (line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(fontSize: 20, height: 1.4),
                            ),
                            Expanded(
                              child: Text(
                                line.trim(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
