//lib/features/pharmacy/presentation/pharmacy_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'cubit/pharmacy_cubit.dart';

class PharmacyResultsScreen extends StatelessWidget {
  const PharmacyResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PharmacyCubit()..loadPharmacies(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF333333)),
            onPressed: () {
              context.go('/home');
            },
          ),
          title: Text(
            'نتائج البحث',
            style: GoogleFonts.cairo(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<PharmacyCubit, PharmacyState>(
          builder: (context, state) {
            if (state is PharmacyLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is PharmacyLoaded) {
              return _buildContent(context, state.pharmacies);
            }
            
            if (state is PharmacyError) {
              return Center(
                child: Text(
                  state.message,
                  style: GoogleFonts.cairo(),
                ),
              );
            }
            
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Pharmacy> pharmacies) {
    return Column(
      children: [
        // العنوان
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'جميع الصيدليات',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.local_pharmacy,
                size: 22.sp,
                color: const Color(0xFF0E8F84),
              ),
            ],
          ),
        ),
        
        // قائمة الصيدليات
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: pharmacies.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final pharmacy = pharmacies[index];
              return _pharmacyCard(context, pharmacy);
            },
          ),
        ),
      ],
    );
  }

  Widget _pharmacyCard(BuildContext context, Pharmacy pharmacy) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // حالة التوفر
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF0E8F84),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'متوفر',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.check_circle,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          // معلومات الصيدلية
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // اسم الصيدلية
                Text(
                  pharmacy.name,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // المسافة
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'يُبعد ${pharmacy.distance} كم',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: const Color(0xFF0E8F84),
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                // الأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // زر الاتصال
                    InkWell(
                      onTap: () => context.read<PharmacyCubit>().callPharmacy(pharmacy),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E8F84),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'اتصال',
                              style: GoogleFonts.cairo(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.phone,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    // زر الموقع
                    InkWell(
                      onTap: () => context.read<PharmacyCubit>().openLocation(pharmacy),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFF0E8F84),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'الموقع',
                              style: GoogleFonts.cairo(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0E8F84),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.location_pin,
                              size: 16.sp,
                              color: const Color(0xFF0E8F84),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}