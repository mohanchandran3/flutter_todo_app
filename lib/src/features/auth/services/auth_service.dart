import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_app/src/core/errors/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance, _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException('User creation failed - no user returned');
      }

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userId': userCredential.user!.uid,
        'username': username.trim(),
        'email': email.trim(),
        'phoneNumber': phoneNumber.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        'Authentication failed: ${_getAuthErrorReason(e.code)}',
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        'Database operation failed: ${e.message ?? 'Unknown error'}',
      );
    } catch (e) {
      throw ServerException(
        'Unexpected error during sign up: ${e.toString()}',
      );
    }
  }

  Future<User?> signInWithEmailOrUsername({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final isEmail = emailOrUsername.contains('@');
      if (isEmail) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailOrUsername,
          password: password,
        );
        return userCredential.user;
      } else {
        final querySnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: emailOrUsername)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with that username',
          );
        }

        final userData = querySnapshot.docs.first.data();
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userData['email'],
          password: password,
        );
        return userCredential.user;
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}

String _getAuthErrorReason(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'Email already registered';
    case 'invalid-email':
      return 'Invalid email format';
    case 'operation-not-allowed':
      return 'Email/password accounts disabled';
    case 'weak-password':
      return 'Password too weak';
    default:
      return 'Unknown authentication error';
  }
}