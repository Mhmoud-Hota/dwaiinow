// lib/features/auth/domain/usecases/verify_otp_usecase.dart

import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

/// يتحقق من OTP ويُرجع المستخدم مع حفظ التوكن
/// يُستخدم لكلٍّ من: إتمام التسجيل + تسجيل الدخول
class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<UserEntity> call({
    required String phone,
    required String otp,
  }) async {
    return _repository.verifyOtp(phone: phone, otp: otp);
  }
}