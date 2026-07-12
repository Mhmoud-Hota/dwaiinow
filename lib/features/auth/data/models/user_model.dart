// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    super.profileImageUrl,
    super.address,
    required super.isVerified,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:             json['id'].toString(),
      name:           json['name'] ?? '',
      phoneNumber:    json['phone'] ?? '',          // NestJS يُرجع 'phone' وليس 'phone_number'
      profileImageUrl: null,                        // NestJS لا يُرجعها حالياً
      address:        null,                         // NestJS لا يُرجعها حالياً
      isVerified:     json['is_verified'] ?? false,
      createdAt:      json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id':          id,
    'name':        name,
    'phone':       phoneNumber,
    'is_verified': isVerified,
    'created_at':  createdAt.toIso8601String(),
  };
}