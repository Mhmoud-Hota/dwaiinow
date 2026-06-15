//lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:dawai_app/core/services/auth_service.dart';
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dawai_app/features/auth/data/models/user_model.dart';
import 'package:dawai_app/core/services/storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final StorageService _storageService;

  AuthRepositoryImpl({
    required AuthService authService,
    required StorageService storageService,
  })  : _authService = authService,
        _storageService = storageService;

  @override
  Future<UserEntity> login(String phoneNumber, String password) async {
    final user = await _authService.loginWithPhoneAndPassword(
      phoneNumber: phoneNumber,
      password: password,
    );
    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,
  }) async {
    final user = await _authService.registerWithPhoneAndPassword(
      name: name,
      phoneNumber: phoneNumber,
      password: password,
      address: address,
      profileImageUrl: profileImageUrl,
    );
    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? address,
    String? profileImageUrl,
  }) async {
    await _authService.updateUserProfile(
      userId: userId,
      name: name,
      address: address,
      profileImageUrl: profileImageUrl,
    );

    final currentUser = await _storageService.getUser();
    if (currentUser != null) {
      await _storageService.saveUser(UserModel(
        id: currentUser.id,
        name: name ?? currentUser.name,
        phoneNumber: currentUser.phoneNumber,
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
        address: address ?? currentUser.address,
        createdAt: currentUser.createdAt,
      ));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    // من التخزين المحلي مباشرة (سريع)
    return _storageService.getUserSync();
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
    await _storageService.clearUser();
  }
}