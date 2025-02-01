import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:8000/api/users"));
  final storage = const FlutterSecureStorage();

  AuthService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await storage.read(key: "token");
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  // 🔹 Login User
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Response response = await _dio.post("/login",
          data: {"email": email, "password": password},
          options: Options(headers: {"Content-Type": "application/json"}));

      print("Login Response: ${response.data}"); // Debugging

      if (response.statusCode == 200 && response.data["user"] != null) {
        String? token = response.data["user"]["token"];
        String? userId = response.data["user"]["_id"];

        if (token == null || userId == null) {
          return {"success": false, "message": "Login failed: Missing token or user ID"};
        }

        await storage.write(key: "token", value: token);
        await storage.write(key: "userId", value: userId);

        return {"success": true, "token": token, "userId": userId};
      } else {
        return {"success": false, "message": response.data["message"] ?? "Login failed"};
      }
    } catch (e) {
      print("Login Error: $e");
      return {"success": false, "message": "Network error. Please try again."};
    }
  }

  // 🔹 Register User
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      Response response = await _dio.post("/register",
          data: {"name": name, "email": email, "password": password},
          options: Options(headers: {"Content-Type": "application/json"}));

      print("Register Response: ${response.data}");

      if (response.statusCode == 201) {
        return {"success": true, "message": "Registration successful!"};
      } else {
        return {"success": false, "message": response.data["message"] ?? "Registration failed"};
      }
    } catch (e) {
      print("Register Error: $e");
      return {"success": false, "message": "Network error. Please try again."};
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    await storage.deleteAll();
  }

  // 🔹 Check if user is authenticated
  Future<bool> isAuthenticated() async {
    String? token = await storage.read(key: "token");
    return token != null;
  }
}
