import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_awal/screens/login/login_2_screen.dart';
import 'bantuan_screen.dart';
import 'tentangkami_screen.dart';
import 'syarat_ketentuan_screen.dart';
import 'package:project_awal/screens/database/supabase_service.dart';
import 'package:project_awal/theme_control.dart';
import 'edit_profil_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();
  late String username;
  late String email;

  SupabaseService get _supabase => Get.put(SupabaseService());

  @override
  void initState() {
    super.initState();
    username = box.read('username') ?? 'User';
    email = box.read('email') ?? '$username@email.com';

    // Initialize theme
    bool storedDarkMode = box.read('dark_mode_enabled') ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeController.isDarkMode.value = storedDarkMode;
      Get.changeThemeMode(storedDarkMode ? ThemeMode.dark : ThemeMode.light);
    });
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi Logout"),
            content: const Text("Apakah kamu yakin ingin keluar?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _performLogout();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _performLogout() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _supabase.signOut();
      await box.erase();

      Get.back();
      Get.offAll(() => const Login2Screen());

      Get.snackbar(
        'Logout Berhasil',
        'Anda telah berhasil keluar dari aplikasi',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      await box.erase();
      Get.offAll(() => const Login2Screen());

      Get.snackbar(
        'Logout',
        'Logout berhasil (dengan peringatan: ${e.toString()})',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        theme.brightness == Brightness.dark
                            ? Colors.grey[700]
                            : Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: theme.iconTheme.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSection("Pengaturan", [
                      _buildOption(
                        icon: Icons.edit,
                        title: "Informasi Akun",
                        subtitle: "Kelola informasi profil Anda",
                        onTap: () => Get.to(() => const EditProfileScreen()),
                        theme: theme,
                      ),
                      _buildSwitchOption(
                        icon: Icons.dark_mode,
                        title: "Mode Gelap",
                        subtitle: "Ubah tema aplikasi",
                        onChanged: (val) {
                          themeController.toggleTheme(val);
                          box.write('dark_mode_enabled', val);
                        },
                        theme: theme,
                      ),
                    ]),

                    _buildSection("Informasi", [
                      _buildOption(
                        icon: Icons.help_outline,
                        title: "Bantuan",
                        subtitle: "Dapatkan bantuan dan dukungan",
                        onTap: () => Get.to(() => const BantuanScreen()),
                        theme: theme,
                      ),
                      _buildOption(
                        icon: Icons.info_outline,
                        title: "Tentang Kami",
                        subtitle: "Informasi tentang aplikasi",
                        onTap: () => Get.to(() => const TentangKamiScreen()),
                        theme: theme,
                      ),
                      _buildOption(
                        icon: Icons.description_outlined,
                        title: "Syarat dan Ketentuan",
                        subtitle: "Ketentuan penggunaan aplikasi",
                        onTap:
                            () => Get.to(() => const SyaratKetentuanScreen()),
                        theme: theme,
                      ),
                      _buildInfoTile(
                        icon: Icons.info,
                        title: "Versi Aplikasi",
                        value: "1.0.0",
                        theme: theme,
                      ),
                    ]),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () => logout(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Keluar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  theme.brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.blueGrey[700],
            ),
          ),
        ),
        Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: theme.cardColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: List.generate(
                items.length * 2 - 1,
                (index) =>
                    index.isEven
                        ? items[index ~/ 2]
                        : Divider(
                          height: 1,
                          thickness: 0.5,
                          color: theme.dividerColor.withOpacity(0.3),
                          indent: 56,
                        ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.hintColor,
          fontSize: 12,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.hintColor, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return Obx(
      () => SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: 12,
          ),
        ),
        value: themeController.isDarkMode.value,
        onChanged: onChanged,
        activeColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: theme.hintColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
