import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_awal/splash_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_awal/home_screen.dart';
import 'package:project_awal/message_screen.dart';
import 'package:project_awal/settings_screen.dart';
import 'package:project_awal/profile_2_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ardefva Shoes Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});
  
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late int currentIndex;
  bool isDarkTheme = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Tambahkan controller untuk setiap tab
  late PageController _pageController;

  // Daftar judul untuk setiap halaman
  final List<String> _titles = [
    'Beranda',
    'Profil',
    'Pesan',
    'Pengaturan',
  ];

  // Daftar konten untuk setiap halaman
  final List<Widget> _pages = const [
    HomeScreen(),
    ProfileContent(),
    MessageScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // Inisialisasi page controller dengan index awal
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    _controller.forward().then((_) {
      _controller.reverse();
      setState(() {
        currentIndex = index;
      });
      _pageController.jumpToPage(index);
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? const Color.fromARGB(221, 29, 161, 255) : Colors.white,
      appBar: AppBar(
        title: Text(_titles[currentIndex]),
        backgroundColor: isDarkTheme ? Colors.white : Colors.blue[500],
        actions: [
          IconButton(
            icon: Icon(isDarkTheme ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Menonaktifkan swipe
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ScaleTransition(
              scale: currentIndex == 0 ? _animation : const AlwaysStoppedAnimation(1.0),
              child: IconButton(
                icon: const Icon(Icons.home),
                iconSize: 30,
                color: currentIndex == 0 ? Colors.blue : Colors.black,
                onPressed: () => _onNavTap(0),
              ),
            ),
            ScaleTransition(
              scale: currentIndex == 1 ? _animation : const AlwaysStoppedAnimation(1.0),
              child: IconButton(
                icon: const Icon(Icons.person),
                iconSize: 30,
                color: currentIndex == 1 ? Colors.blue : Colors.black,
                onPressed: () => _onNavTap(1),
              ),
            ),
            ScaleTransition(
              scale: currentIndex == 2 ? _animation : const AlwaysStoppedAnimation(1.0),
              child: IconButton(
                icon: const Icon(Icons.message),
                iconSize: 30,
                color: currentIndex == 2 ? Colors.blue : Colors.black,
                onPressed: () => _onNavTap(2),
              ),
            ),
            ScaleTransition(
              scale: currentIndex == 3 ? _animation : const AlwaysStoppedAnimation(1.0),
              child: IconButton(
                icon: const Icon(Icons.settings),
                iconSize: 30,
                color: currentIndex == 3 ? Colors.blue : Colors.black,
                onPressed: () => _onNavTap(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}