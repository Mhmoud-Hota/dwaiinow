//lib/features/auth/presentation/cubit/auth_cubit.dart
import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dawai_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/register_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        super(AuthInitial());

  // تسجيل الدخول برقم الهاتف وكلمة المرور
  Future<void> login(String phone, String password) async {
    if (phone.isEmpty || password.isEmpty) {
      emit(AuthError('يرجى إدخال رقم الهاتف وكلمة المرور'));
      return;
    }
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(phone, password);
      emit(AuthSuccess(user)); // تأكد من استخدام الحالة الصحيحة المتوقعة في UI
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // إنشاء حساب جديد
  Future<void> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl, // غير الاسم هنا فقط
  }) async {
    // التحقق من صحة البيانات
    if (name.isEmpty || phoneNumber.isEmpty || password.isEmpty) {
      emit(AuthError('يرجى إدخال البيانات المطلوبة'));
      return;
    }

    emit(AuthLoading());

    try {
      final user = await _registerUseCase(
        name: name,
        phoneNumber: phoneNumber,
        password: password,
        address: address,
        profileImageUrl: profileImageUrl, // غير هنا أيضاً
      );
      emit(AuthRegisterSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // إعادة تعيين الحالة
  void resetState() {
    emit(AuthInitial());
  }

  void verifyOtp({required String verificationId, required String otpCode}) {}
}
