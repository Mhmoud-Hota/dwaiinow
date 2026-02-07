// //lib/features/home/presentation/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../core/theme/app_colors.dart';
// import 'cubit/home_cubit.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final TextEditingController _searchController = TextEditingController();

//   final List<String> keywords = [
//     'مسكنات',
//     'فيتامينات',
//     'مضادات',
//     'برد',
//     'ضغط',
//     'سكر',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<HomeCubit, HomeState>(
//       listener: (context, state) {
//   if (state is HomeSearchByName ||
//       state is HomeSearchByKeyword ||
//       state is HomeSearchByImage) {
//     //TODO later
//   }
// },

//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildHeader(),
//               SizedBox(height: 24.h),

//               // 1️⃣ البحث باسم الدواء
//               _buildSearchByName(context),

//               SizedBox(height: 20.h),

//               // 2️⃣ البحث بالروشتة
//               _buildSearchByImage(context),

//               SizedBox(height: 24.h),

//               // 3️⃣ البحث بالكلمات المفتاحية
//               _buildKeywords(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= HEADER =================
//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24.w),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             AppColors.backgroundGradientStart,
//             AppColors.backgroundGradientEnd,
//           ],
//         ),
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(24),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             'مرحباً بك،\nأحمد محمد',
//             textAlign: TextAlign.right,
//             style: GoogleFonts.cairo(
//               fontSize: 22.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             'عن أي دواء تبحث اليوم؟',
//             textAlign: TextAlign.right,
//             style: GoogleFonts.cairo(
//               fontSize: 18.sp,
//               color: Colors.white.withOpacity(0.9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= SEARCH BY NAME =================
//   Widget _buildSearchByName(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Column(
//         children: [
//           TextField(
//             controller: _searchController,
//             textAlign: TextAlign.right,
//             decoration: InputDecoration(
//               hintText: 'اكتب اسم الدواء (مثال: بنادول)',
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             width: double.infinity,
//             height: 50.h,
//             child: ElevatedButton(
//               onPressed: () {
//                 context.read<HomeCubit>().searchByName(
//                       _searchController.text,
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.backgroundGradientStart,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.r),
//                 ),
//               ),
//               child: Text(
//                 'بحث',
//                 style: GoogleFonts.cairo(
//                   fontSize: 16.sp,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= SEARCH BY IMAGE =================
//   Widget _buildSearchByImage(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: InkWell(
//         onTap: () {
//           context.read<HomeCubit>().searchByImage();
//         },
//         child: Container(
//           padding: EdgeInsets.all(24.w),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 AppColors.backgroundGradientStart,
//                 AppColors.backgroundGradientEnd,
//               ],
//             ),
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Column(
//             children: [
//               const Icon(Icons.camera_alt, color: Colors.white, size: 40),
//               SizedBox(height: 12.h),
//               Text(
//                 'تصوير الروشتة',
//                 style: GoogleFonts.cairo(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 6.h),
//               Text(
//                 'قم بتصوير الروشتة وسنبحث عن الأدوية تلقائياً',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.cairo(
//                   fontSize: 14.sp,
//                   color: Colors.white.withOpacity(0.9),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= KEYWORDS =================
//   Widget _buildKeywords(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             'الأكثر طلباً',
//             style: GoogleFonts.cairo(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Wrap(
//             spacing: 12.w,
//             runSpacing: 12.h,
//             children: keywords.map((keyword) {
//               return ChoiceChip(
//                 label: Text(keyword, style: GoogleFonts.cairo()),
//                 selected: false,
//                 onSelected: (_) {
//                   context.read<HomeCubit>().searchByKeyword(keyword);
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  final List<String> keywords = [
    'مسكنات',
    'فيتامينات',
    'مضادات',
    'برد',
    'ضغط',
    'سكر',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
       if (state is HomeSearchByName) {
          // التنقل إلى شاشة نتائج البحث
          context.go('/pharmacies', extra: {
            'searchQuery': state.query,
            'searchType': 'name',
          });
        }
        if (state is HomeSearchByKeyword) {
          // التنقل إلى شاشة نتائج البحث
          context.go('/pharmacies', extra: {
            'searchQuery': state.keyword,
            'searchType': 'keyword',
          });
        }
        if (state is HomeSearchByImage) {
          // TODO: يمكن إضافة منطق لتصوير الروشتة هنا
          // ثم التنقل لشاشة النتائج
          context.go('/pharmacies', extra: {
            'searchQuery': 'روشتة مصورة',
            'searchType': 'image',
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:      AppColors.backgroundGradientStart,
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
              onPressed: () {
                context.go('/profile');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),

              // 1️⃣ البحث باسم الدواء
              _buildSearchByName(context),

              SizedBox(height: 20.h),

              // 2️⃣ البحث بالروشتة
              _buildSearchByImage(context),

              SizedBox(height: 24.h),

              // 3️⃣ البحث بالكلمات المفتاحية
              _buildKeywords(context),
            ],
          ),
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
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'أحمد محمد',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }

  Widget _buildSearchByName(BuildContext context) {
    return Container(
      color:const Color(0xFFF5F5F5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'اكتب اسم الدواء',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                    context.read<HomeCubit>().searchByName(
                      _searchController.text,
                    );
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
        onTap: () {
          context.read<HomeCubit>().searchByImage();
        },
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
              const Icon(Icons.camera_alt, color: Colors.white, size: 40),
              SizedBox(height: 12.h),
              Text(
                'تصوير الروشتة',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'قم بتصوير الروشتة وسنبحث عن الأدوية تلقائياً',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildKeywords(BuildContext context) {
    return Column(
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
                color: const Color(0xFF0E8F84).withOpacity(0.1),
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
          height: 60.h, // ارتفاع ثابت للسطر
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true, // لجعل السكرول يبدأ من اليمين
              shrinkWrap: true,
              itemCount: keywords.length,
              itemBuilder: (context, index) {
                final keyword = keywords[index];
                return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 10.w, // مسافة بين الأزرار
                    right: index == keywords.length - 1 ? 0 : 0,
                  ),
                  child: InkWell(
                    onTap: () {
                      context.read<HomeCubit>().searchByKeyword(keyword);
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.medication_outlined,
                            size: 20.sp,
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
    );
  }
}