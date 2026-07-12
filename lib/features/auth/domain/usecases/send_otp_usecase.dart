// lib/features/auth/domain/usecases/send_otp_usecase.dart

import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

/// يُرسل OTP لمستخدم موجود (بداية تسجيل الدخول)
class SendOtpUseCase {
  final AuthRepository _repository;

  SendOtpUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<void> call({
    required String phone,
    String method = 'sms',
  }) async {
    return _repository.sendOtp(phone: phone, method: method);
  }
}