import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase({required AuthRepository repository}) : _repository = repository;
  Future<void> call() async => _repository.logout();
}