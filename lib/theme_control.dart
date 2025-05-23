import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  ThemeController() {
    isDarkMode.value = _box.read(_key) ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    _box.write(_key, isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

final ThemeController themeController = Get.put(ThemeController());
