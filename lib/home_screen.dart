import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildServiceTile(String title, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCleanerSale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cairan Pembersih Sepatu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cairan Pembersih Sepatu\nHarga: Rp 120.000',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Beli cairan pembersih sepatu yang aman dan efektif untuk menjaga kebersihan sepatu Anda.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {}, 
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                ),
                child: const Text('Beli Sekarang'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.local_laundry_service),
          title: const Text('Cuci Sepatu'),
          subtitle: const Text('Dalam Proses - 4 Mei 2025'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPromotions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Promo & Paket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Cuci 3 pasang sepatu hanya 50K!\nBerlaku hingga 10 Mei 2025',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final username = box.read('username') ?? 'Pengguna';
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selamat datang, $username!', 
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 20),
        const Text('Layanan Kami', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildServiceTile('Cuci Sepatu', Icons.local_laundry_service),
            _buildServiceTile('Repair', Icons.build),
            _buildServiceTile('Deep Clean', Icons.cleaning_services),
            _buildServiceTile('Pickup', Icons.local_shipping),
          ],
        ),
        const SizedBox(height: 30),
        _buildRecentOrders(),
        const SizedBox(height: 30),
        _buildPromotions(),
        const SizedBox(height: 30),
        _buildCleanerSale(),
      ],
    );
  }
}