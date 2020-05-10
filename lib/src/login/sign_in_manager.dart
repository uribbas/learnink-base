import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth,@required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User> signInWithEmailAndPassword() async =>
      await _signIn(auth.signInWithEmailandPassword);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
