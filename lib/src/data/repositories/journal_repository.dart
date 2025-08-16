import '../../logic/models/journal_entry_with_tags.dart';

// The abstract class (the "contract") for our journal data operations.
abstract class JournalRepository {
  // A stream that emits a list of all journal entries with their tags
  // whenever the data changes. The UI will listen to this stream to rebuild itself.
  Stream<List<JournalEntryWithTags>> watchEntries();

  // Creates a new entry or updates an existing one.
  // It takes simple, primitive types (like a list of tag names as strings)
  // and is responsible for handling the database logic of creating/linking tags.
  Future<void> createOrUpdateEntry({
    required int? id, // null for a new entry, non-null for an update
    required String title,
    required String content,
    required List<String> tagNames,
    required int mood,
  });

  // Deletes a journal entry by its ID.
  Future<void> deleteEntry(int id);
}