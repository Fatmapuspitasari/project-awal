import 'package:flutter/material.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  final List<Map<String, String>> promos = const [
    {
      'title': 'Diskon 10% Cuci Sepatu!',
      'description': 'Nikmati diskon besar untuk layanan cuci sepatu sampai akhir bulan ini!',
      'image':
          'https://images.unsplash.com/photo-1580910051070-42cd1f99a3d1?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Buy 1 Get 1 Repair',
      'description': 'Perbaiki sepasang sepatu, dapatkan perbaikan kedua gratis!',
      'image':
          'https://images.unsplash.com/photo-1580910037547-fc3253f6f6b0?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Gratis Ongkir!',
      'description': 'Setiap pemesanan layanan > Rp100.000 akan mendapatkan gratis ongkir.',
      'image':
          'https://images.unsplash.com/photo-1600180758890-9f79b1c9e741?auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo Menarik'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final promo = promos[index];
          return Card(
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    promo['image']!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo['title']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        promo['description']!,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
