import 'package:flutter/material.dart';
import 'package:project_awal/screens/database/supabase_service.dart';
import 'package:project_awal/screens/history_screen.dart';

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
    {
      'category': 'Cuci Luar',
      'type': 'Putih (Kain/Kanvas + Whitening)',
      'price': 25000,
    },
    {'category': 'Cuci Full', 'type': 'Sneaker', 'price': 25000},
    {'category': 'Cuci Full', 'type': 'Kulit', 'price': 35000},
    {'category': 'Cuci Full', 'type': 'Full Suede', 'price': 50000},
    {'category': 'Cuci Full', 'type': 'Kombinasi Suede', 'price': 35000},
    {
      'category': 'Cuci Full',
      'type': 'Putih (Kain/Kanvas + Whitening)',
      'price': 30000,
    },
    {'category': 'Cuci Full', 'type': 'Flat Shoes', 'price': 20000},
    {
      'category': 'Cuci Premium',
      'type': 'Express 1 Hari Jadi (Non-Suede)',
      'price': 50000,
    },
    {'category': 'Cuci Premium', 'type': 'Unyellowing', 'price': 35000},
    {
      'category': 'Cuci Premium',
      'type': 'Unyellowing + Full Cuci',
      'price': 500000,
    },
  ];

  final Set<String> bookedServices = {};
  final Map<String, int> quantities = {};
  String selectedPaymentMethod = 'Tunai';
  bool _isLoading = false;

  final List<String> paymentMethods = [
    'Tunai',
    'Transfer Bank (BCA, Mandiri, BRI)',
    'E-Wallet (GoPay, OVO, DANA)',
    'QRIS',
    'Kartu Kredit/Debit',
  ];

  void _showImageDialog(String imagePath, String title) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _saveOrderToDatabase(Map<String, dynamic> orderData) async {
    try {
      final supabaseService = SupabaseService.instance;

      // Check if user is logged in
      if (!supabaseService.isLoggedIn) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final userId = supabaseService.currentUser!.id;

      // Prepare order data for database
      final dbOrderData = {
        'user_id': userId,
        'service_type': 'Shoes Wash',
        'service_category': orderData['category'],
        'service_name': orderData['type'],
        'quantity': orderData['quantity'],
        'unit_price': orderData['unitPrice'],
        'total_price': orderData['totalPrice'],
        'payment_method': orderData['paymentMethod'],
        'payment_status': 'Belum Dibayar',
        'service_status': 'Dikonfirmasi',
        'order_date': DateTime.now().toIso8601String(),
        'notes': orderData['paymentInfo'],
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Insert into database
      await supabaseService.client.from('orders').insert(dbOrderData);

      print('Order saved to database successfully');
    } catch (e) {
      print('Error saving order to database: $e');
      rethrow;
    }
  }

  void _confirmBooking(
    String id,
    String type,
    String category,
    int totalPrice,
    int quantity,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFFE8EAF0),
            title: const Text('Konfirmasi Pesanan'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pesan "$category - $type"'),
                  const SizedBox(height: 8),
                  Text('Jumlah: $quantity'),
                  Text(
                    'Total: Rp $totalPrice',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Metode Pembayaran:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPaymentMethod,
                        isExpanded: true,
                        items:
                            paymentMethods.map((String method) {
                              return DropdownMenuItem<String>(
                                value: method,
                                child: Text(
                                  method,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMethod = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🧼 Info Servis & Pembayaran:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Layanan cuci selesai dalam 1–3 hari kerja',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Pembayaran bisa dilakukan saat pengambilan',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Transfer: Konfirmasi bukti via WhatsApp',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• E-Wallet & QRIS: Bayar saat pickup',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Konsultasi & pengecekan sepatu gratis',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // Calculate unit price
                            final unitPrice = totalPrice ~/ quantity;

                            // Prepare order data
                            final orderData = {
                              'title': '$category - $type',
                              'category': category,
                              'type': type,
                              'serviceType': 'Shoes Wash',
                              'quantity': quantity,
                              'unitPrice': unitPrice,
                              'totalPrice': totalPrice,
                              'paymentMethod': selectedPaymentMethod,
                              'orderDate': _getCurrentDate(),
                              'paymentStatus': 'Belum Dibayar',
                              'serviceStatus': 'Dikonfirmasi',
                              'paymentInfo': _getPaymentInfo(
                                selectedPaymentMethod,
                              ),
                            };

                            // Save to database
                            await _saveOrderToDatabase(orderData);

                            // Update local state
                            setState(() {
                              bookedServices.add(id);
                            });

                            // Add order to history (existing functionality)
                            HistoryScreen.addOrder(orderData);

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pesanan berhasil disimpan: $category - $type x$quantity\nPembayaran: $selectedPaymentMethod',
                                ),
                                duration: const Duration(seconds: 4),
                                backgroundColor: Colors.green,
                                action: SnackBarAction(
                                  label: 'Lihat Riwayat',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const HistoryScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } catch (e) {
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal menyimpan pesanan: ${SupabaseService.instance.getErrorMessage(e)}',
                                ),
                                duration: const Duration(seconds: 4),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Konfirmasi'),
              ),
            ],
          ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _getPaymentInfo(String paymentMethod) {
    switch (paymentMethod) {
      case 'Transfer Bank (BCA, Mandiri, BRI)':
        return 'Bayar saat pengambilan atau transfer ke rekening yang disediakan';
      case 'E-Wallet (GoPay, OVO, DANA)':
        return 'Scan QR code saat pickup atau transfer sekarang';
      case 'QRIS':
        return 'Scan QR code universal saat pengambilan';
      case 'Kartu Kredit/Debit':
        return 'Bayar dengan kartu saat pickup';
      default:
        return 'Bayar tunai saat pengambilan sepatu';
    }
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
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar layanan
            GestureDetector(
              onTap:
                  () => _showImageDialog(
                    imagePath,
                    '${item['category']} - ${item['type']}',
                  ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Detail kategori dan tipe layanan
            Text(
              '${item['category']}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${item['type']}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Rp ${item['price']}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C7EF8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                '🧼 Bayar saat pickup • 1-3 hari kerja',
                style: TextStyle(fontSize: 10, color: Colors.blue),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            // Kontrol jumlah barang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1)
                          setState(() => quantities[id] = quantity - 1);
                      },
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                    ),
                    Text('$quantity'),
                    IconButton(
                      onPressed:
                          () => setState(() => quantities[id] = quantity + 1),
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Baris Total harga dan tombol pemesanan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp $total',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      (isBooked || _isLoading)
                          ? null
                          : () => _confirmBooking(
                            id,
                            item['type'],
                            item['category'],
                            total,
                            quantity,
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isBooked
                            ? Colors.grey.shade300
                            : const Color(0xFF2C7EF8),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.shopping_cart,
                          size: 16,
                          color: isBooked ? Colors.grey : Colors.white,
                        ),
                      const SizedBox(width: 6),
                      Text(
                        _isLoading
                            ? 'Proses...'
                            : (isBooked ? 'Dipesan' : 'Pesan'),
                        style: TextStyle(
                          color: isBooked ? Colors.grey : Colors.white,
                          fontSize: 12,
                        ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: GridView.builder(
          itemCount: priceList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) => _buildItemCard(priceList[index]),
        ),
      ),
    );
  }
}
