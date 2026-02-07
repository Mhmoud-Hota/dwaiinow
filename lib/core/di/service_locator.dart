import 'package:get_it/get_it.dart';
import 'package:dawai_app/core/services/firebase_service.dart';
import 'package:dawai_app/core/services/auth_service.dart';
import 'package:dawai_app/core/services/storage_service.dart' as core_storage;
import 'package:dawai_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dawai_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:dawai_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:dawai_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dawai_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:dawai_app/features/welcome/presentation/cubit/welcome_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => FirebaseService());
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => core_storage.StorageService());
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authService: sl(),
      storageService: sl(),
    ),
  );
  
  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  
  // Cubits
  sl.registerFactory(() => WelcomeCubit());
  sl.registerFactory(() => AuthCubit(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));
  sl.registerFactory(() => HomeCubit());
}