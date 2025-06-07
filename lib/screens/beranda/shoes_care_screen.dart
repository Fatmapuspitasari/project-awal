import 'package:flutter/material.dart';
import 'package:project_awal/screens/history_screen.dart';
import 'package:project_awal/screens/database/supabase_service.dart';

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
      'title':
          'Refill Pembersih Sepatu - Shicon Segen Cleaner Shoes 1 Liter + Parfum',
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
  String selectedPaymentMethod = 'Tunai';
  bool _isLoading = false;

  final List<String> paymentMethods = [
    'Tunai',
    'Transfer Bank (BCA, Mandiri, BRI)',
    'E-Wallet (GoPay, OVO, DANA)',
    'QRIS',
    'Kartu Kredit/Debit',
  ];

  void _showImageDialog(BuildContext context, String imagePath, String title) {
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
        'service_type': 'Shoes Care',
        'service_category': 'Produk Perawatan',
        'service_name': orderData['title'],
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

  void _confirmOrder(String title, int price, int quantity) {
    final total = price * quantity;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pesan "$title"'),
                  const SizedBox(height: 8),
                  Text('Jumlah: $quantity'),
                  const SizedBox(height: 4),
                  Text(
                    'Total: Rp $total',
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
                          '💳 Info Pembayaran & Layanan:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Pembayaran dapat dilakukan saat pengambilan',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Transfer: Konfirmasi bukti transfer via WhatsApp',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• E-Wallet & QRIS: Scan QR code saat pickup',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Produk ready stock, bisa langsung diambil',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Konsultasi penggunaan produk gratis',
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
                            final unitPrice = price;

                            // Prepare order data
                            final orderData = {
                              'title': title,
                              'serviceType': 'Shoes Care',
                              'quantity': quantity,
                              'unitPrice': unitPrice,
                              'totalPrice': total,
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
                              confirmedItems.add(title);
                            });

                            // Add order to history (existing functionality)
                            HistoryScreen.addOrder(orderData);

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pesanan berhasil disimpan: $title x$quantity\nPembayaran: $selectedPaymentMethod',
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
        return 'Bayar tunai saat pengambilan produk';
    }
  }

  Widget _buildCareCard(Map<String, dynamic> item) {
    final title = item['title'];
    final quantity = quantities[title] ?? 1;
    final total = item['price'] * quantity;
    final isConfirmed = confirmedItems.contains(title);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showImageDialog(context, item['image'], title),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item['image'],
                  width: double.infinity,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Title and price section
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              'Rp ${item['price']}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C7EF8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Text(
                '💳 Ready stock',
                style: TextStyle(fontSize: 9, color: Colors.green),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 8),

            // Quantity section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jumlah', style: TextStyle(fontSize: 12)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1)
                          setState(() => quantities[title] = quantity - 1);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () =>
                              setState(() => quantities[title] = quantity + 1),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              'Total: Rp $total',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (isConfirmed || _isLoading)
                        ? null
                        : () => _confirmOrder(title, item['price'], quantity),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isConfirmed
                          ? Colors.grey.shade300
                          : const Color(0xFF2C7EF8),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                        color: isConfirmed ? Colors.grey : Colors.white,
                        size: 16,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      _isLoading
                          ? 'Proses...'
                          : (isConfirmed ? 'Dipesan' : 'Pesan'),
                      style: TextStyle(
                        color: isConfirmed ? Colors.grey : Colors.white,
                        fontSize: 12,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text('Shoes Care Booking'),
        backgroundColor: const Color(0xFF2C7EF8),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: careItems.length,
          itemBuilder: (context, index) => _buildCareCard(careItems[index]),
        ),
      ),
    );
  }
}
