import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/network/firebase_auth_repository.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

// This provider creates and exposes the FirebaseAuth instance.
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

// This provider creates and exposes our FirebaseAuthRepository.
// It depends on the firebaseAuthProvider to get the FirebaseAuth instance.
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FirebaseAuthRepository(ref.watch(firebaseAuthProvider));
}

// This is one of the most important providers in the app.
// It's a StreamProvider that listens to the authStateChanges stream from our repository.
// Riverpod will automatically manage the stream's subscription and state.
// Other parts of the app can simply "watch" this provider to get the current user
// and rebuild automatically when the auth state changes (login/logout).
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}