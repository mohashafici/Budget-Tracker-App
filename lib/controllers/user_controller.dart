import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: "http://localhost:8000/api"));
  final storage = const FlutterSecureStorage();

  var user = {}.obs;
  var budgetGoal = 0.0.obs; // ✅ Add budget goal observable

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchBudgetGoal(); // ✅ Fetch budget goal when initializing
  }

  Future<void> fetchUserProfile() async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.get(
        "/users/profile",
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      user.value = response.data;
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  Future<void> updateUserProfile(String name, String email) async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.put(
        "/users/profile",
        data: {"name": name, "email": email},
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        user.value = response.data;
      }
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  Future<void> fetchBudgetGoal() async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.get(
        "/users/budget-goal",
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      budgetGoal.value = response.data["budgetGoal"] ?? 0.0;
    } catch (e) {
      print("Error fetching budget goal: $e");
    }
  }

  Future<void> setBudgetGoal(double goal) async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.put(
        "/users/budget-goal",
        data: {"budgetGoal": goal},
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      budgetGoal.value = response.data["budgetGoal"];
    } catch (e) {
      print("Error setting budget goal: $e");
    }
  }
   Future<void> logout() async {
    await storage.delete(key: "token");
    user.value = {}; // Clear user data
    Get.offAllNamed('/login'); // Redirect to login
  }
}

