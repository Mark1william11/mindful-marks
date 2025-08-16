import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindful_marks/src/logic/models/journal_entry_with_tags.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({super.key, required this.entryWithTags});

  final JournalEntryWithTags entryWithTags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = entryWithTags.entry;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to the edit screen, passing the object as 'extra'.
          context.push('/create-entry', extra: entryWithTags);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: theme.textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    // We use the 'intl' package for nice date formatting.
                    DateFormat.yMMMd().format(entry.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
        
              // --- Content Snippet ---
              Text(
                entry.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
        
              // --- Tags ---
              if (entryWithTags.tags.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: entryWithTags.tags.map((tag) {
                    return Chip(
                      label: Text(tag.name),
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      labelStyle: TextStyle(color: theme.colorScheme.primary),
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}