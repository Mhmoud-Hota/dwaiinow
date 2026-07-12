//lib/features/splash/presentation/cubit/splash_state.dart
part of 'splash_cubit.dart';

abstract class SplashState {}

/// الحالة الابتدائية — لسه بنعرض الأنيميشن
class SplashInitial extends SplashState {}

/// أول مرة يفتح فيها المستخدم التطبيق ولا يوجد من سجل دخوله من قبل
/// → نعرض شاشة الترحيب الاحترافية
class SplashNavigateToWelcome extends SplashState {}

/// المستخدم فتح التطبيق قبل كده (سواء مسجل دخول أو لأ)
/// → نتخطى الترحيب ونروح مباشرة لتسجيل الدخول
class SplashNavigateToLogin extends SplashState {}
