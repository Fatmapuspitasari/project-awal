import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_awal/message_screen..dart';
import 'login_2_screen.dart';
import 'home_screen.dart';

class Profile2Screen extends StatefulWidget {
  const Profile2Screen({super.key});

  @override
  State<Profile2Screen> createState() => _Profile2ScreenState();
}

class _Profile2ScreenState extends State<Profile2Screen>
    with SingleTickerProviderStateMixin {
  bool isDarkTheme = false;
  int currentIndex = 1;

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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Login2Screen()));
  }

  final List<Widget> pages = const [
    HomeScreen(),
    ProfileContent(),
    MessageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      setState(() {
        currentIndex = index;
      });
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
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ScaleTransition(
              scale: _animation,
              child: IconButton(
                icon: const Icon(Icons.home),
                iconSize: 30,
                color: Colors.black,
                onPressed: () => _onNavTap(0),
              ),
            ),
            ScaleTransition(
              scale: _animation,
              child: IconButton(
                icon: const Icon(Icons.person),
                iconSize: 30,
                color: Colors.black,
                onPressed: () => _onNavTap(1),
              ),
            ),
            ScaleTransition(
              scale: _animation,
              child: IconButton(
                icon: const Icon(Icons.message),
                iconSize: 30,
                color: Colors.black,
                onPressed: () => _onNavTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Selamat datang,!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'User ID: fatma123',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
