//lib/features/auth/domain/usecases/register_usecase.dart
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository}) 
      : _repository = repository;

  Future<UserEntity> call(String phoneNumber, String password) async {
    return await _repository.login(phoneNumber, password);
  }
}