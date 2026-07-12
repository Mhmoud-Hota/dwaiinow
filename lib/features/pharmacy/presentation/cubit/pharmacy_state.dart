// lib/features/pharmacy/presentation/cubit/pharmacy_state.dart
part of 'pharmacy_cubit.dart';

abstract class PharmacyState {}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

/// حالة البحث بالصورة: نجح الـ OCR وجاري البحث في المخزون
class PharmacyImageExtracted extends PharmacyState {
  final String extractedName;
  final List<String> alternativeNames;
  PharmacyImageExtracted({
    required this.extractedName,
    required this.alternativeNames,
  });
}

class PharmacyLoaded extends PharmacyState {
  final List<MedicineSearchResult> medicines;
  final String searchedQuery;
  final bool isImageSearch;

  PharmacyLoaded({
    required this.medicines,
    required this.searchedQuery,
    this.isImageSearch = false,
  });
}

class PharmacyEmpty extends PharmacyState {
  final String query;
  PharmacyEmpty({required this.query});
}

class PharmacyError extends PharmacyState {
  final String message;
  PharmacyError(this.message);
}