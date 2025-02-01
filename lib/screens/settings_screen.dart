import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final ThemeController themeController = Get.find<ThemeController>(); // ✅ Fix: Ensure ThemeController is found

    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("User Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.pinkAccent),
              title: const Text("Name"),
              subtitle: Obx(() => Text(userController.user["name"] ?? "Loading...")),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.pinkAccent),
              title: const Text("Email"),
              subtitle: Obx(() => Text(userController.user["email"] ?? "Loading...")),
            ),

            // ✅ Theme Toggle Button
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.amber),
              title: const Text("Dark Mode"),
              trailing: Obx(() => Switch(
                    value: themeController.isDarkMode.value,
                    onChanged: (value) => themeController.toggleDarkMode(),
                  )),
            ),

            // ✅ Logout Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await userController.logout();
                  Get.offAllNamed('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
