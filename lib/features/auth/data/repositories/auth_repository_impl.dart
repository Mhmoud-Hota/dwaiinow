//lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:dawai_app/core/services/auth_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../../../core/services/storage_service.dart'; // أضف هذا الاستيراد

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final StorageService _storageService;

  AuthRepositoryImpl({
    required AuthService authService,
    required StorageService storageService,
  })  : _authService = authService,
        _storageService = storageService;

  @override
  Future<UserEntity> login(String phoneNumber, String password) async {
    final user = await _authService.loginWithPhoneAndPassword(
      phoneNumber: phoneNumber,
      password: password,
    );
    
    // Save user locally
    await _storageService.saveUser(user);
    
    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,  // تأكد من الاسم
  }) async {
    final user = await _authService.registerWithPhoneAndPassword(
      name: name,
      phoneNumber: phoneNumber,
      password: password,
      address: address,
      profileImageUrl: profileImageUrl,
    );
    
    // Save user locally
    await _storageService.saveUser(user);
    
    return user;
  }

 

  @override
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? address,
    String? profileImageUrl,
  }) async {
    await _authService.updateUserProfile(
      userId: userId,
      name: name,
      address: address,
      profileImageUrl: profileImageUrl,
    );
    
    // Update local storage
    final currentUser = await _storageService.getUser();
    if (currentUser != null) {
      await _storageService.saveUser(UserModel(
        id: currentUser.id,
        name: name ?? currentUser.name,
        phoneNumber: currentUser.phoneNumber,
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
        address: address ?? currentUser.address,
        createdAt: currentUser.createdAt,
      ));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final firebaseUser = _authService.getCurrentUser();
    if (firebaseUser == null) return null;
    
    // Get from local storage
    final localUser = _storageService.getUserSync();
    return localUser;
  }
  
  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}