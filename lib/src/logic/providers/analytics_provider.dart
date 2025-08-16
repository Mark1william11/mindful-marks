import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'journal_providers.dart';

part 'analytics_provider.g.dart';

// This provider calculates the average mood for each day that has entries.
// The result is a Map where the key is the date (at midnight) and the value
// is the average mood for that day (1.0 to 5.0).
@riverpod
Map<DateTime, double> dailyMoodAverage(DailyMoodAverageRef ref) {
  // Watch the journal entries provider to get all entries.
  final entries = ref.watch(journalEntriesProvider).value ?? [];
  if (entries.isEmpty) {
    return {};
  }

  // Group entries by the day they were created.
  // We use `groupBy` from the 'collection' package.
  final entriesByDay = groupBy(entries, (entry) {
    final createdAt = entry.entry.createdAt;
    // Normalize the date to midnight to ensure all entries from the same day
    // are grouped together, regardless of time.
    return DateTime(createdAt.year, createdAt.month, createdAt.day);
  });

  // Calculate the average mood for each day.
  final dailyAverages = entriesByDay.map((date, entriesOnDay) {
    final totalMood = entriesOnDay.fold<double>(0, (sum, entry) => sum + entry.entry.mood);
    final averageMood = totalMood / entriesOnDay.length;
    return MapEntry(date, averageMood);
  });

  return dailyAverages;
}