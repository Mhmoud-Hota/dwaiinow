import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('الرجاء تشغيل خدمة الموقع');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('تم رفض إذن الموقع');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('إذن الموقع مرفوض نهائياً، فعّل الإذن من الإعدادات');
    }

    return Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}