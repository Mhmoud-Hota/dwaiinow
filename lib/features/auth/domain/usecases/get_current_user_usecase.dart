// lib/features/auth/domain/usecases/get_current_user_usecase.dart

import 'package:dawai_app/features/auth/domain/entities/user_entity.dart';
import 'package:dawai_app/features/auth/domain/repositories/auth_repository.dart';

/// جلب المستخدم الحالي من التخزين المحلي (بدون شبكة)
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase({required AuthRepository repository})
      : _repository = repository;

  UserEntity? call() => _repository.getCurrentUser();
}