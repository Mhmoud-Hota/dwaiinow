// lib/config/constants/api_constants.dart

import 'package:dawai_app/config/constants/storage_keys.dart';

enum Environment { dev, staging, prod }

class ApiConstants {
  ApiConstants._();

  static const String _envString = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static Environment get environment => switch (_envString) {
        'prod' => Environment.prod,
        'staging' => Environment.staging,
        _ => Environment.dev,
      };
//متغيرات البيئه وتحديد بيئه الانتاج
  static String get _baseDomain => switch (environment) {
        Environment.prod => 'https://pharmacy-hub.onrender.com/',
        Environment.staging => 'https://pharmacy-hub.onrender.com/',
        Environment.dev => 'https://pharmacy-hub.onrender.com/',
      };

  static String get domain => _baseDomain;
  static String get baseUrl => _baseDomain;
  // ⚠️ NestJS لا يملك refresh endpoint — refUrl غير مستخدم
  static String get refUrl => _baseDomain;

  static const contentTypeJson = 'application/json';

  // Storage Keys
  static const accessTokenKey = StorageKeys.accessToken;
  static const refreshTokenKey = StorageKeys.refreshToken; 
  static const tokenIssuedAtKey = StorageKeys.tokenIssuedAt;

  // =========================================================================
  // AUTH — كل التدفق يمر عبر OTP، لا يوجد login بكلمة مرور
  // =========================================================================

  /// POST { name, phone, method? }
  /// → { success, message, user_id }
  static const registerEndpoint = '/auth/register';
  static const loginEndpoint = '/auth/login';
  static const forgotPasswordEndpoint = '/auth/forgot-password';
  static const resetPasswordEndpoint = '/auth/reset-password';
  static const updateProfileEndpoint = '/auth/profile';

  /// POST { phone, method? }
  /// → { success, message }
  static const sendOtpEndpoint = '/auth/send-otp';

  /// POST { phone, otp }
  /// → { success, access_token, token_type, user: {id,name,phone,is_verified} }
  static const verifyOtpEndpoint = '/auth/verify-otp';

  /// GET — Bearer token مطلوب
  /// → { id, name, phone, is_verified, created_at }
  static const getMeEndpoint = '/auth/me';


  // =========================================================================
  // INVENTORY
  // =========================================================================
  static const inventorySearch = '/inventory/search';
  static const inventorySummary = '/inventory/summary';
  static const inventoryLowStock = '/inventory/low-stock';
  static const inventoryFind = '/inventory/find';

  static String inventoryByPharmacy(String slug) => '/inventory/pharmacy/$slug';

  // =========================================================================
  // PHARMACIES
  // =========================================================================
  static const pharmaciesList = '/pharmacies';

  static String pharmacyWebhookLogs(String slug) =>
      '/pharmacies/$slug/webhook-logs';

  // =========================================================================
  // WEBHOOKS  (من PHP → السيرفر)
  // =========================================================================
  static String webhookEndpoint(String slug) => '/webhooks/$slug';
}

class ApiHeaders {
  static const authorization = 'Authorization';
  static const contentType = 'Content-Type';
  static const accept = 'Accept';
  static const acceptLanguage = 'Accept-Language';
}
