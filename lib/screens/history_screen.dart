import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();

  static void addOrder(Map<String, Object> orderData) {
    _HistoryScreenState.allOrders.add(orderData);
  }
}

class _HistoryScreenState extends State<HistoryScreen> with TickerProviderStateMixin {
  static List<Map<String, dynamic>> allOrders = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _deleteOrder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(23),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hapus Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus riwayat pesanan ini?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  allOrders.removeAt(allOrders.length - 1 - index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Riwayat pesanan berhasil dihapus'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
        )),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(113),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getServiceColor(order['serviceType']).withAlpha(23),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getServiceIcon(order['serviceType']),
                            size: 14,
                            color: _getServiceColor(order['serviceType']),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            order['serviceType'],
                            style: TextStyle(
                              color: _getServiceColor(order['serviceType']),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order['orderDate'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _deleteOrder(index),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(23),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                Text(
                  order['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                
                if (order['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    order['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C7EF8).withAlpha(23),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 14,
                            color: Color(0xFF2C7EF8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${order['quantity']} item',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C7EF8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Rp ${order['totalPrice']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C7EF8),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pembayaran',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order['paymentMethod'] ?? 'Tunai',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1a1a1a),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPaymentStatusColor(order['paymentStatus'] ?? 'Belum Dibayar').withAlpha(23),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getPaymentStatusIcon(order['paymentStatus'] ?? 'Belum Dibayar'),
                            size: 12,
                            color: _getPaymentStatusColor(order['paymentStatus'] ?? 'Belum Dibayar'),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order['paymentStatus'] ?? 'Belum Dibayar',
                            style: TextStyle(
                              color: _getPaymentStatusColor(order['paymentStatus'] ?? 'Belum Dibayar'),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                if (order['paymentInfo'] != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order['paymentInfo'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'Shoes Care':
        return Icons.cleaning_services;
      case 'Shoes Repair':
        return Icons.build;
      case 'Shoes Wash':
        return Icons.local_laundry_service;
      default:
        return Icons.shopping_bag;
    }
  }

  IconData _getPaymentStatusIcon(String paymentStatus) {
    switch (paymentStatus) {
      case 'Lunas':
      case 'Sudah Dibayar':
        return Icons.check_circle;
      case 'Belum Dibayar':
        return Icons.schedule;
      case 'Sebagian':
      case 'DP 50%':
        return Icons.schedule;
      default:
        return Icons.schedule;
    }
  }

  Color _getServiceColor(String serviceType) {
    switch (serviceType) {
      case 'Shoes Care':
        return const Color(0xFF8B5CF6); // Purple
      case 'Shoes Repair':
        return const Color(0xFFEF4444); // Red
      case 'Shoes Wash':
        return const Color(0xFF3B82F6); // Blue
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String paymentStatus) {
    switch (paymentStatus) {
      case 'Lunas':
      case 'Sudah Dibayar':
        return const Color(0xFF10B981); 
      case 'Belum Dibayar':
        return const Color(0xFFEF4444); 
      case 'Sebagian':
      case 'DP 50%':
        return const Color(0xFFF59E0B); 
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum ada riwayat pesanan',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1a1a1a),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan yang dikonfirmasi akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF2C7EF8),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (allOrders.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${allOrders.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: allOrders.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                _animationController.reset();
                _animationController.forward();
              },
              color: const Color(0xFF2C7EF8),
              backgroundColor: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: allOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    allOrders[allOrders.length - 1 - index],
                    index,
                  );
                },
              ),
            ),
    );
  }
}