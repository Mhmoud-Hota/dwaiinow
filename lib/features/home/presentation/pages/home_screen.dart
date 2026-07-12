// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _pickingImage = false;

  final List<String> keywords = [
    'مسكنات',
    'فيتامينات',
    'مضادات',
    'برد',
    'ضغط',
    'سكر',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── التقاط صورة من الكاميرا أو المعرض ─────────────────────────────────────
  Future<void> _capturePrescription({bool fromGallery = false}) async {
    if (_pickingImage) return;
    setState(() => _pickingImage = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image == null || !mounted) return;

      context.push('/pharmacies', extra: {
        'searchQuery': 'بحث بالصورة',
        'searchType': 'image',
        'imagePath': image.path,
      });
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }

  // ─── حوار اختيار مصدر الصورة ──────────────────────────────────────────────
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اختر مصدر الصورة',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF0E8F84)),
                title: Text('الكاميرا', style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  _capturePrescription(fromGallery: false);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF0E8F84)),
                title: Text('معرض الصور', style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  _capturePrescription(fromGallery: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGradientStart,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'الرئيسية',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildSearchByName(context),
            SizedBox(height: 20.h),
            _buildSearchByImage(context),
            SizedBox(height: 24.h),
            _buildKeywords(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'ابحث عن دوائك',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'نبحث لك في جميع الصيدليات دفعة واحدة',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }

  Widget _buildSearchByName(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                textInputAction: TextInputAction.search,
                onSubmitted: (v) {
                  if (v.trim().length >= 2) {
                    context.push('/pharmacies', extra: {
                      'searchQuery': v.trim(),
                      'searchType': 'name',
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'flutab, paracetamol, باراسيتامول...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    final q = _searchController.text.trim();
                    if (q.length < 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'يرجى إدخال حرفين على الأقل',
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                      );
                      return;
                    }
                    context.push('/pharmacies', extra: {
                      'searchQuery': q,
                      'searchType': 'name',
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundGradientStart,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'بحث',
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchByImage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: InkWell(
        onTap: _pickingImage ? null : _showImageSourceDialog,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.backgroundGradientStart,
                AppColors.backgroundGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              _pickingImage
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.camera_alt, color: Colors.white, size: 40),
              SizedBox(height: 12.h),
              Text(
                'تصوير الروشتة أو الدواء',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'صوّر الروشتة أو علبة الدواء وسنستخرج الاسم تلقائياً',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
color: Colors.white.withValues(alpha: 0.9),                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeywords(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'الأكثر طلباً',
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E8F84).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.medication,
                  size: 18.sp,
                  color: const Color(0xFF0E8F84),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 50.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: keywords.length,
                itemBuilder: (context, index) {
                  final keyword = keywords[index];
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 10.w),
                    child: InkWell(
                      onTap: () => context.push('/pharmacies', extra: {
                        'searchQuery': keyword,
                        'searchType': 'keyword',
                      }),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              keyword,
                              style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.medication_outlined,
                              size: 18.sp,
                              color: const Color(0xFF0E8F84),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
