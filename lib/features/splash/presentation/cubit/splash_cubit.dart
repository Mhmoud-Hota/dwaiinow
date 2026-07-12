//lib/features/splash/presentation/cubit/splash_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dawai_app/core/services/storage_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final StorageService _storageService;

  SplashCubit({required StorageService storageService})
      : _storageService = storageService,
        super(SplashInitial());

  /// يحدد وجهة المستخدم القادمة بناءً على أول تشغيل للتطبيق.
  /// [minDuration] هي أقل مدة تظل فيها أنيميشن السبلاش ظاهرة حتى لو كان
  /// الفحص المحلي أسرع من كده، عشان الانتقال يحس بشكل سلس واحترافي.
  Future<void> checkAppStatus({
    Duration minDuration = const Duration(milliseconds: 1600),
  }) async {
    final started = DateTime.now();

    final isFirstLaunch = _storageService.isFirstLaunch;

    final elapsed = DateTime.now().difference(started);
    final remaining = minDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (isClosed) return;

    if (isFirstLaunch) {
      emit(SplashNavigateToWelcome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
