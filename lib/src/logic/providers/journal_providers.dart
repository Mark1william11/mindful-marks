import 'package:mindful_marks/src/data/local/drift_journal_repository.dart';
import 'package:mindful_marks/src/logic/providers/auth_providers.dart';
import 'package:mindful_marks/src/logic/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mindful_marks/src/data/repositories/journal_repository.dart';
import 'package:mindful_marks/src/logic/models/journal_entry_with_tags.dart';
import 'firebase_providers.dart';

part 'journal_providers.g.dart';

@riverpod
JournalRepository journalRepository(JournalRepositoryRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  final user = authState.valueOrNull;

  if (user == null) {
    throw Exception('User is not authenticated. Cannot access journal repository.');
  }

  final database = ref.watch(appDatabaseProvider);
  final firebaseService = ref.watch(firebaseJournalServiceProvider);
  return DriftJournalRepository(database, firebaseService, user.uid);
}

@riverpod
Stream<List<JournalEntryWithTags>> journalEntries(JournalEntriesRef ref) {
  // This is the correct way to handle a provider that can throw an error.
  try {
    // Attempt to get the repository. If the user is logged out, this will throw.
    final journalRepository = ref.watch(journalRepositoryProvider);
    return journalRepository.watchEntries();
  } catch (e) {
    // If an error is caught (i.e., user is logged out), return an empty stream.
    // The UI will show an empty list of journals.
    return Stream.value([]);
  }
}