import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/user_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  late UserDataSource _userDataSource;
  late SharedPreferences _prefs;

  static const String _currentUserKey = 'current_user';
  User? _currentUser;

  AuthRepositoryImpl() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _userDataSource = UserDataSource();
    await _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson != null) {
      try {
        final decoded = jsonDecode(userJson);
        _currentUser = User.fromJson(decoded);
      } catch (e) {
        print('خطأ في تحميل المستخدم: $e');
        _currentUser = null;
      }
    }
  }

  Future<void> _saveCurrentUser(User? user) async {
    if (user != null) {
      await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    } else {
      await _prefs.remove(_currentUserKey);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await _userDataSource.getUserByEmail(email);
      if (user == null) {
        throw Exception('المستخدم غير موجود');
      }
      if (user.password != password) {
        throw Exception('كلمة السر غير صحيحة');
      }
      _currentUser = user;
      await _saveCurrentUser(user);
      return user;
    } catch (e) {
      throw Exception('خطأ: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String email, String password, String name) async {
    try {
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        createdAt: DateTime.now(),
      );

      await _userDataSource.createUser(newUser);
      _currentUser = newUser;
      await _saveCurrentUser(newUser);
      return newUser;
    } catch (e) {
      throw Exception('خطأ: ${e.toString()}');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      return await _userDataSource.getAllUsers();
    } catch (e) {
      throw Exception('خطأ: ${e.toString()}');
    }
  }

  Future<int> getUserCount() async {
    try {
      return await _userDataSource.getUserCount();
    } catch (e) {
      throw Exception('خطأ: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _currentUser != null;
  }

  @override
  Future<void> logout() async {
    try {
      _currentUser = null;
      await _saveCurrentUser(null);
    } catch (e) {
      throw Exception('خطأ: ${e.toString()}');
    }
  }

  User? getCurrentUser() {
    return _currentUser;
  }
}
