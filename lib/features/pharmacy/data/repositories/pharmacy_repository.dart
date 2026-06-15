import '../models/pharmacy_model.dart';

class PharmacyRepository {
  Future<List<PharmacyModel>> searchNearestPharmacies({
    required String query,
    required double lat,
    required double lng,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      PharmacyModel(
        id: '1',
        name: 'صيدلية الشفاء',
        phone: '0912345678',
        latitude: 15.5000,
        longitude: 32.6000,
        isAvailable: true,
        distanceKm: 1.2,
      ),
      PharmacyModel(
        id: '2',
        name: 'صيدلية الرحمة',
        phone: '0923456789',
        latitude: 15.5100,
        longitude: 32.6100,
        isAvailable: true,
        distanceKm: 2.0,
      ),
      PharmacyModel(
        id: '3',
        name: 'صيدلية الحياة',
        phone: '0934567890',
        latitude: 15.5200,
        longitude: 32.6200,
        isAvailable: true,
        distanceKm: 3.4,
      ),
    ];
  }
}