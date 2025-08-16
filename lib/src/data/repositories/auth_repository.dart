import 'package:firebase_auth/firebase_auth.dart';

// The abstract class defines a "contract" for our authentication repository.
// Any class that implements AuthRepository must provide these methods.
// This allows us to swap out the implementation (e.g., from Firebase to another
// service) without changing the rest of our application code.
abstract class AuthRepository {
  // A stream that emits the current user when the authentication state changes.
  Stream<User?> get authStateChanges;

  // Method to sign in with email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Method to sign up with email and password.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Method to send a password reset email.
  Future<void> sendPasswordResetEmail({required String email});

  // Method to sign out the current user.
  Future<void> signOut();
}