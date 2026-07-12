// lib/features/auth/domain/usecases/forgot_password_usecase.dart

import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  ForgotPasswordUseCase({required AuthRepository repository}) : _repository = repository;

  Future<void> call(String phone) async => _repository.forgotPassword(phone);
}