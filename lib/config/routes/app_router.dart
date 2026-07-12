// lib/config/routes/app_router.dart
import 'package:dawai_app/core/utils/navigation_service.dart';
import 'package:dawai_app/features/auth/presentation/pages/reset_password.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/welcome/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_results_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    navigatorKey: navigatorKey, // ← أضف السطر ده
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/pharmacies',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PharmacyResultsScreen(
            searchQuery: (extra?['searchQuery'] ?? '') as String,
            searchType: (extra?['searchType'] ?? 'name') as String,
            // يُرسَل فقط عند البحث بالصورة
            imagePath: extra?['imagePath'] as String?,
          );
        },
      ),
    ],
  );
}