import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/splash_screen.dart';
import 'theme_control.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/database/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

try{
  await GetStorage.init();

  await Supabase.initialize(
    url: 'https://uuwcqaywksbgrhoumkae.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1d2NxYXl3a3NiZ3Job3Vta2FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2NjUyMzEsImV4cCI6MjA2MzI0MTIzMX0.ckc8o2A8ormTQOX2gVfwlOc0CRVp6aiejAEECrhiULc',
  );

  await SupabaseService.init();

Get.put(ThemeController());

  runApp(const MyApp());
} catch (e, stackTrace) {
  print('❌ Error saat init: $e');
  print(stackTrace);

      runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Terjadi kesalahan saat memulai aplikasi.\nSilakan coba lagi nanti.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ardefva Shoes Care',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF1E1E1E),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      );
    });
  }
}
