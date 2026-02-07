//lib/features/pharmacy/presentation/cubit/pharmacy_cubit.dart
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

  Future<void> loadPharmacies() async {
    emit(PharmacyLoading());
    
    try {
      // محاكاة جلب البيانات من API
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
          name: 'صيدلية الحياة',
          distance: '2.0',
          phone: '+249111222333',
          latitude: 15.4,
          longitude: 32.4,
          isAvailable: true,
        ),
        Pharmacy(
          id: '4',
          name: 'صيدلية الأمل',
          distance: '3.5',
          phone: '+249444555666',
          latitude: 15.7,
          longitude: 32.7,
          isAvailable: false,
        ),
      ];
      
      emit(PharmacyLoaded(pharmacies));
    } catch (e) {
      emit(PharmacyError('حدث خطأ في جلب البيانات'));
    }
  }

  void callPharmacy(Pharmacy pharmacy) {
    // TODO: Implement call functionality
    // يمكن استخدام package مثل url_launcher للاتصال
  }

  void openLocation(Pharmacy pharmacy) {
    // TODO: Implement open map functionality
    // يمكن استخدام package مثل url_launcher لفتح خرائط جوجل
  }
}