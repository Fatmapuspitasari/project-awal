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
          label: 'Lihat Riwayat',
          textColor: Colors.white,
          onPressed: () {
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
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                child: Container(
                  width: double.infinity,
                  height: 120,
                  child: Image.asset(service['imagePath'], fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              service['title'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              service['description'],
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Price
            Text(
              service['priceRange'],
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF2C7EF8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Info badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Text(
                '🔧 50% dimuka • 30 hari',
                style: TextStyle(fontSize: 8, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 8),

            // Quantity controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jumlah', style: TextStyle(fontSize: 12)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1)
                          setState(() => quantities[id] = quantity - 1);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.remove, size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('$quantity', style: TextStyle(fontSize: 12)),
                    ),
                    GestureDetector(
                      onTap:
                          () => setState(() => quantities[id] = quantity + 1),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total price
            Text(
              'Total: Rp ${_formatCurrency(total)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),

            // Order button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isBooked
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: isBooked ? Colors.grey : Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBooked ? 'Dipesan' : 'Pesan',
                      style: TextStyle(
                        color: isBooked ? Colors.grey : Colors.white,
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
        title: const Text('Shoes Repair Booking'),
        backgroundColor: const Color(0xFF2C7EF8),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: repairServices.length,
          itemBuilder:
              (context, index) => _buildServiceCard(repairServices[index]),
        ),
      ),
    );
  }
}
