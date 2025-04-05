import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  //static const String baseUrl = 'http://localhost:8000/api';
  static const String baseUrl = 'http://192.168.1.77:8000/api';
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';

  final SharedPreferences _prefs;

  AuthService(this._prefs);

  String? get token => _prefs.getString(tokenKey);
  String? get refreshToken => _prefs.getString(refreshTokenKey);

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _prefs.setString(tokenKey, data['access']);
        await _prefs.setString(refreshTokenKey, data['refresh']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> refreshAuthToken() async {
    try {
      final refreshToken = await this.refreshToken;
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _prefs.setString(tokenKey, data['access']);
        return true;
      }
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final authToken = await token;
      if (authToken == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/users/me/'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(refreshTokenKey);
  }
} 