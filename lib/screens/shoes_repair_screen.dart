import 'package:flutter/material.dart';

class ShoesRepairScreen extends StatefulWidget {
  const ShoesRepairScreen({super.key});

  @override
  State<ShoesRepairScreen> createState() => _ShoesRepairScreenState();
}

class _ShoesRepairScreenState extends State<ShoesRepairScreen> {
  final List<Map<String, dynamic>> repairServices = [
    {
      'title': 'Ganti Sol Sepatu',
      'description': 'Mengganti sol luar sepatu yang sudah rusak atau aus.',
      'priceRange': 'Rp 50.000',
      'price': 75000,
      'imagePath': 'assets/images/solsepatu.jpg'
    },
    {
      'title': 'Jahit Ulang Bagian Atas',
      'description': 'Menjahit ulang bagian atas sepatu yang robek atau lepas.',
      'priceRange': 'Rp 30.000',
      'price': 50000,
      'imagePath': 'assets/images/jahitulang.jpg'
    },
    {
      'title': 'Ganti Insole (Spon Dalam)',
      'description': 'Mengganti lapisan dalam sepatu untuk kenyamanan ekstra.',
      'priceRange': 'Rp 40.000',
      'price': 60000,
      'imagePath': 'assets/images/insole.jpg'
    },
    {
      'title': 'Ganti Tali & Lubang Tali',
      'description': 'Mengganti tali sepatu dan memperbaiki lubang tali.',
      'priceRange': 'Rp 20.000',
      'price': 35000,
      'imagePath': 'assets/images/talisepatu.jpg'
    },
    {
      'title': 'Perbaikan Hak (Heel)',
      'description': 'Memperbaiki atau mengganti hak sepatu wanita/pria.',
      'priceRange': 'Rp 40.000',
      'price': 70000,
      'imagePath': 'assets/images/haksepatu.jpg'
    },
    {
      'title': 'Recolour / Pewarnaan Ulang',
      'description': 'Mengembalikan warna asli sepatu yang pudar.',
      'priceRange': 'Rp 60.000',
      'price': 90000,
      'imagePath': 'assets/images/recolour.jpg'
    },
    {
      'title': 'Perbaikan Lem yang Lepas',
      'description': 'Merekatkan kembali bagian sepatu yang terlepas.',
      'priceRange': 'Rp 20.000',
      'price': 30000,
      'imagePath': 'assets/images/lemlepas.jpg'
    },
    {
      'title': 'Full Restoration',
      'description': 'Restorasi total: lem, cat ulang, jahit, dan pembersihan.',
      'priceRange': 'Rp 100.000',
      'price': 175000,
      'imagePath': 'assets/images/fullrestore.jpg'
    },
  ];

  final Set<String> bookedServices = {};
  final Map<String, int> quantities = {};

  void _confirmBooking(String id, String title, int totalPrice) {
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
                  content: Text('Pesanan dikonfirmasi: $title'),
                ),
              );
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final id = service['title'];
    final quantity = quantities[id] ?? 1;
    final total = service['price'] * quantity;
    final isBooked = bookedServices.contains(id);

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    service['imagePath'],
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
                      Text(service['title'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(service['description'],
                          style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(service['priceRange'],
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2C7EF8),
                              fontWeight: FontWeight.bold)),
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
                  onPressed: isBooked
                      ? null
                      : () => _confirmBooking(id, service['title'], total),
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
        title: const Text('Shoes Repair Booking'),
        backgroundColor: const Color(0xFF2C7EF8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: repairServices.length,
        itemBuilder: (context, index) => _buildServiceCard(repairServices[index]),
      ),
    );
  }
}
