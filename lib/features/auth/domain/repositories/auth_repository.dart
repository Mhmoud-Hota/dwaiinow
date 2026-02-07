//lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String phoneNumber, String password);
  Future<UserEntity> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,
  });
  Future<void> logout();
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? address,
    String? profileImageUrl,
  });
  UserEntity? getCurrentUser();
}