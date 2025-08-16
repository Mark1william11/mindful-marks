import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_marks/src/logic/providers/settings_providers.dart';

// Change to a ConsumerStatefulWidget
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // This function now calls the provider to update the application state.
  // The GoRouter redirect logic will handle the navigation automatically.
  Future<void> _completeOnboarding() async {
    await ref.read(onboardingCompletionProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                children: const [
                  OnboardingPage(
                      icon: Icons.article_outlined,
                      title: 'Welcome to Mindful Marks',
                      description:
                          'Your personal space to reflect, record, and grow. Jot down your thoughts and track your moods effortlessly.'),
                  OnboardingPage(
                      icon: Icons.local_florist_outlined,
                      title: 'Cultivate Your Digital Garden',
                      description:
                          'For every three entries you make, a new plant will grow. Watch your garden flourish as you build a consistent journaling habit.'),
                  OnboardingPage(
                      icon: Icons.bar_chart_outlined,
                      title: 'Discover Your Patterns',
                      description:
                          'Use the mood analytics to see your emotional trends over time. Gain valuable insights into your well-being.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(3, (index) => buildDot(index)),
                  ),
                  Animate(
                    effects: const [FadeEffect(), ScaleEffect()],
                    child: _currentPage == 2
                        ? ElevatedButton(
                            onPressed: _completeOnboarding, // Updated call
                            child: const Text('Get Started'),
                          )
                        : TextButton(
                            onPressed: () => _pageController.nextPage(
                                duration: 300.ms, curve: Curves.easeIn),
                            child: const Text('Next'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: 200.ms,
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(4)),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 120, color: theme.colorScheme.primary),
          const SizedBox(height: 48),
          Text(title,
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(description,
              style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ).animate().fade(duration: 500.ms).slideY(begin: 0.2, curve: Curves.easeOut),
    );
  }
}