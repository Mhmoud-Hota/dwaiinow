//lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dawai_app/features/auth/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل الدخول برقم الهاتف وكلمة المرور (عبر تحويله لإيميل وهمي)
  Future<UserModel> loginWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final email = '${phoneNumber.replaceAll('+', '')}@dawai.com';
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      
      if (!userDoc.exists) {
        throw Exception('بيانات المستخدم غير موجودة في قاعدة البيانات');
      }
      
      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء تسجيل الدخول');
    }
  }

  // إنشاء حساب جديد
  Future<UserModel> registerWithPhoneAndPassword({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,
  }) async {
    try {
      final email = '${phoneNumber.replaceAll('+', '')}@dawai.com';
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userModel = UserModel(
        id: credential.user!.uid,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
      );
      
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userModel.toMap());
      
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception('فشل إنشاء الحساب، يرجى المحاولة لاحقاً');
    }
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'المستخدم غير موجود';
      case 'wrong-password': return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use': return 'رقم الهاتف مسجل مسبقاً';
      case 'weak-password': return 'كلمة المرور ضعيفة جداً';
      default: return 'خطأ: ${e.message}';
    }
  }

  getCurrentUser() {}

  Future<void> updateUserProfile({required String userId, String? name, String? address, String? profileImageUrl}) async {}
}
