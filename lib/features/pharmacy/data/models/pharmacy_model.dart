// lib/features/pharmacy/data/models/pharmacy_model.dart

/// ─────────────────────────────────────────────────────────
/// صيدلية واحدة ضمن نتائج البحث
/// ─────────────────────────────────────────────────────────
class PharmacyResultModel {
  final String pharmacyId;
  final String pharmacyName;
  final String pharmacySlug;

  final String? address;
  final String? city;
  final String? phone;
  final String? workingHours;

  final int quantity;
  final double? price;
  final String? unit;
  final String? expiryDate;

  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  const PharmacyResultModel({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.pharmacySlug,
    required this.quantity,
    this.address,
    this.city,
    this.phone,
    this.workingHours,
    this.price,
    this.unit,
    this.expiryDate,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  factory PharmacyResultModel.fromJson(Map<String, dynamic> json) {
    return PharmacyResultModel(
      pharmacyId: json['pharmacy_id']?.toString() ?? '',
      pharmacyName: json['pharmacy_name']?.toString() ?? '',
      pharmacySlug: json['pharmacy_slug']?.toString() ?? '',
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      phone: json['phone']?.toString(),
      workingHours: json['working_hours']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      unit: json['unit']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );
  }

  String get distanceText {
    if (distanceKm == null) return '';

    if (distanceKm! < 1) {
      return '${(distanceKm! * 1000).toStringAsFixed(0)} م';
    }

    return '${distanceKm!.toStringAsFixed(1)} كم';
  }

  bool get hasLocation => latitude != null && longitude != null;

  bool get hasPhone => phone != null && phone!.trim().isNotEmpty;
}

/// ─────────────────────────────────────────────────────────
/// دواء مع الصيدليات المتوفرة
/// ─────────────────────────────────────────────────────────
class MedicineSearchResult {
  final int? medicineId;

  final String canonicalName;
  final String? scientificName;
  final String? barcode;
  final String? category;
  final String? unit;

  final int totalQuantity;

  final List<PharmacyResultModel> pharmacies;

  const MedicineSearchResult({
    this.medicineId,
    required this.canonicalName,
    this.scientificName,
    this.barcode,
    this.category,
    this.unit,
    required this.totalQuantity,
    required this.pharmacies,
  });

  factory MedicineSearchResult.fromJson(Map<String, dynamic> json) {
    final medicine = json['medicine'] as Map<String, dynamic>? ?? {};

    final pharmaciesJson = json['pharmacies'] as List<dynamic>? ?? [];

    final pharmacies = pharmaciesJson
        .map(
          (p) => PharmacyResultModel.fromJson(
            p as Map<String, dynamic>,
          ),
        )
        .toList();

    return MedicineSearchResult(
      medicineId: (medicine['id'] as num?)?.toInt(),
      canonicalName: medicine['canonical_name']?.toString() ?? '',
      scientificName: medicine['scientific_name']?.toString(),
      barcode: medicine['barcode']?.toString(),
      category: medicine['category']?.toString(),
      unit: medicine['unit']?.toString(),
      totalQuantity: pharmacies.fold<int>(
        0,
        (sum, pharmacy) => sum + pharmacy.quantity,
      ),
      pharmacies: pharmacies,
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// نتيجة البحث بالصورة
/// ─────────────────────────────────────────────────────────
class ImageSearchApiResult {
  final bool success;

  final String? extractedName;

  final List<String> alternativeNames;

  final String? message;

  final List<MedicineSearchResult> results;

  const ImageSearchApiResult({
    required this.success,
    this.extractedName,
    this.alternativeNames = const [],
    this.message,
    required this.results,
  });

  factory ImageSearchApiResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final resultsJson = data['results'] as List<dynamic>? ?? [];

    return ImageSearchApiResult(
      success: data['success'] as bool? ?? true,
      extractedName: data['extracted_name']?.toString(),
      alternativeNames: (data['alternative_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      message: data['message']?.toString(),
      results: resultsJson
          .map(
            (r) => MedicineSearchResult.fromJson(
              r as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
