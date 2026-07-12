// lib/features/pharmacy/data/repositories/pharmacy_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dawai_app/config/constants/api_constants.dart';
import 'package:dawai_app/core/network/api_client.dart';
import '../models/pharmacy_model.dart';

class PharmacyRepository {
  final ApiClient _apiClient;

  PharmacyRepository(this._apiClient);

  // ─────────────────────────────────────────────────────────────────────────
  // البحث بالاسم مع دعم الموقع الجغرافي
  // GET /inventory/find?q=...&lat=...&lng=...&radius=...
  // ─────────────────────────────────────────────────────────────────────────
  Future<List<MedicineSearchResult>> searchByName({
    required String query,
    double? lat,
    double? lng,
    double radius = 0,
    bool onlyAvailable = true,
  }) async {
    final params = <String, dynamic>{
      'q': query.trim(),
      'only_available': onlyAvailable,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radius > 0) 'radius': radius,
    };

    final response = await _apiClient.get(
      ApiConstants.inventoryFind,
      queryParameters: params,
    );

    // الـ TransformInterceptor يغلّف الاستجابة في { data: ... }
    final body = response.data as Map<String, dynamic>;
    final payload = body['data'] as Map<String, dynamic>? ?? body;
    final resultsList = payload['results'] as List<dynamic>? ?? [];

    return resultsList
        .map((r) => MedicineSearchResult.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // البحث بالصورة (روشتة / علبة دواء)
  // POST /inventory/image-search  multipart/form-data
  // ─────────────────────────────────────────────────────────────────────────
  Future<ImageSearchApiResult> searchByImage({
    required File imageFile,
    double? lat,
    double? lng,
    double radius = 0,
  }) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'prescription.jpg',
      ),
      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),
      if (radius > 0) 'radius': radius.toString(),
    });

    final response = await _apiClient.post(
      '/inventory/image-search',
      data: formData,
    );

    final body = response.data as Map<String, dynamic>;
    return ImageSearchApiResult.fromJson(body);
  }
}