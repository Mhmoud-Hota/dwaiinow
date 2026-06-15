import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dawai_app/features/auth/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _emailFromPhone(String phoneNumber) {
    final normalized = phoneNumber.replaceAll('+', '').trim();
    return '$normalized@dawai.com';
  }

  Future<UserModel> loginWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final email = _emailFromPhone(phoneNumber);

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();

      if (!userDoc.exists) {
        throw Exception('بيانات المستخدم غير موجودة في قاعدة البيانات');
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء تسجيل الدخول');
    }
  }

  Future<UserModel> registerWithPhoneAndPassword({
    required String name,
    required String phoneNumber,
    required String password,
    String? address,
    String? profileImageUrl,
  }) async {
    try {
      final email = _emailFromPhone(phoneNumber);

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

      await _firestore.collection('users').doc(userModel.id).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception('فشل إنشاء الحساب، يرجى المحاولة لاحقاً');
    }
  }

  /// ✅ المستخدم الحالي من FirebaseAuth
  User? getCurrentUser() => _auth.currentUser;

  /// ✅ تحديث بيانات المستخدم في Firestore
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? address,
    String? profileImageUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (address != null) data['address'] = address;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;

    if (data.isEmpty) return;

    await _firestore.collection('users').doc(userId).update(data);
  }

  /// ✅ تسجيل خروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة أو رقم الهاتف غير صحيح';
      case 'email-already-in-use':
        return 'رقم الهاتف مسجل مسبقاً';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'network-request-failed':
        return 'تحقق من اتصال الإنترنت';
      default:
        return 'خطأ: ${e.message ?? ''}';
    }
  }
}