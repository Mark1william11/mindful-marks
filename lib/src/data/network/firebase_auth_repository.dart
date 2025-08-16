import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

// This is the concrete implementation of AuthRepository that uses Firebase.
class FirebaseAuthRepository implements AuthRepository {
  // We depend on an instance of FirebaseAuth.
  final FirebaseAuth _firebaseAuth;

  // The constructor takes a FirebaseAuth instance, allowing us to inject it.
  // This is useful for testing, where we can provide a mock instance.
  FirebaseAuthRepository(this._firebaseAuth);

  // Expose the authStateChanges stream from the FirebaseAuth instance.
  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // We rethrow the exception to be handled by the UI layer.
      // This allows us to show specific error messages to the user.
      rethrow;
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}