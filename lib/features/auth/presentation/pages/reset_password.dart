// lib/features/auth/presentation/pages/reset_password.dart

import 'package:dawai_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _step = 1;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_step == 1) {
      context.read<AuthCubit>().forgotPassword(_phoneController.text.trim());
      return;
    }
    if (_step == 2) {
      if (_otpController.text.trim().length != 6) {
        _showError('رمز التحقق يجب أن يكون 6 أرقام');
        return;
      }
      setState(() => _step = 3);
      return;
    }
    if (_step == 3) {
      final pass = _newPasswordController.text;
      final confirm = _confirmPasswordController.text;
      if (pass.length < 6) {
        _showError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
        return;
      }
      if (pass != confirm) {
        _showError('كلمتا المرور غير متطابقتين');
        return;
      }

      context.read<AuthCubit>().resetPassword(
            phone: _phoneController.text.trim(),
            otp: _otpController.text.trim(),
            newPassword: pass,
          );
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );

  void _handleBack() {
    if (_step == 1) {
      context.pop();
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: _handleBack,
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A237E)),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpRequired && state.isReset) {
            // OTP أُرسل بنجاح → انتقل للخطوة 2
            setState(() => _step = 2);
          } else if (state is AuthPasswordReset) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تغيير كلمة المرور بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/login');
          } else if (state is AuthError) {
            _showError(state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    _step == 1
                        ? Icons.lock_reset
                        : _step == 2
                            ? Icons.verified_user_outlined
                            : Icons.lock_outline,
                    size: 40.sp,
                    color: const Color(0xFF006D5B),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  _step == 1
                      ? 'استعادة كلمة المرور'
                      : _step == 2
                          ? 'إدخال رمز التحقق'
                          : 'كلمة المرور الجديدة',
                  style: GoogleFonts.cairo(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A237E)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  _step == 1
                      ? 'أدخل رقم الهاتف لاستعادة كلمة المرور'
                      : _step == 2
                          ? 'أدخل الرمز المُرسَل إلى رقم الهاتف'
                          : 'أدخل كلمة المرور الجديدة ثم أكدها',
                  style: GoogleFonts.cairo(
                      fontSize: 16.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
                if (_step == 1)
                  AppTextField(
                    controller: _phoneController,
                    hint: 'رقم الهاتف (مثال: +249912345678)',
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                  ),
                if (_step == 2)
                  AppTextField(
                    controller: _otpController,
                    hint: 'رمز التحقق (6 أرقام)',
                    icon: Icons.password_outlined,
                    keyboardType: TextInputType.number,
                  ),
                if (_step == 3) ...[
                  AppTextField(
                    controller: _newPasswordController,
                    hint: 'كلمة المرور الجديدة',
                    icon: Icons.lock_outline,
                    isPassword: _obscureNewPassword,
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                          () => _obscureNewPassword = !_obscureNewPassword),
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF546E7A),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _confirmPasswordController,
                    hint: 'تأكيد كلمة المرور الجديدة',
                    icon: Icons.lock_outline,
                    isPassword: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF546E7A),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 40.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed:
                            state is AuthLoading ? null : _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006D5B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                          elevation: 0,
                        ),
                        child: Text(
                            _step == 1
                                ? 'إرسال'
                                : _step == 2
                                    ? 'تحقق'
                                    : 'تأكيد',
                            style: GoogleFonts.cairo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text('العودة إلى تسجيل الدخول',
                      style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          color: const Color(0xFF006D5B),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
