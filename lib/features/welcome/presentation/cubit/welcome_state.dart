//lib/features/welcome/presentation/cubit/welcome_state.dart
part of 'welcome_cubit.dart';

abstract class WelcomeState {}

class WelcomeInitial extends WelcomeState {}

/// أثناء حفظ حالة "تم عرض الترحيب" قبل الانتقال
class WelcomeLoading extends WelcomeState {}

class WelcomeNavigateToLogin extends WelcomeState {}
