import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mindful_marks/src/logic/models/plant.dart';
import 'journal_providers.dart';

part 'garden_provider.g.dart';

// This provider will transform the list of journal entries into a list of Plants.
@riverpod
List<Plant> gardenPlants(GardenPlantsRef ref) {
  // Watch the journal entries provider. This provider will re-run whenever the entries change.
  final entries = ref.watch(journalEntriesProvider).value ?? [];
  if (entries.isEmpty) {
    return [];
  }

  // --- Garden Growth Logic ---
  // This is where we define the rules of our garden.
  // We can make this as simple or complex as we want.

  // Rule 1: One plant for every 3 entries.
  final plantCount = (entries.length / 3).ceil();

  // Rule 2: Find the most recent entry date to determine overall garden vibrancy.
  final now = DateTime.now();
  final mostRecentEntry = entries.first; // Entries are sorted descending by date
  final daysSinceLastEntry = now.difference(mostRecentEntry.entry.createdAt).inDays;
  
  // Rule 3: Vibrancy decreases the longer it's been since the last entry.
  // It's 1.0 (fully vibrant) for today, and decays over a week.
  final double baseVibrancy = (1.0 - (daysSinceLastEntry / 7.0)).clamp(0.2, 1.0);

  final List<Plant> plants = [];
  for (int i = 0; i < plantCount; i++) {
    plants.add(
      Plant(
        // Growth is full for all but potentially the last plant.
        growth: 1.0, 
        // All plants share the same vibrancy based on recent activity.
        vibrancy: baseVibrancy,
      ),
    );
  }

  return plants;
}