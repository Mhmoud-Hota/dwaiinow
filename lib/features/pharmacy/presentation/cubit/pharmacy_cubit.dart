// lib/features/pharmacy/presentation/cubit/pharmacy_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dawai_app/features/pharmacy/data/models/pharmacy_model.dart';
import 'package:dawai_app/features/pharmacy/data/repositories/pharmacy_repository.dart';
import 'package:dawai_app/core/services/location_service.dart';

part 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  final PharmacyRepository _repository;
  final LocationService _locationService;

  PharmacyCubit({
    required PharmacyRepository repository,
    required LocationService locationService,
  })  : _repository = repository,
        _locationService = locationService,
        super(PharmacyInitial());

  // ─────────────────────────────────────────────────────────────────────────
  // بحث بالاسم
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> loadPharmacies({required String searchQuery}) async {
    if (searchQuery.trim().length < 2) {
      emit(PharmacyError('يرجى إدخال اسم الدواء (حرفين على الأقل)'));
      return;
    }

    emit(PharmacyLoading());

    try {
      // محاولة الحصول على الموقع (اختياري — لا يوقف البحث إن فشل)
      double? lat;
      double? lng;
      try {
        final pos = await _locationService.getCurrentPosition();
        lat = pos.latitude;
        lng = pos.longitude;
      } catch (_) {
        // الموقع غير متاح — سيبحث بدون ترتيب جغرافي
      }

      final results = await _repository.searchByName(
        query: searchQuery.trim(),
        lat: lat,
        lng: lng,
      );

      // فلتر الأدوية التي لا توجد لها صيدليات متاحة
      final available = results
          .where((m) => m.pharmacies.isNotEmpty)
          .toList();

      if (available.isEmpty) {
        emit(PharmacyEmpty(query: searchQuery.trim()));
      } else {
        emit(PharmacyLoaded(
          medicines: available,
          searchedQuery: searchQuery.trim(),
        ));
      }
    } catch (e) {
      emit(PharmacyError(_friendlyError(e)));
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // بحث بالصورة
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> searchByImage({required File imageFile}) async {
    emit(PharmacyLoading());

    try {
      double? lat;
      double? lng;
      try {
        final pos = await _locationService.getCurrentPosition();
        lat = pos.latitude;
        lng = pos.longitude;
      } catch (_) {}

      final result = await _repository.searchByImage(
        imageFile: imageFile,
        lat: lat,
        lng: lng,
      );

      if (!result.success) {
        emit(PharmacyError(result.message ?? 'لم يتم التعرف على دواء في الصورة'));
        return;
      }

      // أخبر الـ UI باسم الدواء المستخرج
      emit(PharmacyImageExtracted(
        extractedName: result.extractedName ?? '',
        alternativeNames: result.alternativeNames,
      ));

      final available = result.results
          .where((m) => m.pharmacies.isNotEmpty)
          .toList();

      if (available.isEmpty) {
        emit(PharmacyEmpty(query: result.extractedName ?? ''));
      } else {
        emit(PharmacyLoaded(
          medicines: available,
          searchedQuery: result.extractedName ?? '',
          isImageSearch: true,
        ));
      }
    } catch (e) {
      emit(PharmacyError(_friendlyError(e)));
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // اتصال بصيدلية
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> callPharmacy(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // فتح الموقع في خرائط
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> openLocation(double? lat, double? lng, String name) async {
    final Uri uri;
    if (lat != null && lng != null && (lat != 0 || lng != 0)) {
      final encoded = Uri.encodeComponent(name);
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng($encoded)',
      );
    } else {
      // fallback: بحث بالاسم فقط
      final encoded = Uri.encodeComponent(name);
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encoded',
      );
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('NetworkException')) {
      return 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة';
    }
    if (msg.contains('TimeoutException')) {
      return 'انتهت مهلة الاتصال، حاول مرة أخرى';
    }
    if (msg.contains('400')) return 'طلب غير صحيح';
    if (msg.contains('401')) return 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً';
    if (msg.contains('500')) return 'خطأ في الخادم، حاول لاحقاً';
    return 'حدث خطأ غير متوقع';
  }
}