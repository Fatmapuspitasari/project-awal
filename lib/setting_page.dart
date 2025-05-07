import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(height: 10),
                Text('Nama Lengkap', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('email@example.com', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Divider(height: 40),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingTile(context, Icons.person, 'Profil Saya', () {}),
          _buildSettingTile(context, Icons.lock, 'Ubah Kata Sandi', () {}),
          _buildSettingTile(context, Icons.logout, 'Keluar', () {
          }),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Preferensi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingTile(context, Icons.notifications, 'Pengaturan Notifikasi', () {}),
          _buildSettingTile(context, Icons.language, 'Bahasa', () {}),
          _buildSettingTile(context, Icons.dark_mode, 'Tema', () {
          }),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Alamat & Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingTile(context, Icons.location_on, 'Alamat Saya', () {}),
          _buildSettingTile(context, Icons.credit_card, 'Metode Pembayaran', () {}),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Informasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingTile(context, Icons.history, 'Riwayat Pemesanan', () {}),
          _buildSettingTile(context, Icons.help_outline, 'Pusat Bantuan', () {}),
          _buildSettingTile(context, Icons.policy, 'Kebijakan Privasi', () {}),
          _buildSettingTile(context, Icons.info_outline, 'Versi Aplikasi', () {}),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: onTap,
      ),
    );
  }
}
