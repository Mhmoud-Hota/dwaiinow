import 'package:dawai_app/features/auth/presentation/pages/reset_password.dart';
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
          );
        },
      ),

      // ✅ لو ما عندك شاشة نسيان كلمة المرور، احذف الذهاب لها من LoginScreen.
      // أو أنشئ شاشة بسيطة لها وأضف Route هنا.
    ],
  );
}