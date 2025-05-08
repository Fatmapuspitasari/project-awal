import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {
        'title': 'Pesanan Anda Diterima',
        'subtitle': 'Sepatu akan dijemput hari ini pukul 14.00',
        'time': '10:45',
        'content': 'Terima kasih telah menggunakan Shoes Care. Tim kami akan menjemput sepatu Anda hari ini pukul 14.00 di alamat yang terdaftar.'
      },
      {
        'title': 'Status: Dalam Proses',
        'subtitle': 'Pencucian sedang berlangsung...',
        'time': '09:20',
        'content': 'Sepatu Anda sedang dicuci oleh tim profesional kami. Kami akan menginformasikan saat proses selesai.'
      },
      {
        'title': 'Promo Spesial!',
        'subtitle': 'Diskon 20% untuk pelanggan setia',
        'time': 'Kemarin',
        'content': 'Hai! Dapatkan diskon 20% untuk layanan selanjutnya. Berlaku hingga akhir bulan ini.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return ListTile(
            leading: const Icon(Icons.message, color: Colors.blue),
            title: Text(msg['title'] ?? ''),
            subtitle: Text(msg['subtitle'] ?? ''),
            trailing: Text(msg['time'] ?? ''),
            onTap: () {
              Get.to(() => MessageDetailScreen(
                    title: msg['title']!,
                    content: msg['content']!,
                  ));
            },
          );
        },
      ),
    );
  }
}

class MessageDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const MessageDetailScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[500],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
