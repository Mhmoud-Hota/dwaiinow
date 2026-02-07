//lib/core/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dawai_app/features/auth/data/models/user_model.dart';

class StorageService {
  static const String _userKey = 'current_user';
  static const String _isFirstLaunchKey = 'is_first_launch';
  
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // حفظ بيانات المستخدم
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toMap());
    await _preferences.setString(_userKey, userJson);
  }

  // جلب بيانات المستخدم
   Future<UserModel?> getUser() async {
    try {
      final userJson = _preferences.getString(_userKey);
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel(
        id: userMap['id'] ?? '', // تأكد من إضافة الـ ID عند الحفظ
        name: userMap['name'] ?? '',
        phoneNumber: userMap['phoneNumber'] ?? '',
        profileImageUrl: userMap['profileImageUrl'],
        address: userMap['address'],
        createdAt: userMap['createdAt'] != null 
            ? DateTime.tryParse(userMap['createdAt']) ?? DateTime.now()
            : DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }


  // جلب بيانات المستخدم بشكل متزامن
  UserModel? getUserSync() {
    try {
      final userJson = _preferences.getString(_userKey);
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel(
        id: userMap['id'] ?? '',
        name: userMap['name'] ?? '',
        phoneNumber: userMap['phoneNumber'] ?? '',
        profileImageUrl: userMap['profileImageUrl'],
        address: userMap['address'],
        createdAt: DateTime.parse(userMap['createdAt'] ?? DateTime.now().toString()),
      );
    } catch (e) {
      return null;
    }
  }

  // مسح بيانات المستخدم
  Future<void> clearUser() async {
    await _preferences.remove(_userKey);
  }

  // التحقق من أول تشغيل للتطبيق
  bool get isFirstLaunch {
    return _preferences.getBool(_isFirstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchCompleted() async {
    await _preferences.setBool(_isFirstLaunchKey, false);
  }

  // تنظيف جميع البيانات المحفوظة
  Future<void> clearAll() async {
    await _preferences.clear();
  }
}