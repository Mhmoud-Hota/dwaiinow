// lib/config/constants/auth_constants.dart

class AuthConstants {
  AuthConstants._();

  // ⚠️ NestJS لا يملك refresh endpoint
  // الجلسة تنتهي عند انتهاء الـ JWT → يُعاد إرسال OTP
  static const refreshTokenEndpoint = ''; // غير مستخدم

  // مدة الـ JWT — اضبطها لتطابق JWT_EXPIRES_IN في .env على NestJS
  static const tokenLifetimeMinutes = 60 * 24 * 7; // 7 أيام (افتراضي)

  // كم ثانية قبل الانتهاء نجدد؟ — غير فعّال بدون refresh endpoint
  static const refreshBeforeExpirySeconds = 300; // 5 دقائق

  // Endpoints لا تحتاج Bearer token
  static const authFreeEndpoints = [
  '/auth/register',
  '/auth/login',          // ← جديد
  '/auth/send-otp',
  '/auth/verify-otp',
  '/auth/forgot-password', // ← جديد
  '/auth/reset-password',  // ← جديد
  '/inventory',
  '/pharmacies',
  '/webhooks',
];
}