import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_marks/src/logic/models/journal_entry_with_tags.dart';
import 'package:mindful_marks/src/logic/providers/journal_providers.dart';
import 'package:mindful_marks/src/presentation/widgets/loading_overlay.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CreateEditEntryScreen extends HookConsumerWidget {
  final JournalEntryWithTags? entryWithTags;

  const CreateEditEntryScreen({super.key, this.entryWithTags});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final entry = entryWithTags?.entry;
    final selectedMood = useState(entry?.mood ?? 3);
    
    final titleController = useTextEditingController(text: entry?.title);
    final contentController = useTextEditingController(text: entry?.content);
    // Pre-fill tags by joining them with a comma and space
    final tagsController = useTextEditingController(
      text: entryWithTags?.tags.map((t) => t.name).join(', '),
    );
    
    final isLoading = useState(false);

    Future<void> saveEntry() async {
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        
        final tagNames = tagsController.text
            .split(',')
            .map((s) => s.trim().toLowerCase()) // Standardize tags to lowercase
            .where((s) => s.isNotEmpty)
            .toSet() // Use a Set to automatically handle duplicates
            .toList();

        try {
          await ref.read(journalRepositoryProvider).createOrUpdateEntry(
                id: entry?.id,
                title: titleController.text,
                content: contentController.text,
                tagNames: tagNames,
                mood: selectedMood.value,
              );
          context.pop();
        } catch (e) {
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving entry: $e'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      }
    }

    Widget buildMoodSelector() {
      // A list of icons and colors representing moods 1 through 5.
      final List<IconData> moodIcons = [
        Icons.sentiment_very_dissatisfied,
        Icons.sentiment_dissatisfied,
        Icons.sentiment_neutral,
        Icons.sentiment_satisfied,
        Icons.sentiment_very_satisfied,
      ];
      final List<Color> moodColors = [
        Colors.red,
        Colors.orange,
        Colors.grey,
        Colors.lightGreen,
        Colors.green,
      ];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final moodValue = index + 1;
            final isSelected = selectedMood.value == moodValue;
            return GestureDetector(
              onTap: () {
                selectedMood.value = moodValue;
                HapticFeedback.lightImpact(); // Add a nice little vibration
              },
              child: AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? moodColors[index].withOpacity(0.2) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  moodIcons[index],
                  size: isSelected ? 40 : 32,
                  color: moodColors[index],
                ),
              ),
            );
          }),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(entry == null ? 'Create Entry' : 'Edit Entry'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.check_circle_outline, size: 28),
              tooltip: 'Save Entry',
              onPressed: saveEntry,
            ),
          )
        ],
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildMoodSelector(),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        style: theme.textTheme.displaySmall,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Title',
                          hintStyle: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.4),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Title cannot be empty.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: contentController,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Start writing your thoughts here...',
                          hintStyle: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          ),
                        ),
                        maxLines: null,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Content cannot be empty.' : null,
                      ),
                    ],
                  ),
                ),
              ),
              // --- Tags Input Area at the Bottom ---
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: TextFormField(
                  controller: tagsController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.label_outline, color: theme.colorScheme.primary),
                    labelText: 'Tags (comma-separated)',
                    hintText: 'work, creative, personal',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}