// lib/features/auth/domain/usecases/register_usecase.dart

import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase({required AuthRepository repository}) : _repository = repository;

  Future<UserEntity> call({
    required String name,
    required String phone,
    required String password,
    String? profileImage,
    String method = 'sms',
  }) async {
    return _repository.register(
      name: name,
      phone: phone,
      password: password,
      profileImage: profileImage,
      method: method,
    );
  }
}