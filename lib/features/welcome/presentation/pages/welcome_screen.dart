// lib/features/welcome/presentation/pages/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/welcome_cubit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // أنيميشن الدخول (تظهر مرة واحدة عند فتح الشاشة)
  late final AnimationController _introController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;

  late final Animation<double> _subtitleOpacity;
  late final Animation<Offset> _subtitleOffset;

  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonOffset;

  // أنيميشن مستمر للزخارف الخلفية
  late final AnimationController _decorController;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );

    _titleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
    );
    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
    ));

    _subtitleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
    );
    _subtitleOffset = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
    ));

    _buttonOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );
    _buttonOffset = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
    ));

    _decorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _decorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeCubit, WelcomeState>(
      listener: (context, state) {
        if (state is WelcomeNavigateToLogin) {
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
          child: Stack(
            children: [
              // زخرفة متحركة أعلى اليسار
              AnimatedBuilder(
                animation: _decorController,
                builder: (context, child) {
                  final angle = _decorController.value * 2 * 3.14159;
                  return Positioned(
                    top: 100.h,
                    left: -20.w,
                    child: Transform.rotate(
                      angle: angle,
                      child: child!,
                    ),
                  );
                },
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.show_chart,
                      size: 200.sp, color: Colors.white),
                ),
              ),

              // زخرفة متحركة أسفل اليمين — تعويم بسيط لأعلى وأسفل
              AnimatedBuilder(
                animation: _decorController,
                builder: (context, child) {
                  final dy =
                      10 * -1 * (0.5 - (_decorController.value)).abs() + 5;
                  return Positioned(
                    bottom: 100.h + dy,
                    right: -20.w,
                    child: child!,
                  );
                },
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.medication,
                      size: 250.sp, color: Colors.white),
                ),
              ),

              // المحتوى الرئيسي
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // الشعار
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Icon(
                              Icons.medication_liquid_sharp,
                              size: 80.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // العنوان
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleOffset,
                          child: Text(
                            'دوائي الآن',
                            style: GoogleFonts.cairo(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // الوصف
                      FadeTransition(
                        opacity: _subtitleOpacity,
                        child: SlideTransition(
                          position: _subtitleOffset,
                          child: Text(
                            'رفيقك الذكي للوصول إلى الدواء في أقرب صيدلية، بكل سهولة ودقة.',
                            style: GoogleFonts.cairo(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // الزر
                      FadeTransition(
                        opacity: _buttonOpacity,
                        child: SlideTransition(
                          position: _buttonOffset,
                          child: BlocBuilder<WelcomeCubit, WelcomeState>(
                            builder: (context, state) {
                              final isLoading = state is WelcomeLoading;
                              return SizedBox(
                                width: double.infinity,
                                height: 60.h,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<WelcomeCubit>()
                                              .startNow();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        Colors.white.withValues(alpha: 0.85),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 22.w,
                                          height: 22.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.buttonTextColor,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios_new,
                                              size: 18.sp,
                                              color: AppColors.buttonTextColor,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              'ابدأ الآن',
                                              style: GoogleFonts.cairo(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.buttonTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
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
