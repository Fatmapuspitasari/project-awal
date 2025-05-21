import 'package:flutter/material.dart';

class ShoesCareScreen extends StatefulWidget {
  const ShoesCareScreen({super.key});

  @override
  State<ShoesCareScreen> createState() => _ShoesCareScreenState();
}

class _ShoesCareScreenState extends State<ShoesCareScreen> {
  final List<Map<String, dynamic>> careItems = [
    {
      'title': 'Paket Lengkap Hemat Pembersih Sepatu',
      'image': 'assets/images/paketlengkap.jpeg',
      'price': 45000,
    },
    {
      'title': 'Paket Hemat Pembersih Sepatu',
      'image': 'assets/images/pakethemat.jpeg',
      'price': 35000,
    },
    {
      'title': 'Pembersih Sepatu Tanpa Air - SHCON SEGEN Foam Cleaner Shoes',
      'image': 'assets/images/tanpaair.jpeg',
      'price': 30000,
    },
    {
      'title': 'Refill Pembersih Sepatu - Shicon Segen Cleaner Shoes 1 Liter + Parfum',
      'image': 'assets/images/refill1lt.jpeg',
      'price': 60000,
    },
    {
      'title': 'Leather Balsam Semir Pembersih Sepatu',
      'image': 'assets/images/balsam.jpeg',
      'price': 25000,
    },
  ];

  final Set<String> confirmedItems = {};
  final Map<String, int> quantities = {};

  void _showImageDialog(BuildContext context, String imagePath, String title) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmOrder(String title, int price, int quantity) {
    final total = price * quantity;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFE8EAF0),
        title: const Text('Konfirmasi Pesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pesan "$title"'),
            const SizedBox(height: 8),
            Text('Total: Rp $total'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                confirmedItems.add(title);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pesanan dikonfirmasi: $title x$quantity'),
                ),
              );
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  Widget _buildCareCard(Map<String, dynamic> item) {
    final title = item['title'];
    final quantity = quantities[title] ?? 1;
    final total = item['price'] * quantity;
    final isConfirmed = confirmedItems.contains(title);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showImageDialog(context, item['image'], title),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item['image'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Rp ${item['price']}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2C7EF8),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jumlah', style: TextStyle(fontSize: 14)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) setState(() => quantities[title] = quantity - 1);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity'),
                    IconButton(
                      onPressed: () => setState(() => quantities[title] = quantity + 1),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: Rp $total',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: isConfirmed
                      ? null
                      : () => _confirmOrder(title, item['price'], quantity),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isConfirmed ? Colors.grey.shade300 : const Color(0xFF2C7EF8),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart, color: isConfirmed ? Colors.grey : Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        isConfirmed ? 'Dipesan' : 'Pesan',
                        style: TextStyle(color: isConfirmed ? Colors.grey : Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text('Shoes Care Booking'),
        backgroundColor: const Color(0xFF2C7EF8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: careItems.length,
        itemBuilder: (context, index) => _buildCareCard(careItems[index]),
      ),
    );
  }
}
