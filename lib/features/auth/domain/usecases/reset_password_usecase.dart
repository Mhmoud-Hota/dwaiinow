// lib/features/auth/domain/usecases/reset_password_usecase.dart

import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;
  ResetPasswordUseCase({required AuthRepository repository}) : _repository = repository;

  Future<void> call({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    return _repository.resetPassword(phone: phone, otp: otp, newPassword: newPassword);
  }
}