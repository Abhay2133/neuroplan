import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {

  AuthService() {
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners(); // Notify GoRouter when auth state changes
    });
  }

  bool get isLoggedIn => currentUser != null;
  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // Register a new user with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      String errorMessage = '';
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = e.message ?? 'An unknown error occurred. Please try again.';
        }
      }
      throw Exception(errorMessage);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;
}
