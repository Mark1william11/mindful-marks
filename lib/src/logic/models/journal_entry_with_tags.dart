import '../../data/local/database.dart';

// This is a custom data class that is not part of the database.
// Its purpose is to combine a JournalEntry with its associated list of Tags
// into a single, convenient object for use in the UI and business logic layers.
class JournalEntryWithTags {
  final JournalEntry entry;
  final List<Tag> tags;

  JournalEntryWithTags({
    required this.entry,
    required this.tags,
  });
}