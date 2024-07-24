import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static const String _keyIsLoggedIn = 'isLoggedIn';

  static Future<void> login(String username, String password) async {
    if (username == 'admin' && password == 'admin') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
    } else {
      throw Exception('Invalid username or password');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
