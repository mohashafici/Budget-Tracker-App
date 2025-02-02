import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async storage initialization

  // ✅ Register controllers before app starts
  Get.put(ThemeController());  // Fixes "ThemeController Not Found" issue
  Get.put(AuthController());
  Get.put(TransactionController());
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Budget Tracker',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const AuthWrapper()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/register", page: () => RegisterScreen()),
        GetPage(name: "/home", page: () => const HomeScreen()),
        GetPage(name: "/stats", page: () =>  StatsScreen()),
        GetPage(name: "/settings", page: () => SettingsScreen()),
      ],
      themeMode: Get.find<ThemeController>().isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

//Authwrapper
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      return authController.isAuthenticated.value ? const HomeScreen() : LoginScreen();
    });
  }
}
