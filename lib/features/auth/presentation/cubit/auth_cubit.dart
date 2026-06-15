//lib/features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dawai_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase _registerUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  })  : _registerUseCase = registerUseCase,
        super(AuthInitial());

  String? _validatePassword(String password) {
    if (password.trim().isEmpty) return 'يرجى إدخال كلمة المرور';
    if (password.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    // اختياري:
    // if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$').hasMatch(password)) {
    //   return 'كلمة المرور يجب أن تحتوي على حرف ورقم على الأقل';
    // }
    return null;
  }

  // Future<void> login(String phone, String password) async {
  //   if (phone.trim().isEmpty) {
  //     emit(AuthError('يرجى إدخال رقم الهاتف'));
  //     return;
  //   }
  //   final passError = _validatePassword(password);
  //   if (passError != null) {
  //     emit(AuthError(passError));
  //     return;
  //   }
  //   emit(AuthLoading());
  //   try {
  //     final user = await _loginUseCase(phone.trim(), password);
  //     emit(AuthSuccess(user));
  //   } catch (e) {
  //     emit(AuthError(e.toString().replaceAll('Exception: ', '')));
  //   }
  // }
Future<void> login(String phone, String password) async {
  if (phone.trim().isEmpty) {
    emit(AuthError('يرجى إدخال رقم الهاتف'));
    return;
  }

  final passError = _validatePassword(password);
  if (passError != null) {
    emit(AuthError(passError));
    return;
  }

  emit(AuthLoading());

  await Future.delayed(const Duration(seconds: 1));

  final user = UserEntity(
    id: '1',
    name: 'مستخدم تجريبي',
    phoneNumber: phone.trim(),
    address: 'محلي',
    profileImageUrl: null, createdAt: DateTime(DateTime.april),
  );

  emit(AuthSuccess(user));
}
  Future<void> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,
  }) async {
    if (name.trim().isEmpty || phoneNumber.trim().isEmpty) {
      emit(AuthError('يرجى إدخال البيانات المطلوبة'));
      return;
    }

    final passError = _validatePassword(password);
    if (passError != null) {
      emit(AuthError(passError));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _registerUseCase(
        name: name.trim(),
        phoneNumber: phoneNumber.trim(),
        password: password,
        address: address,
        profileImageUrl: profileImageUrl,
      );
      emit(AuthRegisterSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}