import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_marks/src/logic/providers/garden_provider.dart';
import 'package:mindful_marks/src/presentation/widgets/plant_widget.dart';

class DigitalGardenScreen extends ConsumerWidget {
  const DigitalGardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is the crucial line that was missing.
    // It watches the provider for the list of plants.
    final plants = ref.watch(gardenPlantsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Garden'),
        centerTitle: true,
      ),
      // This logic checks if the list of plants is empty.
      body: plants.isEmpty
          // --- If it's empty, it shows our NEW empty state message ---
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.grass_outlined, size: 80, color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      'Your garden is waiting to grow.',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A new plant will appear for every three journal entries you make. Start writing to cultivate your garden!',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: 500.ms)
          // --- If it's NOT empty, it shows the GridView with the plants ---
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return PlantWidget(plant: plant)
                    .animate()
                    .fade(delay: (200 * index).ms, duration: 500.ms)
                    .slideY(begin: 0.5, curve: Curves.easeOut);
              },
            ),
    );
  }
}