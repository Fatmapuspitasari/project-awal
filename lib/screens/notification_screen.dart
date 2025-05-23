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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifikasi',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
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
          ),
          Expanded(
            child:
                _notifications.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                      itemCount: _notifications.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return _buildNotificationItem(
                          notification,
                          index,
                          theme,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda akan melihat notifikasi di sini ketika ada pembaruan',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    Map<String, dynamic> notification,
    int index,
    ThemeData theme,
  ) {
    final isRead = notification['read'];
    final cardColor =
        isRead ? theme.cardColor : theme.colorScheme.primary.withOpacity(0.1);

    return Dismissible(
      key: Key('notification_$index'),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
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
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              notification['read'] = true;
            });
            Get.dialog(
              AlertDialog(
                backgroundColor: theme.dialogBackgroundColor,
                titleTextStyle: theme.textTheme.titleLarge,
                contentTextStyle: theme.textTheme.bodyMedium,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    notification['icon'],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isRead ? FontWeight.w500 : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['body'],
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification['time'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
