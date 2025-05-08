import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'profile_2_screen.dart'; 

class Login2Screen extends StatefulWidget {
  const Login2Screen({super.key});

  @override
  State<Login2Screen> createState() => _Login2ScreenState();
}

class _Login2ScreenState extends State<Login2Screen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String correctUsername = "fatma";
  final String correctPassword = "fatma123";
  bool passwordTampil = true;

  void login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == correctUsername && password == correctPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile2Screen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
    }
  }

  void menampilkanPassword() {
    setState(() {
      passwordTampil = !passwordTampil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      backgroundColor: passwordTampil
          ? const Color.fromARGB(255, 20, 195, 253)
          : Colors.greenAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ardefva Shoes Care!",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                  const SizedBox(height: 10), 
                  Icon(
                    FontAwesomeIcons.shoePrints, 
                    size: 50, 
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: passwordTampil,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Masukkan Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordTampil
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: passwordTampil
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : const Color.fromARGB(255, 0, 6, 10),
                    ),
                    onPressed: menampilkanPassword,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final box = GetStorage();
                  box.write("username", _usernameController.text);
                  Get.to(() => const Profile2Screen());
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
