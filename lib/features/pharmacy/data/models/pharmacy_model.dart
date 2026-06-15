class PharmacyModel {
  final String id;
  final String name;
  final String phone;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final double distanceKm;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.distanceKm,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      isAvailable: json['isAvailable'] ?? false,
      distanceKm: (json['distanceKm'] as num).toDouble(),
    );
  }
}