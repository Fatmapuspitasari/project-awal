import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'login_2_screen.dart';
import 'edit_profil_screen.dart';
import 'bantuan_screen.dart';
import 'setting_screen.dart';
import 'supabase_service.dart';

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
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: theme.iconTheme.color?.withAlpha(135),
                ),
              ),
              const SizedBox(height: 16),
              Text(username, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(email, style: textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
              const SizedBox(height: 30),

              _buildOption(
                icon: Icons.edit,
                title: "Edit Profil",
                onTap: () => Get.to(() => const EditProfileScreen()),
                theme: theme,
              ),
              _buildOption(
                icon: Icons.settings,
                title: "Pengaturan",
                onTap: () => Get.to(() => const SettingsScreen()),
                theme: theme,
              ),
              _buildOption(
                icon: Icons.help_outline,
                title: "Bantuan",
                onTap: () => Get.to(() => const BantuanScreen()),
                theme: theme,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.iconTheme.color?.withAlpha(135),
      ),
      onTap: onTap,
      horizontalTitleGap: 0,
    );
  }
}
