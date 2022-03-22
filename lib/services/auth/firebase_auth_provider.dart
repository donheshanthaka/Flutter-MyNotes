// A concrete class that connects with the user defined auth classes and firebase authentication to be linked with the UI layer of code

import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      final user = currentUser;
      if (user != null){
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') { // cathcing weak password
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') { // catching emails that are already in use
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') { // catching invalid emails
        throw InvalidEmailAuthException();
      } else {  // Catching other errors related to firebase authentication
        throw GenericAuthException;
      }
    } catch (_) { // Catching generic errors
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
    }) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = currentUser;
        if (user != null){
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException(); // cathcing invalid user error
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException(); // cathcing invalid password error
      } else {
        throw GenericAuthException(); // catching firebase auth errors apart from user and password
      }
    } catch (_) {
      throw GenericAuthException(); // catching generic errors
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null){
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

}