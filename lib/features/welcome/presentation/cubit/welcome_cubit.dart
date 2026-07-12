//lib/features/welcome/presentation/cubit/welcome_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dawai_app/core/services/storage_service.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  final StorageService _storageService;

  WelcomeCubit({required StorageService storageService})
      : _storageService = storageService,
        super(WelcomeInitial());

  /// يُستدعى عند ضغط المستخدم على "ابدأ الآن":
  /// يسجّل أن الترحيب تم عرضه فلا يظهر مرة أخرى، ثم ينتقل لتسجيل الدخول.
  Future<void> startNow() async {
    emit(WelcomeLoading());
    await _storageService.setFirstLaunchCompleted();
    emit(WelcomeNavigateToLogin());
  }
}
