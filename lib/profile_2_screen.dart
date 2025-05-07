import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_awal/login_2_screen.dart';
import 'home_screen.dart' as home_screen;  // alias untuk home_screen.dart
import 'setting_page.dart' as setting_page;  // alias untuk setting_page.dart

class Profile2Screen extends StatefulWidget {
  const Profile2Screen({super.key});

  @override
  State<Profile2Screen> createState() => _Profile2ScreenState();
}

class _Profile2ScreenState extends State<Profile2Screen>
    with SingleTickerProviderStateMixin {
  bool isDarkTheme = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  void logout() {
    final box = GetStorage();
    box.erase();
    Get.offAll(() => const Login2Screen());
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    _controller.forward().then((_) {
      _controller.reverse();
      switch (index) {
        case 0:
          Get.to(() => const home_screen.HomeScreen());
          break;
        case 1:
          Get.to(() => const Profile2Screen());
          break;
        case 2:
          Get.to(() => const setting_page.SettingsScreen()); // Menggunakan alias
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDarkTheme ? const Color.fromARGB(221, 29, 161, 255) : Colors.white,
      appBar: AppBar(
        title: const Text('Ardefva Shoes Care'),
        backgroundColor: isDarkTheme ? Colors.white : Colors.blue[500],
        actions: [
          IconButton(
            icon: Icon(isDarkTheme ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            isDarkTheme ? Colors.grey[800] : Colors.blue[200],
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Selamat datang, Fatma!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'User ID: fatma123',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkTheme ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 30,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () => _onNavTap(0),
                  ),
                ),
                ScaleTransition(
                  scale: _animation,
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 30,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () => _onNavTap(1),
                  ),
                ),
                ScaleTransition(
                  scale: _animation,
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 30,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () => _onNavTap(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

