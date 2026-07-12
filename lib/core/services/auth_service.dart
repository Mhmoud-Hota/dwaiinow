// lib/core/services/auth_service.dart

import 'package:dawai_app/core/network/api_client.dart';
import 'package:dawai_app/config/constants/api_constants.dart';
import 'package:dawai_app/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthService({
    required ApiClient apiClient,
    required FlutterSecureStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  // ── 1. تسجيل مباشر → يُرجع UserModel + يحفظ التوكن ──────────────────────
  Future<UserModel> register({
    required String name,
    required String phone,
    required String password,
    String? profileImage,
    String method = 'sms',
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.registerEndpoint,
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          if (profileImage != null) 'profileImage': profileImage,
        },
      );
      final data = response.data as Map<String, dynamic>;

      await _storage.write(
        key: ApiConstants.accessTokenKey,
        value: data['access_token'].toString(),
      );
      await _storage.write(
        key: ApiConstants.tokenIssuedAtKey,
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 2. تسجيل دخول بكلمة مرور ──────────────────────────────────────────────
  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loginEndpoint,
        data: {'phone': phone, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;

      await _storage.write(
        key: ApiConstants.accessTokenKey,
        value: data['access_token'].toString(),
      );
      await _storage.write(
        key: ApiConstants.refreshTokenKey,
        value: data['refresh_token'].toString(),
      );
      await _storage.write(
        key: ApiConstants.tokenIssuedAtKey,
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 3. إرسال OTP ───────────────────────────────────────────────────────────
  Future<void> sendOtp({required String phone, String method = 'sms'}) async {
    try {
      await _apiClient.post(
        ApiConstants.sendOtpEndpoint,
        data: {'phone': phone, 'method': method},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 4. التحقق من OTP → يُرجع UserModel ────────────────────────────────────
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyOtpEndpoint,
        data: {'phone': phone, 'otp': otp},
      );

      final data = response.data as Map<String, dynamic>;
      await _storage.write(
        key: ApiConstants.accessTokenKey,
        value: data['access_token'].toString(),
      );
      await _storage.write(
        key: ApiConstants.refreshTokenKey,
        value: data['refresh_token'].toString(),
      );
      await _storage.write(
        key: ApiConstants.tokenIssuedAtKey,
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 5. نسيت كلمة المرور → إرسال OTP ──────────────────────────────────────
  Future<void> forgotPassword(String phone) async {
    try {
      await _apiClient.post(
        ApiConstants.forgotPasswordEndpoint,
        data: {'phone': phone},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 6. إعادة تعيين كلمة المرور ────────────────────────────────────────────
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiConstants.resetPasswordEndpoint,
        data: {'phone': phone, 'otp': otp, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 7. بيانات المستخدم الحالي ──────────────────────────────────────────────
  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get(ApiConstants.getMeEndpoint);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // ── 8. تسجيل خروج (محلي فقط) ──────────────────────────────────────────────
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // ── Error Handler ───────────────────────────────────────────────────────────
  String _handleDioError(DioException e) {
    final serverMsg = e.response?.data is Map
        ? e.response?.data['message']?.toString()
        : null;
    if (serverMsg != null) return serverMsg;

    switch (e.response?.statusCode) {
      case 400:
        return 'بيانات غير صحيحة';
      case 401:
        return 'كلمة المرور غير صحيحة أو رمز التحقق منتهي';
      case 404:
        return 'لا يوجد حساب بهذا الرقم';
      case 409:
        return 'رقم الهاتف مسجّل مسبقاً';
      case 429:
        return 'محاولات كثيرة، يرجى الانتظار';
      case 500:
        return 'خطأ في الخادم، حاول لاحقاً';
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return 'انتهت مهلة الاتصال، تحقق من الإنترنت';
        }
        if (e.type == DioExceptionType.connectionError) {
          return 'لا يوجد اتصال بالإنترنت';
        }
        return 'تعذر الاتصال بالخادم';
    }
  }
}
