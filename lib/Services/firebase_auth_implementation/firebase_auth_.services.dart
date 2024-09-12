import 'package:crud_firebase/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> singUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(
            message: 'the email address is already in use.', color: Colors.red);
      } else {
        showToast(message: 'An error ocurred: ${e.code}', color: Colors.red);
      }
    }
    return null;
  }

  Future<User?> singInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.', color: Colors.red);
      } else {
        showToast(message: 'An error ocurred: ${e.code}', color: Colors.red);
      }
    }
    return null;
  }
}
