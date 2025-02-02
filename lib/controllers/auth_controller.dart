import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../controllers/user_controller.dart';
import '../controllers/transaction_controller.dart';
//hgg
class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  var isAuthenticated = false.obs;
  var isLoading = false.obs;

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      var response = await _authService.login(email, password);

      if (response == null || response.isEmpty) {
        isLoading.value = false;
        Get.snackbar("Error", "Invalid response from server", snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      if (response["success"] == true) {
        await storage.write(key: "token", value: response["token"]);
        await storage.write(key: "userId", value: response["userId"]);

        isAuthenticated.value = true;
        Get.offNamed("/home");

        // ✅ Fetch user profile and transactions
        Get.find<UserController>().fetchUserProfile();
        Get.find<TransactionController>().fetchTransactions();

        return true;
      } else {
        Get.snackbar("Login Failed", response["message"] ?? "Unknown error", snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e", snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      var response = await _authService.register(name, email, password);

      if (response == null || response.isEmpty) {
        Get.snackbar("Error", "Invalid response from server", snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      if (response["success"] == true) {
        Get.snackbar("Success", "Registration successful!", snackPosition: SnackPosition.BOTTOM);
        Get.offNamed("/login");
        return true;
      } else {
        Get.snackbar("Error", response["message"] ?? "Unknown error", snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Registration failed: $e", snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    isAuthenticated.value = false;
    Get.offNamed("/login");
  }

  Future<void> checkAuthStatus() async {
    String? token = await storage.read(key: "token");
    isAuthenticated.value = token != null;
  }
}
