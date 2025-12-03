import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = Map<String, dynamic>.from(json.decode(userJson));
        return User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<User> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password harus diisi');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Format email tidak valid');
    }

    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    // Create user (in real app, this would come from API)
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _getNameFromEmail(email),
      email: email,
      photoUrl: null,
      favorites: [],
      readingHistory: [],
    );

    // Save user to shared preferences
    await _saveUser(user);

    return user;
  }

  Future<User> register(String name, String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Semua field harus diisi');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Format email tidak valid');
    }

    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    if (name.length < 3) {
      throw Exception('Nama minimal 3 karakter');
    }

    // Check if user already exists (in real app, check with API)
    final existingUser = await getCurrentUser();
    if (existingUser != null && existingUser.email == email) {
      throw Exception('Email sudah terdaftar');
    }

    // Create new user
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      photoUrl: null,
      favorites: [],
      readingHistory: [],
    );

    // Save user to shared preferences
    await _saveUser(user);

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> updateUser(User user) async {
    await _saveUser(user);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toMap());
    await prefs.setString(_userKey, userJson);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String _getNameFromEmail(String email) {
    return email.split('@').first;
  }
}
