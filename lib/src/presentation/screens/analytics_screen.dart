import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_marks/src/logic/providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodDataAsDouble = ref.watch(dailyMoodAverageProvider);
    final theme = Theme.of(context);
    final Map<DateTime, int> moodDataForHeatmap = moodDataAsDouble.map(
      (date, averageMood) => MapEntry(date, averageMood.round()),
    );

    final moodColors = {
      1: Colors.red.shade300,
      2: Colors.orange.shade300,
      3: Colors.grey.shade400,
      4: theme.colorScheme.primary.withOpacity(0.4),
      5: theme.colorScheme.primary.withOpacity(0.8),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Analytics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Year in Color',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Each square represents a day. The color shows the average mood of your entries for that day.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Now we pass the correctly typed map to the widget.
            if (moodDataForHeatmap.isNotEmpty)
              HeatMapCalendar(
                datasets: moodDataForHeatmap,
                colorsets: moodColors,
                defaultColor: Colors.grey.shade200,
                textColor: theme.colorScheme.onBackground,
                monthFontSize: 16,
                weekFontSize: 12,
                weekTextColor: Colors.grey.shade600,
                showColorTip: true,
                colorTipCount: 5,
                colorTipSize: 15,
                colorTipHelper: const [
                  Text('  Bad'),
                  Text('  Okay'),
                  Text('  Neutral'),
                  Text('  Good'),
                  Text('  Great'),
                ],
              )
            else
              // Show a helpful message if there's no data yet.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    'No mood data available.\nStart adding moods to your entries!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}