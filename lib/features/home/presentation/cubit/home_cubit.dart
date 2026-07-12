//lib/features/home/presentation/cubit/home_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void searchByName(String query) {
    if (query.trim().isNotEmpty) {
    emit(HomeSearchByName(query));
    }
  }

  void searchByImage() {
    emit(HomeSearchByImage());
  }

  void searchByKeyword(String keyword) {
    emit(HomeSearchByKeyword(keyword));
  }
}
