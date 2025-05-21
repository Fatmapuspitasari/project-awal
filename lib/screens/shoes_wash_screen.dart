import 'package:flutter/material.dart';

class ShoesWashScreen extends StatefulWidget {
  const ShoesWashScreen({super.key});

  @override
  State<ShoesWashScreen> createState() => _ShoesWashScreenState();
}

class _ShoesWashScreenState extends State<ShoesWashScreen> {
  final List<Map<String, dynamic>> priceList = [
    {'category': 'Cuci Luar', 'type': 'Sneaker', 'price': 15000},
    {'category': 'Cuci Luar', 'type': 'Kulit', 'price': 15000},
    {'category': 'Cuci Luar', 'type': 'Full Suede', 'price': 35000},
    {'category': 'Cuci Luar', 'type': 'Kombinasi Suede', 'price': 20000},
    {'category': 'Cuci Luar', 'type': 'Putih (Kain/Kanvas + Whitening)', 'price': 25000},
    {'category': 'Cuci Full', 'type': 'Sneaker', 'price': 25000},
    {'category': 'Cuci Full', 'type': 'Kulit', 'price': 35000},
    {'category': 'Cuci Full', 'type': 'Full Suede', 'price': 50000},
    {'category': 'Cuci Full', 'type': 'Kombinasi Suede', 'price': 35000},
    {'category': 'Cuci Full', 'type': 'Putih (Kain/Kanvas + Whitening)', 'price': 30000},
    {'category': 'Cuci Full', 'type': 'Flat Shoes', 'price': 20000},
    {'category': 'Cuci Premium', 'type': 'Express 1 Hari Jadi (Non-Suede)', 'price': 50000},
    {'category': 'Cuci Premium', 'type': 'Unyellowing', 'price': 35000},
    {'category': 'Cuci Premium', 'type': 'Unyellowing + Full Cuci', 'price': 500000},
  ];

  final Set<String> bookedServices = {};
  final Map<String, int> quantities = {};

  void _showImageDialog(String imagePath, String title) {
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

  void _confirmBooking(String id, String type, String category, int totalPrice) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFE8EAF0),
        title: const Text('Konfirmasi Pesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pesan "$category - $type"'),
            const SizedBox(height: 8),
            Text('Total: Rp $totalPrice'),
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
                bookedServices.add(id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pesanan dikonfirmasi: $category - $type'),
                ),
              );
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final id = '${item['category']}_${item['type']}';
    final quantity = quantities[id] ?? 1;
    final total = item['price'] * quantity;
    final isBooked = bookedServices.contains(id);

    String imagePath = 'assets/images/default_shoes.jpg';
    if (item['category'].contains('Cuci Luar')) {
      imagePath = 'assets/images/cuciluar.jpg';
    } else if (item['category'].contains('Cuci Full')) {
      imagePath = 'assets/images/cucifull.jpg';
    } else if (item['category'].contains('Cuci Premium')) {
      imagePath = 'assets/images/cucipremium.jpg';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showImageDialog(imagePath, '${item['category']} - ${item['type']}'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['category']}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${item['type']}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Rp ${item['price']}',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF2C7EF8), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
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
                        if (quantity > 1) setState(() => quantities[id] = quantity - 1);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity'),
                    IconButton(
                      onPressed: () => setState(() => quantities[id] = quantity + 1),
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
                  onPressed: isBooked ? null : () => _confirmBooking(id, item['type'], item['category'], total),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isBooked ? Colors.grey.shade300 : const Color(0xFF2C7EF8),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart, color: isBooked ? Colors.grey : Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        isBooked ? 'Dipesan' : 'Pesan',
                        style: TextStyle(color: isBooked ? Colors.grey : Colors.white),
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
        title: const Text('Shoes Wash Booking'),
        backgroundColor: const Color(0xFF2C7EF8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: priceList.length,
        itemBuilder: (context, index) => _buildItemCard(priceList[index]),
      ),
    );
  }
}
