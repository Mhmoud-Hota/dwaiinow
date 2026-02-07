//lib/features/welcome/presentation/cubit/welcome_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(WelcomeInitial());

  void startNow() {
    // تم نقل منطق التنقل إلى GoRouter في الواجهة
    emit(WelcomeInitial());
  }
}