// lib/core/services/storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dawai_app/features/auth/data/models/user_model.dart';

class StorageService {
  static const String _userKey          = 'current_user';
  static const String _isFirstLaunchKey = 'is_first_launch';

  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // ── حفظ المستخدم ───────────────────────────────────────────────────────────
  Future<void> saveUser(UserModel user) async {
    // toMap() يُرجع: { id, name, phone, is_verified, created_at }
    await _preferences.setString(_userKey, jsonEncode(user.toMap()));
  }

  // ── جلب المستخدم (async) ───────────────────────────────────────────────────
  Future<UserModel?> getUser() async {
    return _parseUser();
  }

  // ── جلب المستخدم (sync) ────────────────────────────────────────────────────
  UserModel? getUserSync() {
    return _parseUser();
  }

  // ── parser مشترك — مفتاح واحد لكلا الدالتين ──────────────────────────────
  UserModel? _parseUser() {
    try {
      final raw = _preferences.getString(_userKey);
      if (raw == null) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;

      return UserModel(
        id:             map['id']?.toString()         ?? '',
        name:           map['name']?.toString()       ?? '',
        phoneNumber:    map['phone']?.toString()      ?? '', // 'phone' كما يُرجع NestJS
        isVerified:     map['is_verified'] as bool?   ?? false,
        profileImageUrl: map['profile_image_url'] as String?,
        address:        map['address'] as String?,
        createdAt:      map['created_at'] != null
            ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  // ── مسح المستخدم ───────────────────────────────────────────────────────────
  Future<void> clearUser() async {
    await _preferences.remove(_userKey);
  }

  // ── أول تشغيل ──────────────────────────────────────────────────────────────
  bool get isFirstLaunch =>
      _preferences.getBool(_isFirstLaunchKey) ?? true;

  Future<void> setFirstLaunchCompleted() async {
    await _preferences.setBool(_isFirstLaunchKey, false);
  }

  // ── مسح الكل ───────────────────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _preferences.clear();
  }
}