//lib/core/errors/exceptions.dart
class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class AuthException extends AppException {
  AuthException({required String message}) : super(message);
}

class DatabaseException extends AppException {
  DatabaseException({required String message}) : super(message);
}

class StorageException extends AppException {
  StorageException({required String message}) : super(message);
}

class NetworkException extends AppException {
  NetworkException(String s, {required String message}) : super(message);
}

