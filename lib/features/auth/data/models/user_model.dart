//lib/features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    super.profileImageUrl,
    super.address,
    required super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      address: data['address'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
Map<String, dynamic> toMap() {
  return {
    'id': id, // أضف الـ ID هنا ليتم حفظه
    'name': name,
    'phoneNumber': phoneNumber,
    'profileImageUrl': profileImageUrl,
    'address': address,
    'createdAt': createdAt.toIso8601String(), // تحويل التاريخ لنص ISO
  };
}
}