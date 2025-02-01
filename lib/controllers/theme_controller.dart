import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  var isDarkMode = false.obs; // ✅ Using Rx for reactive state

  @override
  void onInit() {
    _loadTheme(); // Load saved theme on app start
    super.onInit();
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(key: "darkMode", value: isDarkMode.value.toString());
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _loadTheme() async {
    String? storedTheme = await _storage.read(key: "darkMode");
    if (storedTheme != null) {
      isDarkMode.value = storedTheme == "true";
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
