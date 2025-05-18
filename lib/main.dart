import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_awal/notification_screen.dart';
import 'package:project_awal/splash_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_awal/home_screen.dart';
import 'package:project_awal/message_screen.dart';
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

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late int currentIndex;

  late AnimationController _controller;
  late Animation<double> _animation;

  late PageController _pageController;

  final List<String> _titles = ['Beranda', 'Pesan', 'Notifikasi', 'Profil'];

  final List<Widget> _pages = const [
    HomeScreen(),
    MessageScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    if (currentIndex > 2) currentIndex = 0; // Safety check for out of bounds

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_titles[currentIndex]),
        backgroundColor: Colors.blue[500],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
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
            for (int i = 0; i < 4; i++)
              ScaleTransition(
                scale:
                    currentIndex == i
                        ? _animation
                        : const AlwaysStoppedAnimation(1.0),
                child: IconButton(
                  icon: Icon(
                    i == 0
                        ? Icons.home
                        : i == 1
                        ? Icons.shopping_bag
                        : i == 2
                        ? Icons.notifications
                        : Icons.person,
                  ),
                  iconSize: 30,
                  color: currentIndex == i ? Colors.blue : Colors.black,
                  onPressed: () => _onNavTap(i),
                ),
              ),
          ],
        ),
      ),

      bottomSheet: Container(
        height: 20,
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 4; i++)
              Text(
                i == 0
                    ? 'Beranda'
                    : i == 1
                    ? 'Pesan'
                    : i == 2
                    ? 'Notifikasi'
                    : 'Profil',
                style: TextStyle(
                  fontSize: 12,
                  color: currentIndex == i ? Colors.blue : Colors.grey,
                  fontWeight:
                      currentIndex == i ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
