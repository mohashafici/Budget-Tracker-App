import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Register", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  _buildTextField("Full Name", Icons.person, nameController),
                  _buildTextField("Email", Icons.email, emailController),
                  _buildTextField("Password", Icons.lock, passwordController, obscureText: true),
                  const SizedBox(height: 10),
                  Obx(() => isLoading.value
                      ? const CircularProgressIndicator(color: Colors.pinkAccent)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                          ),
                          onPressed: () async {
                            isLoading.value = true;
                            bool success = await authController.register(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            isLoading.value = false;

                            if (success) {
                              Get.snackbar("Success", "Account Created Successfully!", backgroundColor: Colors.green, colorText: Colors.white);
                              Get.off(() => LoginScreen());
                            } else {
                              Get.snackbar("Error", "Registration Failed", backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          },
                          child: const Text("Register", style: TextStyle(fontSize: 18, color: Colors.white)),
                        )),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Get.off(() => LoginScreen()),
                    child: const Text("Already have an account? LOGIN", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
