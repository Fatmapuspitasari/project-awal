import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Pesanan Diterima',
      'body': 'Pesanan Anda telah diterima dan sedang diproses',
      'time': '10 menit yang lalu',
      'read': false,
      'icon': Icons.local_shipping,
    },
    {
      'title': 'Promo Spesial',
      'body': 'Dapatkan diskon 20% untuk layanan Shoes Repair',
      'time': '1 jam yang lalu',
      'read': true,
      'icon': Icons.discount,
    },
    {
      'title': 'Pengiriman Selesai',
      'body': 'Sepatu Anda telah selesai dibersihkan dan siap untuk diambil',
      'time': '3 jam yang lalu',
      'read': true,
      'icon': Icons.check_circle,
    },
    {
      'title': 'Pembayaran Berhasil',
      'body': 'Terima kasih atas pembayaran Anda',
      'time': 'Kemarin',
      'read': true,
      'icon': Icons.payment,
    },
    {
      'title': 'Permintaan Ulasan',
      'body': 'Bagaimana pengalaman Anda dengan layanan kami?',
      'time': '2 hari yang lalu',
      'read': true,
      'icon': Icons.star,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifikasi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Mark all as read
                    setState(() {
                      for (var notification in _notifications) {
                        notification['read'] = true;
                      }
                    });
                  },
                  child: const Text('Tandai semua dibaca'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationItem(notification, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda akan melihat notifikasi di sini ketika ada pembaruan',
            style: TextStyle(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    return Dismissible(
      key: Key('notification_$index'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifikasi dihapus'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: notification['read'] ? Colors.white : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              notification['icon'],
              color: Colors.blue,
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification['body']),
              const SizedBox(height: 4),
              Text(
                notification['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () {
            setState(() {
              notification['read'] = true;
            });
            // Show notification details
            Get.dialog(
              AlertDialog(
                title: Text(notification['title']),
                content: Text(notification['body']),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          },
          trailing: notification['read']
              ? null
              : Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }
}