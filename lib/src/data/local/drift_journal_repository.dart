import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:mindful_marks/src/data/local/database.dart';
import 'package:mindful_marks/src/data/network/firebase_journal_service.dart';
import 'package:mindful_marks/src/logic/models/journal_entry_with_tags.dart';
import '../repositories/journal_repository.dart';

class DriftJournalRepository implements JournalRepository {
  final AppDatabase db;
  final FirebaseJournalService firebaseService;
  final String userId;

  DriftJournalRepository(this.db, this.firebaseService, this.userId) {
    // --- LOG 1: Check if the repository is being created with the correct User ID ---
    debugPrint("✅ [DIAGNOSTIC] DriftJournalRepository created for user: $userId");
    _syncFirebaseToLocal();
  }

  Future<void> _syncFirebaseToLocal() async {
    debugPrint("🔄 [DIAGNOSTIC] Starting sync from Firebase to local DB...");
    try {
      final cloudEntries = await firebaseService.getEntries(userId);
      // --- LOG 2: Check what data, if any, we are getting from Firebase ---
      debugPrint("🔍 [DIAGNOSTIC] Found ${cloudEntries.length} entries in Firestore.");

      if (cloudEntries.isEmpty) {
        debugPrint("✅ [DIAGNOSTIC] Sync complete. No entries to download.");
        return;
      }

      await db.transaction(() async {
        for (final entryMap in cloudEntries) {
          debugPrint("  -> [DIAGNOSTIC] Syncing down entry: ${entryMap['id']}");
          final entry = JournalEntry.fromJson(entryMap);
          final tagNames = List<String>.from(entryMap['tags'] ?? []);
          
          final entryCompanion = entry.toCompanion(true).copyWith(userId: Value(userId));
          await db.into(db.journalEntries).insert(entryCompanion, mode: InsertMode.insertOrIgnore);

          for (final name in tagNames) {
            await db.into(db.tags).insert(TagsCompanion.insert(name: name), mode: InsertMode.insertOrIgnore);
            final tag = await (db.select(db.tags)..where((t) => t.name.equals(name))).getSingle();
            await db.into(db.journalEntryTags).insert(
              JournalEntryTagsCompanion.insert(entryId: entry.id, tagId: tag.id),
              mode: InsertMode.insertOrIgnore,
            );
          }
        }
      });
      debugPrint("✅ [DIAGNOSTIC] Sync from Firebase to local DB FINISHED.");
    } catch (e, s) {
      // --- LOG 3: Catch any errors during the download process ---
      debugPrint("🔥 [DIAGNOSTIC] ERROR during sync-down: $e");
      debugPrint("   [DIAGNOSTIC] Stacktrace: $s");
    }
  }
  
  // (watchEntries method has no logs as it's purely local)
  @override
  Stream<List<JournalEntryWithTags>> watchEntries() {
    final query = db.select(db.journalEntries)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

    return query.watch().asyncMap((entries) async {
      if (entries.isEmpty) return [];
      final entryIds = entries.map((e) => e.id).toList();
      final tagsQuery = db.select(db.journalEntryTags).join([
        innerJoin(db.tags, db.tags.id.equalsExp(db.journalEntryTags.tagId)),
      ])..where(db.journalEntryTags.entryId.isIn(entryIds));
      final tagRows = await tagsQuery.get();
      final tagsByEntryId = <int, List<Tag>>{};
      for (final row in tagRows) {
        final tag = row.readTable(db.tags);
        final entryId = row.readTable(db.journalEntryTags).entryId;
        (tagsByEntryId[entryId] ??= []).add(tag);
      }
      return [
        for (final entry in entries)
          JournalEntryWithTags(entry: entry, tags: tagsByEntryId[entry.id] ?? [])
      ];
    });
  }

  @override
  Future<void> createOrUpdateEntry({
    required int? id,
    required String title,
    required String content,
    required List<String> tagNames,
    required int mood,
  }) {
    // --- LOG 4: Check if we are attempting to save an entry ---
    debugPrint("💾 [DIAGNOSTIC] Attempting to save entry locally. Title: $title");
    return db.transaction(() async {
      final entryId = await db.into(db.journalEntries).insert(
        JournalEntriesCompanion.insert(
          id: id != null ? Value(id) : const Value.absent(),
          title: title, content: content, mood: Value(mood),
          updatedAt: Value(DateTime.now()), userId: Value(userId),
        ),
        mode: InsertMode.insertOrReplace,
      );

      await (db.delete(db.journalEntryTags)..where((t) => t.entryId.equals(entryId))).go();
      for (final name in tagNames) { /* ... tag logic ... */ }

      try {
        final entryToSync = await (db.select(db.journalEntries)..where((t) => t.id.equals(entryId))).getSingle();
        // --- LOG 5: Check if we are attempting to sync the saved entry UP to Firebase ---
        debugPrint("📤 [DIAGNOSTIC] Syncing entry UP to Firestore. Entry ID: ${entryToSync.id}");
        await firebaseService.syncEntry(userId, entryToSync, tagNames);
        debugPrint("✅ [DIAGNOSTIC] Sync-up successful for entry ID: ${entryToSync.id}");
      } catch (e, s) {
        // --- LOG 6: Catch any errors during the upload process ---
        debugPrint("🔥 [DIAGNOSTIC] ERROR during sync-up: $e");
        debugPrint("   [DIAGNOSTIC] Stacktrace: $s");
      }
    });
  }

  @override
  Future<void> deleteEntry(int id) async {
    // --- LOG 7: Check if we are deleting an entry ---
    debugPrint("🗑️ [DIAGNOSTIC] Deleting entry locally. ID: $id");
    await (db.delete(db.journalEntries)..where((t) => t.id.equals(id) & t.userId.equals(userId))).go();
    try {
      debugPrint("🗑️ [DIAGNOSTIC] Deleting entry from Firestore. ID: $id");
      await firebaseService.deleteEntry(userId, id);
    } catch (e) {
       debugPrint("🔥 [DIAGNOSTIC] ERROR during Firestore delete: $e");
    }
  }
}