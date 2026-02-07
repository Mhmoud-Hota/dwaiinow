//lib/features/auth/domain/usecases/register_usecase.dart
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase({required AuthRepository repository}) 
      : _repository = repository;

  Future<UserEntity> call({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,
  }) async {
    return await _repository.register(
      name: name,
      phoneNumber: phoneNumber,
      password: password,
      address: address,
      profileImageUrl: profileImageUrl,
    );
  }
}