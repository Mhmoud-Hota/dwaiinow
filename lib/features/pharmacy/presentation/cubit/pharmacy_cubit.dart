// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dawai_app/core/services/location_service.dart';
// import 'package:dawai_app/features/pharmacy/data/repositories/pharmacy_repository.dart';
// import 'package:dawai_app/features/pharmacy/data/models/pharmacy_model.dart';

// part 'pharmacy_state.dart';

// class PharmacyCubit extends Cubit<PharmacyState> {
//   final PharmacyRepository repo;
//   final LocationService location;

//   PharmacyCubit({
//     required this.repo,
//     required this.location,
//   }) : super(PharmacyInitial());

//   Future<void> loadPharmacies({required String searchQuery}) async {
//     if (searchQuery.trim().isEmpty) {
//       emit(PharmacyError('يرجى إدخال اسم الدواء'));
//       return;
//     }

//     emit(PharmacyLoading());
//     try {
//       final pos = await location.getCurrentPosition();

//       final pharmacies = await repo.searchNearestPharmacies(
//         query: searchQuery.trim(),
//         lat: pos.latitude,
//         lng: pos.longitude,
//       );

//       emit(PharmacyLoaded(pharmacies));
//     } catch (e) {
//       emit(PharmacyError(e.toString().replaceAll('Exception: ', '')));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';

part 'pharmacy_state.dart';

class Pharmacy {
  final String id;
  final String name;
  final String distance;
  final String phone;
  final double latitude;
  final double longitude;
  final bool isAvailable;

  Pharmacy({
    required this.id,
    required this.name,
    required this.distance,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
  });
}

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(PharmacyInitial());

  Future<void> loadPharmacies({required String searchQuery}) async {
    emit(PharmacyLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      final pharmacies = [
        Pharmacy(
          id: '1',
          name: 'صيدلية الشفاء',
          distance: '0.5',
          phone: '+249123456789',
          latitude: 15.5,
          longitude: 32.6,
          isAvailable: true,
        ),
        Pharmacy(
          id: '2',
          name: 'صيدلية النيل',
          distance: '1.2',
          phone: '+249987654321',
          latitude: 15.6,
          longitude: 32.5,
          isAvailable: true,
        ),
        Pharmacy(
          id: '3',
          name: 'صيدلية الأمل',
          distance: '3.5',
          phone: '+249444555666',
          latitude: 15.7,
          longitude: 32.7,
          isAvailable: false,
        ),
      ];

      emit(PharmacyLoaded(pharmacies));
    } catch (_) {
      emit(PharmacyError('حدث خطأ في جلب البيانات'));
    }
  }

  void callPharmacy(Pharmacy pharmacy) {
    // لاحقاً url_launcher
  }

  void openLocation(Pharmacy pharmacy) {
    // لاحقاً url_launcher
  }
}