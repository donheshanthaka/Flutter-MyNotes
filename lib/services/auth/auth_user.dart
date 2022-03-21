import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  // Calling the firebase auth user to get the email verification status (bool) and passing that value for the constructor in AuthUser class
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
