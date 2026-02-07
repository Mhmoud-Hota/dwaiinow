//lib/core/services/firebase_service.dart
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dawai_app/core/errors/exceptions.dart';

class FirebaseService {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;

  // Initialize Firebase
  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
    } catch (e) {
      throw FirebaseException(message: 'فشل في تهيئة Firebase: $e', plugin: 'firebase_service');
    }
  }

  // Authentication methods
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthError(e));
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthError(e));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(message: 'فشل في تسجيل الخروج: $e');
    }
  }

  User? get currentUser => _auth.currentUser;

  // Firestore methods
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw DatabaseException(message: 'فشل في جلب المستند: $e');
    }
  }

  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      throw DatabaseException(message: 'فشل في حفظ المستند: $e');
    }
  }

  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw DatabaseException(message: 'فشل في تحديث المستند: $e');
    }
  }

  Stream<QuerySnapshot> getCollectionStream(String collection) {
    try {
      return _firestore.collection(collection).snapshots();
    } catch (e) {
      throw DatabaseException(message: 'فشل في جلب البيانات: $e');
    }
  }

  Future<QuerySnapshot> queryCollection(
    String collection, {
    String? field,
    dynamic value,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      
      if (field != null && value != null) {
        query = query.where(field, isEqualTo: value);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      return await query.get();
    } catch (e) {
      throw DatabaseException(message: 'فشل في البحث: $e');
    }
  }

  // Storage methods
  Future<String> uploadFile({
    required String path,
    required String fileName,
    required File file,
  }) async {
    try {
      final ref = _storage.ref('$path/$fileName');
      final task = ref.putFile(file);
      final snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw StorageException(message: 'فشل في رفع الملف: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw StorageException(message: 'فشل في حذف الملف: $e');
    }
  }

  // Helper method for handling auth errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مسجل بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'network-request-failed':
        return 'خطأ في الاتصال بالشبكة';
      case 'user-disabled':
        return 'الحساب معطل';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات، حاول لاحقاً';
      default:
        return 'حدث خطأ غير متوقع: ${e.message}';
    }
  }

  // Real-time listener for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Password reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthError(e));
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.updatePhotoURL(photoURL);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthError(e));
    }
  }
}