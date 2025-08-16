import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

// This provider is designed to be overridden in main.dart with the
// pre-loaded SharedPreferences instance.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('The SharedPreferences provider must be overridden');
}

// This notifier manages the onboarding completion state.
// The router will watch this provider to make navigation decisions.
@riverpod
class OnboardingCompletion extends _$OnboardingCompletion {
  @override
  bool build() {
    // Read the initial value from SharedPreferences.
    return ref.watch(sharedPreferencesProvider).getBool('hasSeenOnboarding') ?? false;
  }

  // This method updates the state and persists it to local storage.
  Future<void> completeOnboarding() async {
    await ref.read(sharedPreferencesProvider).setBool('hasSeenOnboarding', true);
    // Update the in-memory state, which will notify all listeners (like the router).
    state = true;
  }
}