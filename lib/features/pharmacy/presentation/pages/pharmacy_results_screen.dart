// lib/features/pharmacy/presentation/pharmacy_results_screen.dart
import 'dart:io';
import 'package:dawai_app/features/pharmacy/data/models/pharmacy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:dawai_app/core/di/service_locator.dart';
import '../cubit/pharmacy_cubit.dart';

class PharmacyResultsScreen extends StatelessWidget {
  final String searchQuery;
  final String searchType; // 'name' | 'image' | 'keyword'
  final String? imagePath;

  const PharmacyResultsScreen({
    super.key,
    required this.searchQuery,
    required this.searchType,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<PharmacyCubit>();

        // شغّل البحث المناسب بعد أول frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (searchType == 'image' && imagePath != null) {
            cubit.searchByImage(imageFile: File(imagePath!));
          } else {
            cubit.loadPharmacies(searchQuery: searchQuery);
          }
        });

        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF333333)),
            onPressed: () => context.go('/home'),
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
              return _buildLoading();
            }

            if (state is PharmacyImageExtracted) {
              return _buildImageExtracted(state);
            }

            if (state is PharmacyLoaded) {
              return _buildLoaded(context, state);
            }

            if (state is PharmacyEmpty) {
              return _buildEmpty(state.query);
            }

            if (state is PharmacyError) {
              return _buildError(context, state.message);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ── شاشات الحالات ──────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Color(0xFF0E8F84)),
          SizedBox(height: 16.h),
          Text(
            searchType == 'image' ? 'جاري تحليل الصورة...' : 'جاري البحث...',
            style: GoogleFonts.cairo(
                fontSize: 16.sp, color: const Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildImageExtracted(PharmacyImageExtracted state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.medication, size: 48, color: Color(0xFF0E8F84)),
          SizedBox(height: 12.h),
          Text(
            'تم التعرف على: ${state.extractedName}',
            style:
                GoogleFonts.cairo(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'جاري البحث في المخزون...',
            style: GoogleFonts.cairo(
                fontSize: 14.sp, color: const Color(0xFF666666)),
          ),
          SizedBox(height: 16.h),
          const CircularProgressIndicator(color: Color(0xFF0E8F84)),
        ],
      ),
    );
  }

  Widget _buildEmpty(String query) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: const Color(0xFFCCCCCC)),
          SizedBox(height: 16.h),
          Text(
            'لا توجد نتائج لـ "$query"',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'لم يتم العثور على هذا الدواء في أي صيدلية',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
                fontSize: 14.sp, color: const Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red.shade300),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                  fontSize: 16.sp, color: const Color(0xFF333333)),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                final cubit = context.read<PharmacyCubit>();
                if (searchType == 'image' && imagePath != null) {
                  cubit.searchByImage(imageFile: File(imagePath!));
                } else {
                  cubit.loadPharmacies(searchQuery: searchQuery);
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E8F84),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, PharmacyLoaded state) {
    return Column(
      children: [
        // شريط معلومات الدواء المبحوث عنه
        _buildSearchBanner(state),

        // قائمة الأدوية والصيدليات
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: state.medicines.length,
            itemBuilder: (context, index) => _MedicineCard(
                medicine: state.medicines[index], cubit: context.read()),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBanner(PharmacyLoaded state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E8F84), Color(0xFF0B7A70)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Icon(
              state.isImageSearch ? Icons.camera_alt : Icons.search,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '"${state.searchedQuery}" — ${state.medicines.length} نتيجة',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── كارد الدواء ──────────────────────────────────────────────────────────────

class _MedicineCard extends StatefulWidget {
  final MedicineSearchResult medicine;
  final PharmacyCubit cubit;

  const _MedicineCard({required this.medicine, required this.cubit});

  @override
  State<_MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<_MedicineCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final med = widget.medicine;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── رأس الكارد ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0E8F84),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // عدد الصيدليات المتاحة
                  Text(
                    '${med.pharmacies.length} صيدلية',
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  // اسم الدواء
                  Flexible(
                    child: Text(
                      med.canonicalName,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── اسم علمي ────────────────────────────────────────────────────
          if (med.scientificName != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  med.scientificName!,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          // ── قائمة الصيدليات ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                // أول صيدلية دائماً ظاهرة
                if (med.pharmacies.isNotEmpty)
                  _PharmacyTile(
                    pharmacy: med.pharmacies.first,
                    cubit: widget.cubit,
                  ),

                // الباقية تُظهر عند الضغط
                if (med.pharmacies.length > 1) ...[
                  if (_expanded)
                    ...med.pharmacies.skip(1).map(
                        (p) => _PharmacyTile(pharmacy: p, cubit: widget.cubit)),
                  TextButton.icon(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF0E8F84),
                    ),
                    label: Text(
                      _expanded
                          ? 'إخفاء'
                          : 'عرض ${med.pharmacies.length - 1} صيدلية أخرى',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        color: const Color(0xFF0E8F84),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── كارد الصيدلية الواحدة ────────────────────────────────────────────────────

class _PharmacyTile extends StatelessWidget {
  final PharmacyResultModel pharmacy;
  final PharmacyCubit cubit;

  const _PharmacyTile({required this.pharmacy, required this.cubit});

  static const int _lowStockThreshold = 5;

  bool get _isLowStock => pharmacy.quantity <= _lowStockThreshold;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: _isLowStock ? const Color(0xFFFFFBF0) : const Color(0xFFF8FFFE),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              _isLowStock ? const Color(0xFFFFB300) : const Color(0xFFDDF0EE),
          width: _isLowStock ? 1.5 : 1,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── شريط التحذير (يظهر فقط عند كمية منخفضة) ──────────────────
            if (_isLowStock)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(11.r),
                    topLeft: Radius.circular(11.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 15.sp, color: Colors.white),
                    SizedBox(width: 5.w),
                    Text(
                      pharmacy.quantity == 1
                          ? 'آخر وحدة متبقية — أسرع قبل النفاد!'
                          : 'كمية محدودة — تبقى ${pharmacy.quantity} فقط!',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            // ── المحتوى الرئيسي ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم الصيدلية + المسافة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // المسافة
                      if (pharmacy.distanceText.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5F3),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.near_me_outlined,
                                  size: 13.sp, color: const Color(0xFF0E8F84)),
                              SizedBox(width: 3.w),
                              Text(
                                pharmacy.distanceText,
                                style: GoogleFonts.cairo(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0E8F84),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // اسم الصيدلية
                      Flexible(
                        child: Text(
                          pharmacy.pharmacyName,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // الكمية + السعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (pharmacy.price != null)
                        Text(
                          '${pharmacy.price!.toStringAsFixed(0)} جنيه',
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            color: const Color(0xFF0E8F84),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isLowStock) ...[
                            Icon(Icons.inventory_2_outlined,
                                size: 13.sp, color: const Color(0xFFE65100)),
                            SizedBox(width: 3.w),
                          ],
                          Text(
                            'الكمية: ${pharmacy.quantity}',
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              color: _isLowStock
                                  ? const Color(0xFFE65100)
                                  : const Color(0xFF555555),
                              fontWeight: _isLowStock
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // أزرار الاتصال والموقع
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => cubit.openLocation(
                            pharmacy.latitude,
                            pharmacy.longitude,
                            pharmacy.pharmacyName,
                          ),
                          icon: Icon(Icons.map_outlined,
                              size: 16.sp, color: const Color(0xFF0E8F84)),
                          label: Text('الموقع',
                              style: GoogleFonts.cairo(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF0E8F84))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0E8F84)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: pharmacy.hasPhone
                              ? () => cubit.callPharmacy(pharmacy.phone!)
                              : null,
                          icon: Icon(Icons.phone, size: 16.sp),
                          label: Text('اتصال',
                              style: GoogleFonts.cairo(fontSize: 13.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E8F84),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
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
      ),
    );
  }
}
