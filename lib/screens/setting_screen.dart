import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Bahasa Indonesia';
  
  @override
  void initState() {
    super.initState();
    // Load saved settings
    _notificationsEnabled = box.read('notifications_enabled') ?? true;
    _darkModeEnabled = box.read('dark_mode_enabled') ?? false;
    _selectedLanguage = box.read('selected_language') ?? 'Bahasa Indonesia';
  }
  
  void _saveSettings() {
    box.write('notifications_enabled', _notificationsEnabled);
    box.write('dark_mode_enabled', _darkModeEnabled);
    box.write('selected_language', _selectedLanguage);
    
    Get.snackbar(
      'Success',
      'Pengaturan berhasil disimpan',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue[500],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Akun'),
            _buildAccountSettings(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Tampilan'),
            _buildAppearanceSettings(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Notifikasi'),
            _buildNotificationSettings(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Privasi & Keamanan'),
            _buildPrivacySettings(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Bahasa'),
            _buildLanguageSettings(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Tentang Aplikasi'),
            _buildAboutSettings(),
            
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Simpan Pengaturan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.manage_accounts,
          title: 'Informasi Akun',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to account information page
          },
        ),
        _buildSettingsItem(
          icon: Icons.lock,
          title: 'Ubah Password',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to change password page
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.dark_mode,
          title: 'Mode Gelap',
          trailing: Switch(
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            activeColor: Colors.blue,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.text_fields,
          title: 'Ukuran Font',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to font size settings
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.notifications_active,
          title: 'Aktifkan Notifikasi',
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: Colors.blue,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.notifications,
          title: 'Jenis Notifikasi',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to notification types
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.privacy_tip,
          title: 'Kebijakan Privasi',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to privacy policy
          },
        ),
        _buildSettingsItem(
          icon: Icons.security,
          title: 'Keamanan Akun',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to account security
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSettings() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.language,
          title: 'Pilih Bahasa',
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items: <String>['Bahasa Indonesia', 'English', 'العربية', '中文']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSettings() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.info,
          title: 'Tentang Kami',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to about us
          },
        ),
        _buildSettingsItem(
          icon: Icons.description,
          title: 'Syarat dan Ketentuan',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to terms and conditions
          },
        ),
        _buildSettingsItem(
          icon: Icons.update,
          title: 'Versi Aplikasi',
          trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}