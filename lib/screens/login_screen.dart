import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final RxBool isLoading = false.obs;

  LoginScreen({super.key});

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
                  const Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  _buildTextField("Email", Icons.email, emailController),
                  _buildTextField("Password", Icons.lock, passwordController, obscureText: true),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: rememberMe.value, 
                            onChanged: (value) => rememberMe.value = value!,
                            activeColor: Colors.pinkAccent,
                          )),
                      const Text("Remember Me", style: TextStyle(color: Colors.white)),
                    ],
                  ),
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
                            bool success = await authController.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            isLoading.value = false;

                            if (success) {
                              Get.offAllNamed("/home");
                            } else {
                              Get.snackbar("Error", "Login Failed", backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          },
                          child: const Text("Log In", style: TextStyle(fontSize: 18, color: Colors.white)),
                        )),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Get.to(() => RegisterScreen()),
                    child: const Text("Don't have an account? REGISTER", style: TextStyle(color: Colors.white)),
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
