// lib/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dawai_app/core/network/api_client.dart';
import 'package:dawai_app/core/services/auth_service.dart';
import 'package:dawai_app/core/services/location_service.dart';
import 'package:dawai_app/core/services/storage_service.dart';

// Auth
import 'package:dawai_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dawai_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dawai_app/features/auth/presentation/cubit/auth_cubit.dart';

// Pharmacy (جديد)
import 'package:dawai_app/features/pharmacy/data/repositories/pharmacy_repository.dart';
import 'package:dawai_app/features/pharmacy/presentation/cubit/pharmacy_cubit.dart';

// Cubits
import 'package:dawai_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:dawai_app/features/welcome/presentation/cubit/welcome_cubit.dart';
import 'package:dawai_app/features/splash/presentation/cubit/splash_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ─── Core ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(
    () => ApiClient(sl<Dio>(), sl<FlutterSecureStorage>()),
  );

  // ─── Services ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => AuthService(apiClient: sl(), storage: sl()),
  );
  sl.registerLazySingleton(() => StorageService());
  sl.registerLazySingleton(() => LocationService());
  await sl<StorageService>().init();

  // ─── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authService: sl(), storageService: sl()),
  );
  sl.registerLazySingleton(
    () => PharmacyRepository(sl<ApiClient>()),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(repository: sl()));

  // ─── Cubits ───────────────────────────────────────────────────────────────
  sl.registerFactory(() => SplashCubit(storageService: sl()));
  sl.registerFactory(() => WelcomeCubit(storageService: sl()));
  sl.registerFactory(
    () => AuthCubit(
      registerUseCase: sl(),
      loginUseCase: sl(),
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(() => HomeCubit());

  // ── PharmacyCubit — يحتاج repository + locationService ──────────────────
  sl.registerFactory(
    () => PharmacyCubit(
      repository: sl<PharmacyRepository>(),
      locationService: sl<LocationService>(),
    ),
  );
}