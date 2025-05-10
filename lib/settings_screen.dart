import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'settings_detail_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GetStorage box = GetStorage();
  bool notifikasiDisaktifkan = false;
  bool modeDarkDiaktifkan = false;
  String bahasaDipilih = 'Indonesia';
  double ukuranFont = 14.0;

  @override
  void initState() {
    super.initState();
    // Ambil pengaturan dari storage jika tersedia
    notifikasiDisaktifkan = box.read('notifikasi_dimatikan') ?? false;
    modeDarkDiaktifkan = box.read('mode_dark') ?? false;
    bahasaDipilih = box.read('bahasa') ?? 'Indonesia';
    ukuranFont = box.read('ukuran_font') ?? 14.0;
  }

  void _simpanPengaturan() {
    box.write('notifikasi_dimatikan', notifikasiDisaktifkan);
    box.write('mode_dark', modeDarkDiaktifkan);
    box.write('bahasa', bahasaDipilih);
    box.write('ukuran_font', ukuranFont);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = box.read('username') ?? 'Pengguna';
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader('Notifikasi'),
        SwitchListTile(
          title: const Text('Matikan Notifikasi'),
          subtitle: const Text('Jika diaktifkan, semua notifikasi akan dimatikan'),
          value: notifikasiDisaktifkan,
          onChanged: (bool value) {
            setState(() {
              notifikasiDisaktifkan = value;
            });
          },
        ),
        const Divider(),
        
        _buildSectionHeader('Tampilan'),
        SwitchListTile(
          title: const Text('Mode Gelap'),
          subtitle: const Text('Aktifkan mode gelap untuk mengurangi ketegangan mata'),
          value: modeDarkDiaktifkan,
          onChanged: (bool value) {
            setState(() {
              modeDarkDiaktifkan = value;
            });
          },
        ),
        ListTile(
          title: const Text('Ukuran Font'),
          subtitle: Text('Sesuaikan ukuran teks: ${ukuranFont.toStringAsFixed(1)}'),
          trailing: SizedBox(
            width: 150,
            child: Slider(
              value: ukuranFont,
              min: 12.0,
              max: 20.0,
              divisions: 8,
              onChanged: (double value) {
                setState(() {
                  ukuranFont = value;
                });
              },
            ),
          ),
        ),
        const Divider(),
        
        _buildSectionHeader('Bahasa'),
        RadioListTile<String>(
          title: const Text('Indonesia'),
          value: 'Indonesia',
          groupValue: bahasaDipilih,
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                bahasaDipilih = value;
              });
            }
          },
        ),
        RadioListTile<String>(
          title: const Text('English'),
          value: 'English',
          groupValue: bahasaDipilih,
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                bahasaDipilih = value;
              });
            }
          },
        ),
        const Divider(),
        
        _buildSectionHeader('Akun'),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Informasi Akun'),
          subtitle: Text('ID: $username'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AkunDetailScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Keamanan'),
          subtitle: const Text('Ubah kata sandi dan pengaturan keamanan'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KeamananScreen()),
            );
          },
        ),
        const Divider(),
        
        _buildSectionHeader('Tentang Aplikasi'),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Versi Aplikasi'),
          subtitle: const Text('Ardefva Shoes Care v1.0.0'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Informasi Versi'),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ardefva Shoes Care'),
                    SizedBox(height: 8),
                    Text('Versi: 1.0.0'),
                    SizedBox(height: 8),
                    Text('Terakhir diperbarui: 1 Mei 2025'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.policy),
          title: const Text('Kebijakan Privasi'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KebijakanPrivasiScreen()),
            );
          },
        ),
        const SizedBox(height: 20),
        
        ElevatedButton(
          onPressed: _simpanPengaturan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Simpan Pengaturan',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}