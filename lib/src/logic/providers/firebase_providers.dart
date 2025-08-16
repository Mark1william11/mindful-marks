import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindful_marks/src/logic/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mindful_marks/src/data/network/firebase_journal_service.dart';

part 'firebase_providers.g.dart';

// This provider exposes the raw Firebase Auth instance.
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

// This provider exposes the raw Firestore instance.
@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

// This provider creates our FirebaseJournalService.
// It no longer needs to pass any arguments, which fixes the error.
@riverpod
FirebaseJournalService firebaseJournalService(FirebaseJournalServiceRef ref) {
  return FirebaseJournalService();
}