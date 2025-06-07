import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  final List<Map<String, String>> stores = const [
    {
      'name': 'Ardeeva Shoes Jakarta',
      'address': 'Jl. Sudirman No. 45, Jakarta Selatan',
      'phone': '+62 21 1234 5678',
      'image': 'assets/images/toko1.jpg',
    },
    {
      'name': 'Ardeeva Shoes Bandung',
      'address': 'Jl. Asia Afrika No. 20, Bandung',
      'phone': '+62 22 9876 5432',
      'image': 'assets/images/toko2.jpg',
    },
    {
      'name': 'Ardeeva Shoes Surabaya',
      'address': 'Jl. Pemuda No. 12, Surabaya',
      'phone': '+62 31 8765 4321',
      'image': 'assets/images/toko3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Toko Kami'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    store['image']!,
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
                        store['name'] ?? 'Nama Toko Tidak Diketahui',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        store['address'] ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text(
                            store['phone'] ?? '-',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
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
