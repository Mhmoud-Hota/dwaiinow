// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase({required AuthRepository repository}) : _repository = repository;

  Future<UserEntity> call({required String phone, required String password}) async {
    return _repository.login(phone: phone, password: password);
  }
}