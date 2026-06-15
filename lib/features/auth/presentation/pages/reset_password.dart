import 'package:dawai_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
      if (_phoneController.text.trim().isEmpty) {
        _showError('يرجى إدخال رقم الهاتف');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رمز التحقق'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _step = 2;
      });
      return;
    }

    if (_step == 2) {
      if (_otpController.text.trim().isEmpty) {
        _showError('يرجى إدخال رمز التحقق');
        return;
      }

      if (_otpController.text.trim().length < 4) {
        _showError('رمز التحقق غير صحيح');
        return;
      }

      setState(() {
        _step = 3;
      });
      return;
    }

    if (_step == 3) {
      final password = _newPasswordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password.isEmpty || confirmPassword.isEmpty) {
        _showError('يرجى إدخال كلمة المرور الجديدة وتأكيدها');
        return;
      }

      if (password.length < 6) {
        _showError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
        return;
      }

      if (password != confirmPassword) {
        _showError('كلمتا المرور غير متطابقتين');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تغيير كلمة المرور بنجاح'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _handleBack() {
    if (_step == 1) {
      context.pop();
    } else {
      setState(() {
        _step--;
      });
    }
  }

  String _getTitle() {
    if (_step == 1) return 'استعادة كلمة المرور';
    if (_step == 2) return 'إدخال رمز التحقق';
    return 'كلمة المرور الجديدة';
  }

  String _getSubtitle() {
    if (_step == 1) return 'أدخل رقم الهاتف لاستعادة كلمة المرور';
    if (_step == 2) return 'أدخل الرمز الذي تم إرساله إلى رقم الهاتف';
    return 'أدخل كلمة المرور الجديدة ثم أكدها';
  }

  IconData _getTopIcon() {
    if (_step == 1) return Icons.lock_reset;
    if (_step == 2) return Icons.verified_user_outlined;
    return Icons.lock_outline;
  }

  String _getButtonText() {
    if (_step == 1) return 'إرسال';
    if (_step == 2) return 'تحقق';
    return 'تأكيد';
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1A237E),
          ),
        ),
      ),
      body: SafeArea(
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
                  _getTopIcon(),
                  size: 40.sp,
                  color: const Color(0xFF006D5B),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                _getTitle(),
                style: GoogleFonts.cairo(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A237E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                _getSubtitle(),
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              if (_step == 1)
                AppTextField(
                  controller: _phoneController,
                  hint: 'رقم الهاتف',
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                ),
              if (_step == 2)
                AppTextField(
                  controller: _otpController,
                  hint: 'رمز التحقق',
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
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF546E7A),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _confirmPasswordController,
                  hint: 'تأكيد كلمة المرور الجديدة',
                  icon: Icons.lock_outline,
                  isPassword: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
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
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _getButtonText(),
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'العودة إلى تسجيل الدخول',
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    color: const Color(0xFF006D5B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
