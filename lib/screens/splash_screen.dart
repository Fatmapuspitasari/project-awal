import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_awal/screens/login/login_2_screen.dart';
import 'package:project_awal/screens/login/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Check authentication status after animation
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for splash animation to complete
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Check if user has valid Supabase session
      final supabaseClient = Supabase.instance.client;
      final session = supabaseClient.auth.currentSession;

      if (session != null) {
        // Session exists and is valid
        // Save user data to local storage for quick access
        await _saveUserData(session.user);

        // Navigate to main screen
        if (mounted) {
          Get.offAll(() => const MainScreen(initialIndex: 0));
        }
      } else {
        // No valid session, check local storage for fallback
        await _checkLocalStorage();
      }
    } catch (e) {
      // Error occurred, fallback to local storage check
      print('Error checking auth status: $e');
      await _checkLocalStorage();
    }
  }

  Future<void> _checkLocalStorage() async {
    // Fallback: check local storage
    final String? username = box.read('username');
    final String? email = box.read('email');
    final bool? isLoggedIn = box.read('is_logged_in');

    if (username != null && email != null && isLoggedIn == true) {
      // User data exists in local storage
      if (mounted) {
        Get.offAll(() => const MainScreen(initialIndex: 0));
      }
    } else {
      // No user data, go to login
      if (mounted) {
        Get.offAll(() => const Login2Screen());
      }
    }
  }

  Future<void> _saveUserData(User user) async {
    // Save user data to local storage
    await box.write(
      'username',
      user.userMetadata?['username'] ?? user.email?.split('@')[0] ?? 'User',
    );
    await box.write('email', user.email ?? '');
    await box.write('user_id', user.id);
    await box.write('is_logged_in', true);
    await box.write('last_login', DateTime.now().toIso8601String());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
