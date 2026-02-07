//lib/features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? address;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    this.address,
    required this.createdAt,
  });
}