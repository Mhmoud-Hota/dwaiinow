// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dawai_app/core/services/auth_service.dart';
import 'package:dawai_app/core/services/storage_service.dart';
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService    _authService;
  final StorageService _storageService;

  AuthRepositoryImpl({
    required AuthService    authService,
    required StorageService storageService,
  })  : _authService    = authService,
        _storageService = storageService;

  @override
  Future<UserEntity> register({
    required String name,
    required String phone,
    required String password,
    String? profileImage,
    String method = 'sms',
  }) async {
    final user = await _authService.register(
      name: name, phone: phone, password: password,
      profileImage: profileImage,
    );
    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<UserEntity> login({required String phone, required String password}) async {
    final user = await _authService.login(phone: phone, password: password);
    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<void> sendOtp({required String phone, String method = 'sms'}) async {
    await _authService.sendOtp(phone: phone, method: method);
  }

  @override
  Future<UserEntity> verifyOtp({required String phone, required String otp}) async {
    final user = await _authService.verifyOtp(phone: phone, otp: otp);
    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<void> forgotPassword(String phone) async {
    await _authService.forgotPassword(phone);
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await _authService.resetPassword(phone: phone, otp: otp, newPassword: newPassword);
  }

  @override
  Future<UserEntity> refreshMe() async {
    final user = await _authService.getMe();
    await _storageService.saveUser(user);
    return user;
  }

  @override
  UserEntity? getCurrentUser() => _storageService.getUserSync();

  @override
  Future<void> logout() async {
    await _authService.logout();
    await _storageService.clearUser();
  }
}