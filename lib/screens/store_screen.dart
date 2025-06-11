import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Map<String, String>> stores = [
    {
      'name': 'Ardefva Shoes Jakarta',
      'address': 'Jl. Sudirman No. 45, Jakarta Selatan',
      'phone': '+62 21 1234 5678',
      'image': 'assets/images/toko1.jpg',
      'mapsUrl':
          'https://www.google.com/maps/search/?api=1&query=-6.21462,106.84513',
    },
    {
      'name': 'Ardefva Shoes Bandung',
      'address': 'Jl. Asia Afrika No. 20, Bandung',
      'phone': '+62 22 9876 5432',
      'image': 'assets/images/toko2.jpg',
      'mapsUrl':
          'https://www.google.com/maps/search/?api=1&query=-6.91746,107.61912',
    },
    {
      'name': 'Ardefva Shoes Surabaya',
      'address': 'Jl. Pemuda No. 12, Surabaya',
      'phone': '+62 31 8765 4321',
      'image': 'assets/images/toko3.jpg',
      'mapsUrl':
          'https://www.google.com/maps/search/?api=1&query=-7.25747,112.75209',
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
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(store['mapsUrl']!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Untuk Saat Ini Maps Belum Tersedia.'),
                        ),
                      );
                    }
                  },
                  child: ClipRRect(
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
