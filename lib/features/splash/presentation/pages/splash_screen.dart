// lib/features/splash/presentation/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/splash_cubit.dart';

/// شاشة سبلاش بسيطة تُعرض أثناء تحديد وجهة المستخدم:
/// - أول تشغيل بدون تسجيل دخول سابق ← شاشة الترحيب الاحترافية.
/// - غير ذلك ← نتخطى الترحيب مباشرة لشاشة تسجيل الدخول.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _pulse = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.85, end: 1.08)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.08, end: 0.94)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 0.94, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1),
    ]).animate(_controller);

    _controller.repeat();

    // نبدأ فحص حالة التطبيق فور رسم أول فريم.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkAppStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToWelcome) {
          context.go('/welcome');
        } else if (state is SplashNavigateToLogin) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundGradientStart,
                AppColors.backgroundGradientEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (context, child) => Transform.scale(
                        scale: _pulse.value,
                        child: child,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        child: Icon(
                          Icons.medication_liquid_sharp,
                          size: 64.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      'دوائي الآن',
                      style: GoogleFonts.cairo(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: 26.w,
                      height: 26.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
