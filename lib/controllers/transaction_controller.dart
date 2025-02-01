import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class TransactionController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: "http://localhost:8000/api"));
  final storage = const FlutterSecureStorage();

  var transactions = <Map<String, dynamic>>[].obs;
  var filteredTransactions = <Map<String, dynamic>>[].obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedDay = (-1).obs; // ✅ -1 means "All Days"
  var searchQuery = "".obs; // ✅ Search filter

  @override
  void onInit() {
    super.onInit();
    fetchTransactions(); // ✅ Fetch transactions on app startup
  }

  // 🔹 Fetch Transactions
  Future<void> fetchTransactions() async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) {
        debugPrint("⚠️ Error: No token found");
        return;
      }

      dio.Response response = await _dio.get(
        "/transactions",
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      transactions.value = List<Map<String, dynamic>>.from(response.data);
      filterTransactions();
    } catch (e) {
      debugPrint("❌ Error fetching transactions: $e");
    }
  }

  // ✅ Fixed missing method: Apply Filters (Month, Day & Search)
  void filterTransactions() {
    filteredTransactions.value = transactions.where((transaction) {
      DateTime date = DateTime.parse(transaction["date"]);
      bool matchesMonth = date.month == selectedMonth.value;
      bool matchesDay = (selectedDay.value == -1) || (date.day == selectedDay.value);
      bool matchesSearch = searchQuery.isEmpty ||
          transaction["title"].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          transaction["category"].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          transaction["amount"].toString().contains(searchQuery.value);
      return matchesMonth && matchesDay && matchesSearch;
    }).toList();
    update(); // ✅ Trigger UI update
  }

  // 🔹 Update Selected Month & Apply Filter
  void filterTransactionsByMonth(int month) {
    selectedMonth.value = month;
    filterTransactions();
  }

  // 🔹 Update Selected Day & Apply Filter (Including "All Days")
  void filterTransactionsByDay(int day) {
    selectedDay.value = day;
    filterTransactions();
  }

  // 🔹 Update Search Query & Apply Filter
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterTransactions();
  }

  // 🔹 Add Transaction (Fixed with `user` field and token validation)
Future<void> addTransaction(String title, double amount, String category, String type) async {
  try {
    if (title.isEmpty || amount <= 0 || category.isEmpty || type.isEmpty) {
      Get.snackbar("Error", "All fields are required!", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    String? token = await storage.read(key: "token");
    String? userId = await storage.read(key: "userId");

    if (token == null || userId == null) {
      Get.snackbar("Error", "User authentication failed", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // ✅ Ensure the `type` is in lowercase
    String formattedType = type.toLowerCase();  // Fixes "Expense" -> "expense"

    // ✅ Ensure the correct request format
    Map<String, dynamic> transactionData = {
      "user": userId,  // Use stored user ID
      "title": title.trim(),
      "amount": amount,
      "category": category.trim(),
      "type": formattedType,  // Now lowercase
      "date": DateTime.now().toIso8601String() // ISO format date
    };

    print("🔹 Sending Transaction Data: $transactionData"); // Debugging

    dio.Response response = await _dio.post(
      "/transactions",
      data: transactionData,
      options: dio.Options(headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"}),
    );

    if (response.statusCode == 201) {
      transactions.insert(0, response.data); // ✅ Instantly update list
      filterTransactions();
      Get.snackbar("Success", "Transaction added successfully!", backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Error", "Failed to add transaction", backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    print("❌ Error adding transaction: $e");
    Get.snackbar("Error", "Transaction failed: $e", backgroundColor: Colors.red, colorText: Colors.white);
  }
}


  // 🔹 Delete Transaction
  Future<void> deleteTransaction(String id) async {
    try {
      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.delete(
        "/transactions/$id",
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        transactions.removeWhere((t) => t["_id"] == id);
        filterTransactions();
        Get.snackbar("Success", "Transaction deleted successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to delete transaction", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ Error deleting transaction: $e");
    }
  }

  // 🔹 Edit Transaction
  Future<void> editTransaction(String id, String title, double amount, String category, String type) async {
    try {
      if (title.isEmpty || amount <= 0 || category.isEmpty || type.isEmpty) {
        Get.snackbar("Error", "All fields are required!", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      String? token = await storage.read(key: "token");
      if (token == null) return;

      dio.Response response = await _dio.put(
        "/transactions/$id",
        data: {"title": title, "amount": amount, "category": category, "type": type},
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        int index = transactions.indexWhere((t) => t["_id"] == id);
        if (index != -1) {
          transactions[index] = response.data;
          filterTransactions();
          Get.snackbar("Success", "Transaction updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to update transaction", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ Error editing transaction: $e");
    }
  }
}
