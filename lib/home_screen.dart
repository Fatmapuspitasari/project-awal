import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Toko Ardefva"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang 👋",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Kategori Produk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategory(Icons.phone_android, "Elektronik"),
                _buildCategory(Icons.chair, "Furniture"),
                _buildCategory(Icons.shopping_bag, "Fashion"),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Produk"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.receipt),
                  label: const Text("Lihat Transaksi"),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              "Produk Terbaru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Daftar Produk Sederhana
            Expanded(
              child: ListView(
                children: [
                  _buildProductCard("Laptop ASUS", "Rp 7.500.000"),
                  _buildProductCard("Meja Kayu", "Rp 1.200.000"),
                  _buildProductCard("Jaket Hoodie", "Rp 350.000"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kategori
  Widget _buildCategory(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue[300],
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // Widget kartu produk
  Widget _buildProductCard(String name, String price) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.storefront, color: Colors.blue),
        title: Text(name),
        subtitle: Text(price),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // bisa navigasi ke detail produk
        },
      ),
    );
  }
}
