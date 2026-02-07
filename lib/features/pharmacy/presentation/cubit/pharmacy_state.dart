//lib/features/pharmacy/presentation/cubit/pharmacy_state.dart
part of 'pharmacy_cubit.dart';

abstract class PharmacyState {}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmacyLoaded extends PharmacyState {
  final List<Pharmacy> pharmacies;
  PharmacyLoaded(this.pharmacies);
}

class PharmacyError extends PharmacyState {
  final String message;
  PharmacyError(this.message);
}