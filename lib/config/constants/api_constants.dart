// lib/core/constants/api_constants.dart

import 'package:dawai_app/config/constants/storage_keys.dart';

enum Environment { dev, staging, prod }

class ApiConstants {
  // ================= ENVIRONMENT =================

  static const String _envString = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static Environment get environment {
    switch (_envString) {
      case 'prod':
        return Environment.prod;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.dev;
    }
  }

  // ================= API VERSION =================

  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );


  // ================= BASE DOMAINS =================

  static String get _baseDomain {
    switch (environment) {
      case Environment.prod:
        return 'https://successive-amandy-tech-code-3beec46e.koyeb.app';
      case Environment.staging:
        return 'https://successive-amandy-tech-code-3beec46e.koyeb.app';
      case Environment.dev:
        return 'https://successive-amandy-tech-code-3beec46e.koyeb.app';
    }
  }

  //اختلاف في نقطه النهايخ بالنسبه للتحديث التوكن فقط
  // لانو الباك اند بستخدم الريفريش توكن بدون الاصدار
  static String get refUrl => '$_baseDomain/api';
  static String get domain => _baseDomain;
  static String get baseUrl => '$_baseDomain/api/$apiVersion';
  // ================= AUTH ENDPOINTS =================
  static const String loginEndpoint = '/auth/login/';
  static const String registerEndpoint = '/auth/register/';
  static const String refreshTokenEndpoint = '/token/refresh/';
  static const String logoutEndpoint = '/auth/logout/';
  static const String resetPasswordEndpoint = '/auth/reset-password/';
  // (داخل كلاس ApiConstants)


  // ================= USER ENDPOINTS =================
  static const String userEndpoint = '/user/';
  static const String updateProfileEndpoint = '/user/profile/';
  static const String changePasswordEndpoint = '/user/change-password/';

  // ================= STORAGE KEYS =================
  static const accessTokenKey = StorageKeys.accessToken;
  static const refreshTokenKey = StorageKeys.refreshToken;
  static const tokenIssuedAtKey = StorageKeys.tokenIssuedAt;

  // ================= TOKEN =================
  static const int tokenLifetimeMinutes = int.fromEnvironment(
    'TOKEN_LIFETIME',
    defaultValue: 5,
  );


}