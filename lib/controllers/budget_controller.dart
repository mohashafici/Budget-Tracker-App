import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio; // ✅ Prefix Dio to avoid conflict
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BudgetController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: "http://localhost:8000/api"));
  final storage = const FlutterSecureStorage();
  var budgetGoal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBudgetGoal();
  }
//fetching budgetgoal
  Future<void> fetchBudgetGoal() async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.get( // ✅ Explicitly use `dio.Response`
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

      dio.Response response = await _dio.put( // ✅ Explicitly use `dio.Response`
        "/users/budget-goal",
        data: {"budgetGoal": goal},
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      budgetGoal.value = response.data["budgetGoal"];
    } catch (e) {
      print("Error setting budget goal: $e");
    }
  }
}
