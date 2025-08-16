import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_marks/src/logic/providers/journal_providers.dart';
import 'package:mindful_marks/src/presentation/widgets/journal_entry_card.dart';

class JournalFeedScreen extends ConsumerWidget {
  const JournalFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsyncValue = ref.watch(journalEntriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        centerTitle: true,
      ),
      body: entriesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_note_outlined, size: 80, color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      'Your journal is empty.',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the "+" button to create your first entry and start your journey.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: 500.ms).scale(delay: 200.ms);
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entryWithTags = entries[index];
              return Dismissible(
                key: ValueKey(entryWithTags.entry.id),
                onDismissed: (_) {
                  // Temporarily store the deleted item in case of undo.
                  final deletedEntry = entryWithTags;

                  // Perform the deletion from the database.
                  ref.read(journalRepositoryProvider).deleteEntry(deletedEntry.entry.id);

                  // Clear any previous SnackBars.
                  ScaffoldMessenger.of(context).clearSnackBars();

                  // Show a SnackBar with a functional UNDO action.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Entry deleted.'),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          // CORRECTED: Call the existing createOrUpdateEntry method
                          // with the data from the deleted entry.
                          ref.read(journalRepositoryProvider).createOrUpdateEntry(
                                id: deletedEntry.entry.id,
                                title: deletedEntry.entry.title,
                                content: deletedEntry.entry.content,
                                mood: deletedEntry.entry.mood,
                                tagNames: deletedEntry.tags.map((tag) => tag.name).toList(),
                              );
                        },
                      ),
                    ),
                  );
                },
                background: Container(
                  color: theme.colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                ),
                child: JournalEntryCard(entryWithTags: entryWithTags),
              ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-entry'),
        tooltip: 'Create new journal entry', 
        child: const Icon(Icons.add),
      ),
    );
  }
}