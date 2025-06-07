import 'package:flutter/material.dart';

class PerawatanSepatuScreen extends StatelessWidget {
  const PerawatanSepatuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Back
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blue.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withAlpha(48),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.cleaning_services,
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Panduan Lengkap\nPerawatan Sepatu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cara Mencuci Sepatu
                    _buildSectionCard(
                      title: 'Cara Mencuci Sepatu',
                      icon: Icons.local_laundry_service,
                      color: Colors.green,
                      content: [
                        'Lepaskan tali sepatu dan sol dalam (jika bisa dilepas)',
                        'Sikat dengan sikat cuci bagian luar (out sol) sepatu untuk menghilangkan kotoran kasar',
                        'Celup sikat dalam air kemudian tiriskan lalu cuci dengan sabun cuci khusus sepatu agar tidak cepat rusak',
                        'Gunakan sikat gigi untuk membersihkan bagian yang sulit dijangkau atau untuk bagian luar atas dan bagian insole agar tidak cepat rusak',
                        'usap dengan kain bersih tanpa menggunakan air agar sepatu tidak rusak',
                        'Keringkan di tempat teduh, atau di keringkan dengan kipas angin serta hindari sinar matahari langsung agar warna tidak pudar',
                        'setelah kering semprot insole dengan parfume khusus untuk sepatu disarankan yang kopi karna bau kopi menetralkan bau yang tidak sedap',
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Cara Merawat Sepatu
                    _buildSectionCard(
                      title: 'Cara Merawat Sepatu',
                      icon: Icons.favorite,
                      color: Colors.orange,
                      content: [
                        'Bersihkan sepatu setelah digunakan dengan kain lembab',
                        'Simpan sepatu di tempat yang kering dan berventilasi baik',
                        'Gunakan shoe tree atau koran untuk mempertahankan bentuk',
                        'Oleskan pelembab khusus sepatu kulit secara berkala',
                        'Rotasi penggunaan sepatu, jangan pakai sepatu yang sama setiap hari',
                        'Gunakan spray anti bakteri untuk mencegah bau tidak sedap',
                        'Periksa dan perbaiki kerusakan kecil sebelum bertambah parah',
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tips Sepatu Awet
                    _buildSectionCard(
                      title: 'Tips Sepatu Awet & Tahan Lama',
                      icon: Icons.timer,
                      color: Colors.purple,
                      content: [
                        'Pilih sepatu sesuai dengan aktivitas (olahraga, kerja, santai)',
                        'Pastikan ukuran sepatu pas, tidak terlalu sempit atau longgar',
                        'Gunakan kaus kaki yang tepat untuk menyerap keringat',
                        'Hindari menginjak bagian belakang sepatu saat memakainya',
                        'Longgarkan tali sepatu sebelum melepasnya',
                        'Simpan sepatu dengan posisi berdiri, bukan ditumpuk',
                        'Ganti sol sepatu jika sudah tipis atau aus',
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tips Tambahan Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tips Bonus',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Baking soda dapat membantu menghilangkan bau tidak sedap. Taburkan sedikit baking soda di dalam sepatu pada malam hari, lalu keluarkan keesokan harinya.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> content,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(23),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...content.asMap().entries.map((entry) {
              int index = entry.key;
              String item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
