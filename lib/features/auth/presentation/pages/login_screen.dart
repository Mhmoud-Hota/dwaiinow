//lib/features/auth/presentation/pages/login_screen.dart
import 'package:dawai_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
        // تستخدم لتنظيف الزاكره عند اغلاق الصفحه 
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              // الأيقونة العلوية (المستخدم)
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(Icons.person_outline,
                    size: 40.sp, color: const Color(0xFF006D5B)),
              ),

              SizedBox(height: 32.h),

              // العنوان
              Text(
                'تسجيل الدخول',
                style: GoogleFonts.cairo(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A237E)),
              ),

              SizedBox(height: 8.h),

              // النص الفرعي
              Text(
                'أدخل بياناتك للمتابعة',
                style:
                    GoogleFonts.cairo(fontSize: 16.sp, color: Colors.grey[600]),
              ),

              SizedBox(height: 48.h),

              // حقل رقم الهاتف
              AppTextField(
                controller: _phoneController,
                hint: 'رقم الهاتف',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20.h),

              // حقل كلمة المرور
              AppTextField(
                controller: _passwordController,
                hint: 'كلمة المرور',
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: 40.h),

              // زر الدخول المرتبط بـ Cubit
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('تم تسجيل الدخول بنجاح'),
                          backgroundColor: Colors.green),
                    );
                    // التنقل إلى الشاشة الرئيسية باستخدام GoRouter
                    context.go('/home');
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () => context.read<AuthCubit>().login(
                              _phoneController.text, _passwordController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006D5B),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('دخول',
                              style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              // نسيت كلمة المرور
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // انتقل لشاشة استعادة كلمة المرور
                    context.push('/forgot-password');
                  },
                  child: Text(
                    'نسيت كلمة المرور؟',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: const Color(0xFF006D5B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // إنشاء حساب جديد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // الانتقال إلى شاشة التسجيل
                      context.push('/register');
                    },
                    child: Text(
                      'إنشاء حساب جديد',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        color: const Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
