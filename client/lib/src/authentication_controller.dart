import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationController with ChangeNotifier {
  AuthenticationController(this._auth);

  final FirebaseAuth _auth;

  User? user;

  _authStateChanged(User? user) {
    this.user = user;
    notifyListeners();
  }

  initialize() {
    _auth.idTokenChanges().listen(_authStateChanged);
  }

  bool isAuthenticated() {
    return user != null;
  }

  signIn() {
    _auth.signInWithProvider(GoogleAuthProvider());
  }
}
