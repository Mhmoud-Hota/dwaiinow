// lib/features/auth/presentation/cubit/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dawai_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/core/widgets/app_loader.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(AuthInitial());

  // ── تسجيل جديد ────────────────────────────────────────────────────────────
  Future<void> register({
    required String name,
    required String phone,
    required String password,
    String? profileImage,
  }) async {
    if (name.trim().isEmpty ||
        phone.trim().isEmpty ||
        password.trim().isEmpty) {
      emit(AuthError('يرجى إدخال جميع البيانات المطلوبة'));
      return;
    }
    AppLoader.show(message: 'جاري إنشاء الحساب...');

    emit(AuthLoading());
    try {
      final user = await _registerUseCase(
        name: name.trim(),
        phone: phone.trim(),
        password: password,
        profileImage: profileImage,
      );
      // تسجيل مباشر بدون OTP → انتقل للرئيسية فوراً
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    } finally {
      AppLoader.hide();
    }
  }

  // ── تسجيل دخول بكلمة مرور ─────────────────────────────────────────────────
  Future<void> login({required String phone, required String password}) async {
    if (phone.trim().isEmpty || password.trim().isEmpty) {
      emit(AuthError('يرجى إدخال رقم الهاتف وكلمة المرور'));
      return;
    }
    AppLoader.show(message: 'جاري تسجيل الدخول...');

    emit(AuthLoading());
    try {
      final user = await _loginUseCase(phone: phone.trim(), password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    } finally {
      AppLoader.hide();
    }
  }

  // ── التحقق من OTP (بعد التسجيل) ───────────────────────────────────────────
  Future<void> verifyOtp({required String phone, required String otp}) async {
    if (otp.trim().length != 6) {
      emit(AuthError('يرجى إدخال الرمز المكون من 6 أرقام'));
      return;
    }
    AppLoader.show(message: 'جاري التحقق...');

    emit(AuthLoading());
    try {
      final user = await _verifyOtpUseCase(phone: phone, otp: otp.trim());
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    } finally {
      AppLoader.hide();
    }
  }

  // ── إعادة إرسال OTP ────────────────────────────────────────────────────────
  Future<void> resendOtp(String phone) async {
    AppLoader.show(message: 'جاري إرسال الرمز...');

    emit(AuthLoading());
    try {
      await _sendOtpUseCase(phone: phone);
      emit(AuthOtpResent(phone: phone));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    } finally {
      AppLoader.hide();
    }
  }

  // ── نسيت كلمة المرور → إرسال OTP ─────────────────────────────────────────
  Future<void> forgotPassword(String phone) async {
    if (phone.trim().isEmpty) {
      emit(AuthError('يرجى إدخال رقم الهاتف'));
      return;
    }
    AppLoader.show(message: 'جاري الإرسال...');

    emit(AuthLoading());
    try {
      await _forgotPasswordUseCase(phone.trim());
      emit(AuthOtpRequired(phone: phone.trim(), isLogin: false, isReset: true));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    } finally {
      AppLoader.hide();
    }
  }

  // ── إعادة تعيين كلمة المرور ───────────────────────────────────────────────
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    AppLoader.show(message: 'جاري تحديث كلمة المرور...');

    emit(AuthLoading());
    try {
      await _resetPasswordUseCase(
          phone: phone, otp: otp, newPassword: newPassword);
      emit(AuthPasswordReset());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    } finally {
      AppLoader.hide();
    }
  }

  // ── تسجيل الخروج ──────────────────────────────────────────────────────────
  Future<void> logout() async {
    AppLoader.show(message: 'جاري تسجيل الخروج...');
    try {
      await _logoutUseCase();
      emit(AuthInitial());
    } finally {
      AppLoader.hide();
    }
  }

  // ── التحقق من جلسة محفوظة ─────────────────────────────────────────────────
   void checkCurrentUser() {
    final user = _getCurrentUserUseCase();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthInitial());
    }
  }
}
