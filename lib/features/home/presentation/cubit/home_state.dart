//lib/features/home/presentation/cubit/home_state.dart
part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSearchByName extends HomeState {
  final String query;
  HomeSearchByName(this.query);
}

class HomeSearchByImage extends HomeState {}

class HomeSearchByKeyword extends HomeState {
  final String keyword;
  HomeSearchByKeyword(this.keyword);
}
