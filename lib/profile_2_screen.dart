import 'package:flutter/material.dart';

class Profile2Screen extends StatefulWidget {
  const Profile2Screen({super.key});

  @override
  State<Profile2Screen> createState() => _Profile2ScreenState();
}

class _Profile2ScreenState extends State<Profile2Screen> {
  bool isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? const Color.fromARGB(221, 29, 161, 255) : Colors.white,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: isDarkTheme ? const Color.fromARGB(255, 255, 255, 255) : Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                isDarkTheme
                    ? 'assets/dark_profile.png' // Gambar saat dark mode
                    : 'assets/light_profile.png', // Gambar saat light mode
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selamat datang, Fatma!',
              style: TextStyle(
                fontSize: 30,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleTheme,
              child: const Text('Ganti Tema'),
            ),
          ],
        ),
      ),
    );
  }
}
