import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('JournalEntry')
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get content => text()();
  IntColumn get mood => integer().withDefault(const Constant(3))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  // ADD THIS LINE
  TextColumn get userId => text().nullable()();
}

@DataClassName('Tag')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
}

class JournalEntryTags extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  @override
  Set<Column> get primaryKey => {entryId, tagId};
}

class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().nullable()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
}

@DriftDatabase(tables: [UserSettings, JournalEntries, Tags, JournalEntryTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // INCREMENT THE VERSION
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.drop(journalEntryTags);
          await m.drop(journalEntries);
          await m.drop(tags);
          await m.createAll();
        }
        if (from < 3) {
          await m.addColumn(journalEntries, journalEntries.mood);
        }
        // ADD THIS MIGRATION BLOCK
        if (from < 4) {
          await m.addColumn(journalEntries, journalEntries.userId);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}