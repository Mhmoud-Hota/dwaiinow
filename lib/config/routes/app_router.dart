// // lib/config/routes/app_router.dart
// import 'package:dawai_app/features/pharmacy/presentation/pharmacy_results_screen.dart';
// import 'package:go_router/go_router.dart';
// import '../../features/welcome/presentation/welcome_screen.dart';
// import '../../features/auth/presentation/pages/login_screen.dart';
// import '../../features/home/presentation/home_screen.dart';
// import '../../features/profile/presentation/profile_screen.dart';

// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: '/welcome',
//     routes: [
//       GoRoute(
//         path: '/welcome',
//         name: 'welcome',
//         builder: (context, state) => const WelcomeScreen(),
//       ),
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: '/home',
//         name: 'home',
//         builder: (context, state) =>  HomeScreen(),
//       ),
//       GoRoute(
//         path: '/profile',
//         name: 'profile',
//         builder: (context, state) => const ProfileScreen(),
//       ),
//        GoRoute(
//         path: '/pharmacies',
//         name: 'pharmacies',
//         builder: (context, state) => const PharmacyResultsScreen(),
//       ),
//     ],
//   );
// }

import 'package:go_router/go_router.dart';

import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/pharmacy/presentation/pharmacy_results_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/pharmacies',
        name: 'pharmacies',
        builder: (context, state) => const PharmacyResultsScreen(),
      ),
    ],
    redirect: (context, state) {
      // هنا يمكنك إضافة منطق إعادة التوجيه بناءً على حالة المصادقة
      // مثال: إذا كان المستخدم غير مسجل الدخول وأراد الذهاب للرئيسية
      return null;
    },
  );
}