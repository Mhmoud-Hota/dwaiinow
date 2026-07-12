// lib/features/auth/presentation/pages/otp_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isLogin;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.isLogin,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _otpCode => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    // تحقق تلقائي عند اكتمال الرمز
    if (_otpCode.length == 6) {
      context.read<AuthCubit>().verifyOtp(
            phone: widget.phone,
            otp: _otpCode,
          );
    }
    setState(() {});
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
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/home');
          } else if (state is AuthOtpResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إعادة إرسال الرمز'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            // مسح الحقول عند الخطأ
            for (final c in _controllers) {
              c.clear();
            }
            FocusScope.of(context).requestFocus(_focusNodes[0]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(Icons.phone_android,
                      size: 40.sp, color: const Color(0xFF006D5B)),
                ),
                SizedBox(height: 32.h),
                Text('تحقق من رقم الهاتف',
                    style: GoogleFonts.cairo(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E)),
                    textAlign: TextAlign.center),
                SizedBox(height: 16.h),
                Text('أدخل الرمز المكون من 6 أرقام المُرسَل إلى',
                    style: GoogleFonts.cairo(
                        fontSize: 16.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center),
                SizedBox(height: 8.h),
                Text(widget.phone,
                    style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF006D5B))),
                SizedBox(height: 48.h),

                // ── حقول OTP ─────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      6,
                      (i) => SizedBox(
                            width: 50.w,
                            height: 60.h,
                            child: TextField(
                              controller: _controllers[i],
                              focusNode: _focusNodes[i],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: GoogleFonts.cairo(
                                  fontSize: 24.sp, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF006D5B), width: 2),
                                ),
                              ),
                              onChanged: (v) => _onChanged(i, v),
                            ),
                          )),
                ),

                SizedBox(height: 40.h),

                // ── زر التحقق ────────────────────────────────────────────────
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading || _otpCode.length != 6
                            ? null
                            : () => context.read<AuthCubit>().verifyOtp(
                                  phone: widget.phone,
                                  otp: _otpCode,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006D5B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text('تحقق',
                            style: GoogleFonts.cairo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // ── إعادة إرسال ──────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('لم تستلم الرمز؟',
                        style: GoogleFonts.cairo(
                            fontSize: 14.sp, color: Colors.grey[600])),
                    TextButton(
                      onPressed: () =>
                          context.read<AuthCubit>().resendOtp(widget.phone),
                      child: Text('إعادة إرسال',
                          style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF006D5B))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
