//lib/features/auth/presentation/cubit/auth_state.dart
part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final UserEntity user;
  AuthLoginSuccess(this.user);
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}

class AuthRegisterSuccess extends AuthState {
  final UserEntity user;
  AuthRegisterSuccess(this.user);
}

class AuthOtpRequired extends AuthState {
  final String verificationId;
  final String phoneNumber;
  
  AuthOtpRequired({
    required this.verificationId,
    required this.phoneNumber,
  });
}

class AuthOtpVerified extends AuthState {
  final UserEntity user;
  AuthOtpVerified(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}