// //lib/features/welcome/presentation/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Positioned(
              top: 100.h,
              left: -20.w,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.show_chart, size: 200.sp, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 100.h,
              right: -20.w,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.medication, size: 250.sp, color: Colors.white),
              ),
            ),
            
            // Main Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    
                    // Logo Container
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Icon(
                        Icons.medication_liquid_sharp,
                        size: 80.sp,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Title
                    Text(
                      'دوائي الآن',
                      style: GoogleFonts.cairo(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Subtitle
                    Text(
                      'رفيقك الذكي للوصول إلى الدواء في أقرب صيدلية، بكل سهولة ودقة.',
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const Spacer(flex: 3),
                    
                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                color: AppColors.buttonTextColor,
                              ),
                            ),
                          ],
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
    );
  }
}