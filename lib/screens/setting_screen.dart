import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../theme_control.dart';

// Pastikan semua halaman ini sudah dibuat dan class-nya benar
import 'informasi_akun_screen.dart';
import 'ubah_password_screen.dart';
import 'tentangkami_screen.dart';
import 'syarat_ketentuan_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();
  String _selectedLanguage = 'Bahasa Indonesia';

  @override
  void initState() {
    super.initState();

    _selectedLanguage = box.read('selected_language') ?? 'Bahasa Indonesia';
    bool storedDarkMode = box.read('dark_mode_enabled') ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeController.isDarkMode.value = storedDarkMode;
      Get.changeThemeMode(storedDarkMode ? ThemeMode.dark : ThemeMode.light);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection("Akun", [
            _tile(
              Icons.manage_accounts,
              'Informasi Akun',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InformasiAkunScreen(),
                  ),
                );
              },
            ),
            _tile(
              Icons.lock,
              'Ubah Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UbahPasswordScreen()),
                );
              },
            ),
          ]),
          _buildSection("Tampilan", [
            _obxSwitchTile(Icons.dark_mode, 'Mode Gelap', (val) {
              themeController.toggleTheme(val);
              box.write('dark_mode_enabled', val);
            }),
          ]),
          _buildSection("Tentang Aplikasi", [
            _tile(
              Icons.info,
              'Tentang Kami',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TentangKamiScreen()),
                );
              },
            ),
            _tile(
              Icons.description,
              'Syarat dan Ketentuan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SyaratKetentuanScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.blue),
              title: const Text('Versi Aplikasi'),
              trailing: const Text(
                '1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(
              items.length * 2 - 1,
              (index) =>
                  index.isEven ? items[index ~/ 2] : const Divider(height: 0),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _tile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _obxSwitchTile(
    IconData icon,
    String title,
    ValueChanged<bool> onChanged,
  ) {
    return Obx(
      () => SwitchListTile(
        secondary: Icon(icon, color: Colors.blue),
        title: Text(title),
        value: themeController.isDarkMode.value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }
}
