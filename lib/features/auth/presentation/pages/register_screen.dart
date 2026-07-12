// lib/features/auth/presentation/pages/register_screen.dart

import 'dart:io';
import 'package:dawai_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _profileImagePath;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _profileImagePath = picked.path);
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('كلمتا المرور غير متطابقتين'),
            backgroundColor: Colors.red),
      );
      return;
    }
    context.read<AuthCubit>().register(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          profileImage: _profileImagePath,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/login'),
        ),
        title: Text('إنشاء حساب جديد',
            style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333))),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/home');
          } else if (state is AuthOtpRequired) {
            // مستبعد مؤقتاً — احتياطي فقط
            context.push('/otp', extra: {
              'phone': state.phone,
              'isLogin': state.isLogin,
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ── صورة الملف الشخصي ─────────────────────────────────────
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border:
                          Border.all(color: const Color(0xFF0E8F84), width: 2),
                    ),
                    child: _profileImagePath != null
                        ? ClipOval(
                            child: Image.file(
                              File(_profileImagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 28.sp, color: Colors.grey[600]),
                              SizedBox(height: 6.h),
                              Text('إضافة صورة',
                                  style: GoogleFonts.cairo(
                                      fontSize: 11.sp,
                                      color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 28.h),

                // ── الاسم ────────────────────────────────────────────────
                AppTextField(
                  controller: _nameController,
                  hint: 'الاسم الكامل',
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'يرجى إدخال الاسم' : null,
                ),
                SizedBox(height: 16.h),

                // ── الهاتف ───────────────────────────────────────────────
                AppTextField(
                  controller: _phoneController,
                  hint: 'رقم الهاتف (مثال: +249912345678)',
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                ),
                SizedBox(height: 16.h),

                // ── كلمة المرور ──────────────────────────────────────────
                AppTextField(
                  controller: _passwordController,
                  hint: 'كلمة المرور',
                  icon: Icons.lock_outline,
                  isPassword: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF546E7A),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                    if (v.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // ── تأكيد كلمة المرور ─────────────────────────────────────
                AppTextField(
                  controller: _confirmPasswordController,
                  hint: 'تأكيد كلمة المرور',
                  icon: Icons.lock_outline,
                  isPassword: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF546E7A),
                    ),
                    onPressed: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'يرجى تأكيد كلمة المرور' : null,
                ),
                SizedBox(height: 36.h),

                // ── زر التسجيل ───────────────────────────────────────────
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E8F84),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text('إنشاء حساب',
                            style: GoogleFonts.cairo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text('لديك حساب بالفعل؟ سجل الدخول',
                      style: GoogleFonts.cairo(
                          fontSize: 14.sp, color: const Color(0xFF0E8F84))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
