// lib/config/constants/feature_constants.dart
class FeatureConstants {
  FeatureConstants._();

  // ── Medicines ─────────────────────────────────
  static const String medicinesEndpoint  = '/medicines/';
  static const String medicineByIdEndpoint = '/medicines/{id}/';
  static const String categoriesEndpoint = '/medicines/categories/';
  static const String inventoryEndpoint  = '/medicines/inventory/';

  // ── Search ────────────────────────────────────
  static const String searchEndpoint     = '/search/';
  static const int    minSearchChars     = 2;
  static const int    maxSearchResults   = 50;
  static const int    searchDebounceMs   = 300;

  // ── Orders (مستقبلي) ──────────────────────────
  static const String ordersEndpoint     = '/orders/';
  static const String orderItemsEndpoint = '/orders/{id}/items/';

  // ── Notifications (مستقبلي) ───────────────────
  static const String notificationsEndpoint = '/notifications/';
  static const String fcmTopicPrefix        = 'dawai_';
}