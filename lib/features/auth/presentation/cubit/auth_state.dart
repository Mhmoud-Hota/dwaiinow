// lib/features/auth/presentation/cubit/auth_state.dart

part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial      extends AuthState {}
class AuthLoading      extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}

class AuthOtpRequired extends AuthState {
  final String phone;
  final bool   isLogin;
  final bool   isReset; // true = نسيت كلمة المرور
  AuthOtpRequired({
    required this.phone,
    this.isLogin = false,
    this.isReset = false,
  });
}

class AuthOtpResent extends AuthState {
  final String phone;
  AuthOtpResent({required this.phone});
}

class AuthPasswordReset extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}