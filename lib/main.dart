// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/di/service_locator.dart' as di;
import 'config/routes/app_router.dart';
import 'features/welcome/presentation/cubit/welcome_cubit.dart'; 
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize dependencies
  await di.init();
  
  runApp(const DawaiApp());
}

class DawaiApp extends StatelessWidget {
  const DawaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<WelcomeCubit>()),
            BlocProvider(create: (_) => di.sl<AuthCubit>()),
            BlocProvider(create: (_) => di.sl<HomeCubit>()),
          ],
          child: MaterialApp.router(
            title: 'Dawai App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.teal,
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}