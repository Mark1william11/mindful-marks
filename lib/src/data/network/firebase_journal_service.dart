import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/database.dart';

class FirebaseJournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A helper to get a reference to the user's private "entries" collection.
  // Data is structured as /users/{userId}/entries/{entryId}
  CollectionReference<Map<String, dynamic>> _userEntriesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('entries');
  }

  /// Fetches all journal entries for a given user from Firestore.
  Future<List<Map<String, dynamic>>> getEntries(String userId) async {
    final snapshot = await _userEntriesCollection(userId).get();
    // Convert the documents to a list of maps.
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Saves or updates a single journal entry in Firestore for a specific user.
  Future<void> syncEntry(String userId, JournalEntry entry, List<String> tagNames) async {
    final entryMap = entry.toJson();
    // Also save the tags within the same document for easy retrieval.
    entryMap['tags'] = tagNames;
    
    // We use the local database ID as the document ID in Firestore.
    // This makes it easy to find and update the correct document.
    await _userEntriesCollection(userId).doc(entry.id.toString()).set(entryMap);
  }

  /// Deletes a single journal entry from Firestore for a specific user.
  Future<void> deleteEntry(String userId, int entryId) async {
    await _userEntriesCollection(userId).doc(entryId.toString()).delete();
  }
}