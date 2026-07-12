class AppConstants {
  AppConstants._();

  // ── Network ───────────────────────────────────
  static const int connectTimeoutMs  = 15000;
  static const int receiveTimeoutMs  = 30000;

  // ── Pagination ────────────────────────────────
  static const int defaultPageSize   = 20;
  static const int maxPageSize       = 100;

  // ── UI ────────────────────────────────────────
  static const int animationDurationMs = 300;
  static const double maxImageSizeMB   = 5.0;

  // ── Regex ─────────────────────────────────────
  static const String phoneRegex = r'^\+?[0-9]{9,15}$';

  static const String defaultLanguage = 'ar';
}