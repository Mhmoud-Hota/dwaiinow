// lib/features/auth/domain/repositories/auth_repository.dart

import '../entities/user_entity.dart';

abstract class AuthRepository {

  // ── تسجيل جديد → يُرجع UserEntity مباشرة (بدون OTP مؤقتاً) ───────────────
  Future<UserEntity> register({
    required String name,
    required String phone,
    required String password,
    String? profileImage,
    String method = 'sms',
  });

  // ── تسجيل دخول بكلمة مرور ─────────────────────────────────────────────────
  Future<UserEntity> login({
    required String phone,
    required String password,
  });

  // ── إرسال OTP ──────────────────────────────────────────────────────────────
  Future<void> sendOtp({required String phone, String method = 'sms'});

  // ── التحقق من OTP (بعد التسجيل) ───────────────────────────────────────────
  Future<UserEntity> verifyOtp({required String phone, required String otp});

  // ── نسيت كلمة المرور → إرسال OTP ─────────────────────────────────────────
  Future<void> forgotPassword(String phone);

  // ── إعادة تعيين كلمة المرور ───────────────────────────────────────────────
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  });

  // ── بيانات المستخدم من السيرفر ────────────────────────────────────────────
  Future<UserEntity> refreshMe();

  // ── المستخدم الحالي من التخزين المحلي ────────────────────────────────────
  UserEntity? getCurrentUser();

  // ── تسجيل الخروج ──────────────────────────────────────────────────────────
  Future<void> logout();
}