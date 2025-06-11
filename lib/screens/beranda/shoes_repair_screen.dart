import 'package:flutter/material.dart';
import 'package:project_awal/screens/history_screen.dart';
import 'package:project_awal/screens/database/supabase_service.dart';

class ShoesRepairScreen extends StatefulWidget {
  const ShoesRepairScreen({super.key});

  @override
  State<ShoesRepairScreen> createState() => _ShoesRepairScreenState();
}

class _ShoesRepairScreenState extends State<ShoesRepairScreen> {
  final SupabaseService _supabaseService = SupabaseService.instance;

  final List<Map<String, dynamic>> repairServices = [
    {
      'title': 'Ganti Sol Sepatu',
      'description': '',
      'priceRange': 'Rp 50.000',
      'price': 50000,
      'imagePath': 'assets/images/solsepatu.jpg',
    },
    {
      'title': 'Jahit Ulang Bagian Atas',
      'description': '',
      'priceRange': 'Rp 30.000',
      'price': 30000,
      'imagePath': 'assets/images/jahitulang.jpg',
    },
    {
      'title': 'Ganti Insole (Spon Dalam)',
      'description': '',
      'priceRange': 'Rp 40.000',
      'price': 40000,
      'imagePath': 'assets/images/insole.jpg',
    },
    {
      'title': 'Ganti Tali & Lubang Tali',
      'description': '',
      'priceRange': 'Rp 20.000',
      'price': 20000,
      'imagePath': 'assets/images/talisepatu.jpg',
    },
    {
      'title': 'Perbaikan Hak (Heels)',
      'description': '',
      'priceRange': 'Rp 40.000',
      'price': 40000,
      'imagePath': 'assets/images/haksepatu.jpg',
    },
    {
      'title': 'Recolour / Pewarnaan Ulang',
      'description': '',
      'priceRange': 'Rp 60.000',
      'price': 60000,
      'imagePath': 'assets/images/recolour.jpg',
    },
    {
      'title': 'Perbaikan Lem yang Lepas',
      'description': '',
      'priceRange': 'Rp 20.000',
      'price': 20000,
      'imagePath': 'assets/images/lemlepas.jpg',
    },
    {
      'title': 'Full Restoration',
      'description': '',
      'priceRange': 'Rp 100.000',
      'price': 100000,
      'imagePath': 'assets/images/fullrestore.jpg',
    },
  ];

  final Set<String> bookedServices = {};
  final Map<String, int> quantities = {};
  String selectedPaymentMethod = 'Tunai';
  bool isLoading = false;

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

  Future<void> _confirmBooking(
    String id,
    String title,
    String description,
    int totalPrice,
    int quantity,
  ) async {
    // Check if user is logged in
    if (!_supabaseService.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

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
                  Text('Pesan "$title"'),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jumlah: $quantity',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: Rp ${_formatCurrency(totalPrice)}',
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
                          '🔧 Info Pembayaran & Servis:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Pembayaran 50% di muka, 50% setelah selesai',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Estimasi pengerjaan: 3-7 hari kerja',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Garansi layanan: 30 hari',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          '• Konsultasi gratis sebelum pengerjaan',
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
                    isLoading
                        ? null
                        : () => _processBooking(
                          id,
                          title,
                          description,
                          totalPrice,
                          quantity,
                        ),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Konfirmasi'),
              ),
            ],
          ),
    );
  }

  Future<void> _processBooking(
    String id,
    String title,
    String description,
    int totalPrice,
    int quantity,
  ) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Save to database using SupabaseService
      final orderResponse = await _supabaseService.createOrder(
        serviceType: 'Shoes Repair',
        serviceCategory: 'Perbaikan Sepatu',
        serviceName: title,
        quantity: quantity,
        unitPrice: totalPrice ~/ quantity, // Unit price
        totalPrice: totalPrice,
        paymentMethod: selectedPaymentMethod,
        notes: description,
        paymentStatus: 'Belum Dibayar',
        serviceStatus: 'Dikonfirmasi',
      );

      // **TAMBAHAN PENTING: Simpan ke History Screen**
      final DateTime now = DateTime.now();
      final String formattedDate = '${now.day}/${now.month}/${now.year}';

      // Tambahkan ke history screen
      HistoryScreen.addOrder({
        'id': orderResponse['id'],
        'serviceType': 'Shoes Repair - $title',
        'serviceCategory': 'Perbaikan Sepatu',
        'serviceName': title,
        'date': formattedDate,
        'price': 'Rp ${_formatCurrency(totalPrice)}',
        'itemCount': quantity,
        'paymentMethod': selectedPaymentMethod,
        'paymentStatus': 'Belum Dibayar',
        'serviceStatus': 'Dikonfirmasi',
        'totalPrice': totalPrice,
        'unitPrice': totalPrice ~/ quantity,
        'notes': description,
        'createdAt': now.toIso8601String(),
      });

      // Mark as booked locally
      setState(() {
        bookedServices.add(id);
        isLoading = false;
      });

      // Close dialog
      Navigator.of(context).pop();

      // Show success message
      _showSuccessSnackBar(title, quantity, orderResponse['id']);
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan pesanan: ${_supabaseService.getErrorMessage(e)}',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String title, int quantity, String orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✅ Pesanan berhasil dikonfirmasi!'),
            Text('$title x$quantity'),
            Text('ID Pesanan: $orderId', style: TextStyle(fontSize: 12)),
            Text(
              'Pembayaran: $selectedPaymentMethod',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: '',
          textColor: Colors.white,
          onPressed: () {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          },
        ),
      ),
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Login Diperlukan'),
            content: const Text(
              'Anda harus login terlebih dahulu untuk melakukan pemesanan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to login screen
                  // Get.toNamed('/login'); // Uncomment if using GetX routing
                },
                child: const Text('Login'),
              ),
            ],
          ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final id = service['title'];
    final quantity = quantities[id] ?? 1;
    final total = service['price'] * quantity;
    final isBooked = bookedServices.contains(id);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            GestureDetector(
              onTap:
                  () => _showImageDialog(
                    context,
                    service['imagePath'],
                    service['title'],
                  ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  service['imagePath'],
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title and price section
            Text(
              service['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              service['priceRange'],
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF2C7EF8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Text(
                '🔧 50% dimuka • Garansi 30 hari',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 16),

            // Quantity section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jumlah',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1)
                          setState(() => quantities[id] = quantity - 1);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.remove, size: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => setState(() => quantities[id] = quantity + 1),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.add, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Total: Rp ${_formatCurrency(total)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2C7EF8),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (isBooked || isLoading)
                        ? null
                        : () => _confirmBooking(
                          id,
                          service['title'],
                          service['description'],
                          total,
                          quantity,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isBooked ? Colors.grey.shade300 : const Color(0xFF2C7EF8),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
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
                        color: isBooked ? Colors.grey : Colors.white,
                        size: 18,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      isLoading
                          ? 'Proses...'
                          : (isBooked ? 'Dipesan' : 'Pesan'),
                      style: TextStyle(
                        color: isBooked ? Colors.grey : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
        title: const Text('Shoes Repair Booking'),
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
          // Login button for users who are not logged in
          if (!_supabaseService.isLoggedIn)
            TextButton(
              onPressed: () {
                // Navigate to login
                // Get.toNamed('/login');
              },
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: repairServices.length,
        itemBuilder:
            (context, index) => _buildServiceCard(repairServices[index]),
      ),
    );
  }
}
