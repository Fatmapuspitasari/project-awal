import 'package:flutter/material.dart';
import 'package:project_awal/screens/home_screen.dart';
import 'package:project_awal/screens/message_screen.dart';
import 'package:project_awal/screens/notification_screen.dart';
import 'package:project_awal/screens/profile_2_screen.dart';
import 'package:project_awal/widget/custom_bottom_label.dart';
import 'package:project_awal/widget/custom_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late int currentIndex;
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController _pageController;

  final List<String> _titles = ['Beranda', 'Pesan', 'Notifikasi', 'Profil'];
  final List<Widget> _pages = const [
    HomeScreen(),
    MessageScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    if (currentIndex > 3) currentIndex = 0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        animation: _animation,
        onTap: _onNavTap,
      ),
      bottomSheet: CustomBottomLabel(currentIndex: currentIndex),
    );
  }
}
