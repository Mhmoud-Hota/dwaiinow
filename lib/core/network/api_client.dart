// lib/core/network/api_client.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dawai_app/core/errors/exceptions.dart';
import '../../config/constants/constants.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  late final Dio _refreshDio;

  final _logoutController = StreamController<void>.broadcast();
  Stream<void> get onLogoutRequired => _logoutController.stream;

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshWaiters = [];

  ApiClient(this._dio, this._storage) {
    _init();
  }

  void _init() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: AppConstants.connectTimeoutMs,
      ),
      receiveTimeout: const Duration(
        milliseconds: AppConstants.receiveTimeoutMs,
      ),
      headers: {
        ApiHeaders.contentType: ApiConstants.contentTypeJson,
        ApiHeaders.accept: ApiConstants.contentTypeJson,
        ApiHeaders.acceptLanguage: AppConstants.defaultLanguage,
      },
      validateStatus: (status) => true,
    );

    _refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.refUrl,
        headers: {
          ApiHeaders.contentType: ApiConstants.contentTypeJson,
          ApiHeaders.accept: ApiConstants.contentTypeJson,
        },
        validateStatus: (status) => true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isAuthFreeEndpoint = _isAuthFreeEndpoint(options);
          debugPrint('➡️ REQUEST: ${options.method} ${options.uri}');

          if (!isAuthFreeEndpoint) {
            debugPrint('🔐 Auth required → checking token expiry');

            // ✅ لو قريب ينتهي، جرّب refresh قبل ما نرسل الطلب
            await _preemptiveTokenRefresh();

            final token = await _storage.read(key: ApiConstants.accessTokenKey);
            if (token != null && token.isNotEmpty) {
              debugPrint('✅ Access token attached');
              options.headers[ApiHeaders.authorization] = 'Bearer $token';
            } else {
              debugPrint('⚠️ No access token found');
            }
          } else {
            debugPrint('🆓 Auth-free endpoint');
          }

          handler.next(options);
        },

        // ✅ خليه يمرر الاستجابات حتى لو 401/400... ونعالجها في onError
        onResponse: (response, handler) {
          final code = response.statusCode ?? 0;
          if (code >= 200 && code < 300) {
            return handler.next(response);
          }

          // ✅ حوّل أي non-2xx إلى DioException حتى يدخل onError
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            ),
          );
        },

        onError: (DioException error, handler) async {
          final res = error.response;
          final status = res?.statusCode;
          final opts = error.requestOptions;

          // ✅ لا نحاول refresh على endpoints الخاصة بالـ auth
          final isAuthFreeEndpoint = _isAuthFreeEndpoint(opts);

          // ✅ Network down
          if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            return handler.reject(
              DioException(
                requestOptions: opts,
                type: DioExceptionType.unknown,
                error: NetworkException('لا يوجد اتصال بالإنترنت', message: ''),
                response: res,
              ),
            );
          }

          // ✅ 401 => جرّب refresh مرة واحدة فقط لنفس الطلب
          final alreadyRetried = opts.extra['retried'] == true;

          if (!isAuthFreeEndpoint && status == 401 && !alreadyRetried) {
            opts.extra['retried'] = true;

            final success = await _refreshToken();
            if (success) {
              final newToken = await _storage.read(
                key: ApiConstants.accessTokenKey,
              );

              if (newToken != null && newToken.isNotEmpty) {
                opts.headers[ApiHeaders.authorization] = 'Bearer $newToken';

                try {
                  final clonedResponse = await _dio.fetch(opts);
                  return handler.resolve(clonedResponse);
                } catch (e) {
                  // لو فشل إعادة الإرسال، رجّع الخطأ الطبيعي
                  return handler.reject(
                    DioException(
                      requestOptions: opts,
                      response: res,
                      type: DioExceptionType.unknown,
                      error: e,
                    ),
                  );
                }
              }
            }

            // ❌ refresh فشل => logout + UI ينتقل للـ login
            await _storage.deleteAll();
            _logoutController.add(null);

            // لا نعرض "انتهت الجلسة" - فقط نمرر UnauthorizedException لو احتجت mapper
            return handler.reject(
              DioException(
                requestOptions: opts,
                response: res,
                type: DioExceptionType.badResponse,
                error: Exception('SESSION_EXPIRED'),
              ),
            );
          }

          // أي أخطاء أخرى
          handler.next(error);
        },
      ),
    );
  }

  bool _isAuthFreeEndpoint(RequestOptions options) {
    final p = options.path;
    final uriPath = options.uri.path;

    return AuthConstants.authFreeEndpoints.any(
      (endpoint) => p.contains(endpoint) || uriPath.contains(endpoint),
    );
  }

  Future<void> _preemptiveTokenRefresh() async {
    final issuedAtStr = await _storage.read(key: ApiConstants.tokenIssuedAtKey);
    final token = await _storage.read(key: ApiConstants.accessTokenKey);

    if (token == null || issuedAtStr == null) return;

    final issuedAt = DateTime.fromMillisecondsSinceEpoch(
      int.parse(issuedAtStr),
    );
    final expiresAt = issuedAt.add(
      const Duration(
        minutes: AuthConstants.tokenLifetimeMinutes,
      ),
    );
    final remaining = expiresAt.difference(DateTime.now());
    debugPrint('⏳ Token remaining: ${remaining.inSeconds} seconds');

    if (remaining <=
        const Duration(
          seconds: AuthConstants.refreshBeforeExpirySeconds,
        )) {
      debugPrint("referesh token ends time#$remaining");
      await _refreshToken();
    }
  }

  Future<bool> _refreshToken() async {
    // ✅ منع refresh بالتوازي
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshWaiters.add(completer);
      try {
        await completer.future;
        debugPrint("نجح الريفريش توكن");
        return true;
      } catch (_) {
        debugPrint("فشل الرفريش تتوكن");
        return false;
      }
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.read(
        key: ApiConstants.refreshTokenKey,
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _refreshDio.post(
        AuthConstants
            .refreshTokenEndpoint, // ✅ الأفضل endpoint وليس refUrl لو متاح
        data: {'refresh': refreshToken},
      );
      debugPrint("الريفريش$response");

      if (response.statusCode == 200) {
        final newAccess = response.data['access'];
        final newRefresh = response.data['refresh'];

        if (newAccess == null || newAccess.toString().isEmpty) return false;

        await _storage.write(
          key: ApiConstants.accessTokenKey,
          value: newAccess.toString(),
        );

        if (newRefresh != null && newRefresh.toString().isNotEmpty) {
          await _storage.write(
            key: ApiConstants.refreshTokenKey,
            value: newRefresh.toString(),
          );
        }

        await _storage.write(
          key: ApiConstants.tokenIssuedAtKey,
          value: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        for (final w in _refreshWaiters) {
          w.complete();
        }
        _refreshWaiters.clear();

        return true;
      }

      // 401/400 من refresh => refresh token انتهى
      for (final w in _refreshWaiters) {
        w.completeError('Refresh failed');
      }
      _refreshWaiters.clear();
      return false;
    } catch (e) {
      for (final w in _refreshWaiters) {
        w.completeError(e);
      }
      _refreshWaiters.clear();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }
  // داخل ApiClient
  Future<String?> getValidAccessToken() async {
    await _preemptiveTokenRefresh(); // يجرّب refresh لو قرب ينتهي
    return _storage.read(key: ApiConstants.accessTokenKey);
  }

  // (اختياري لكن مفيد للـ WS لو السيرفر قفل بسبب توكن)
  Future<String?> forceRefreshAndGetToken() async {
    final ok = await _refreshToken();
    if (!ok) return null;
    return _storage.read(key: ApiConstants.accessTokenKey);
  }

  // ================= HTTP Helpers =================
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);

  void dispose() {
    _logoutController.close();
  }
}
