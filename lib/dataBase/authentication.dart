import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final _fireAuth = FirebaseAuth.instance;
  String get userUID => _fireAuth.currentUser!.uid;
  // String? get mail => _fireAuth.currentUser!.email;
  Future<String> logIn(String email, String password) async {
    try {
      await _fireAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'true';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      await _fireAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'true';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Weak password, try another password';
      } else if (e.code == 'email-already-in-use') {
        return 'The e-mail has been used before';
      } else {
        return e.message!;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      await _fireAuth.sendPasswordResetEmail(email: email);
      return 'true';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> logOut() async {
    try {
      await _fireAuth.signOut();
      return 'true';
    } catch (e) {
      return e.toString();
    }
  }
}
