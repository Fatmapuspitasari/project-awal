import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'supabase_service.dart';

class Login2Screen extends StatefulWidget {
  const Login2Screen({super.key});

  @override
  State<Login2Screen> createState() => _Login2ScreenState();
}

class _Login2ScreenState extends State<Login2Screen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final box = GetStorage();
  bool _obscurePassword = true;
  bool _isLoading = false;

  SupabaseService get _supabase => Get.put(SupabaseService());
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final res = await _supabase.signIn(email: email, password: password);

      if (res.user != null && res.session != null) {
        // Save user data to persistent storage
        await _saveUserDataToStorage(res.user!);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login berhasil!'), backgroundColor: Colors.green),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAll(() => const MainScreen(initialIndex: 0));
        }
      } else {
        _showError('Login gagal: Tidak dapat mengautentikasi pengguna.');
      }
    } on AuthException catch (e) {
      _showError(_supabase.getErrorMessage(e));
    } catch (e) {
      _showError('Terjadi kesalahan: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserDataToStorage(User user) async {
    // Save complete user data for persistent login
    await box.write('username', user.userMetadata?['username'] ?? user.email?.split('@')[0] ?? 'User');
    await box.write('email', user.email ?? '');
    await box.write('user_id', user.id);
    await box.write('is_logged_in', true);
    await box.write('last_login', DateTime.now().toIso8601String());
    
    // Save additional user metadata if available
    if (user.userMetadata != null) {
      await box.write('user_metadata', user.userMetadata);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) return _showError('Masukkan email terlebih dahulu', Colors.orange);
    if (!_emailRegex.hasMatch(email)) return _showError('Format email tidak valid');

    try {
      await _supabase.resetPassword(email);
      _showError('Link reset password telah dikirim ke email Anda', Colors.green);
    } catch (e) {
      _showError(_supabase.getErrorMessage(e));
    }
  }

  void _showError(String message, [Color color = Colors.red]) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Silakan login untuk melanjutkan',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "contoh@email.com",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
                      if (!_emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Minimal 6 karakter",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                      if (value.length < 6) return 'Password minimal 6 karakter';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: const Text('Lupa Password?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : const Text('Masuk', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun? '),
                      TextButton(
                        onPressed: () => Get.to(() => const RegisterScreen()),
                        child: const Text('Daftar di sini', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}