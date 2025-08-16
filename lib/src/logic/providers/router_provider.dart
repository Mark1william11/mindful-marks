import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_marks/src/presentation/screens/forgot_password_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mindful_marks/src/logic/models/journal_entry_with_tags.dart';
import 'package:mindful_marks/src/presentation/screens/auth_screen.dart';
import 'package:mindful_marks/src/presentation/screens/create_edit_entry_screen.dart';
import 'package:mindful_marks/src/presentation/screens/digital_garden_screen.dart';
import 'package:mindful_marks/src/presentation/screens/home_screen.dart';
import 'package:mindful_marks/src/presentation/screens/journal_feed_screen.dart';
import 'package:mindful_marks/src/presentation/screens/onboarding_screen.dart';
import 'package:mindful_marks/src/presentation/screens/settings_screen.dart';
import 'package:mindful_marks/src/presentation/screens/splash_screen.dart';
import 'package:mindful_marks/src/presentation/screens/analytics_screen.dart';
import 'package:mindful_marks/src/presentation/screens/terms_of_service_screen.dart';
import 'package:mindful_marks/src/presentation/screens/privacy_policy_screen.dart';
import 'auth_providers.dart';
import 'settings_providers.dart';

part 'router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  // Listen to the providers that determine navigation state.
  // The ValueNotifier is a simple Listenable that we can manually trigger.
  final listenable = ValueNotifier<int>(0);
  ref.listen(authStateChangesProvider, (_, __) => listenable.value++);
  ref.listen(onboardingCompletionProvider, (_, __) => listenable.value++);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash', // Always start at splash to determine state.
    refreshListenable: listenable,
    redirect: (context, state) {
      // Get the latest state of our providers inside the redirect.
      final authState = ref.watch(authStateChangesProvider);
      final onboardingComplete = ref.watch(onboardingCompletionProvider);
      final location = state.matchedLocation;

      // 1. If authentication state is loading, always show the splash screen.
      if (authState.isLoading) {
        return '/splash';
      }

      // 2. Handle onboarding as the next priority. If it's not complete,
      // the user must be sent to/allowed to stay on the onboarding screen.
      if (!onboardingComplete) {
        return location == '/onboarding' ? null : '/onboarding';
      }

      // 3. Once onboarding is complete, handle authentication.
      final isLoggedIn = authState.valueOrNull != null;
      final isOnAuthScreen = location == '/auth';

      if (isLoggedIn) {
        // If the user is logged in and currently on the auth or splash screen,
        // redirect them to the main journal feed.
        if (isOnAuthScreen || location == '/splash') {
          return '/journal';
        }
      } else {
        // If the user is not logged in, they must be on the auth screen.
        // If they are anywhere else, redirect them.
        if (!isOnAuthScreen) {
          return '/auth';
        }
      }

      // 4. If none of the above conditions apply, no redirect is needed.
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const LoadingScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/terms-of-service', builder: (context, state) => const TermsOfServiceScreen()),
      GoRoute(path: '/privacy-policy', builder: (context, state) => const PrivacyPolicyScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalFeedScreen())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/garden',
                builder: (context, state) => const DigitalGardenScreen())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen())
          ]),
        ],
      ),
      GoRoute(
        path: '/create-entry',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final entry = state.extra as JournalEntryWithTags?;
          return MaterialPage(
              child: CreateEditEntryScreen(entryWithTags: entry),
              fullscreenDialog: true);
        },
      ),
      GoRoute(
        path: '/analytics',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AnalyticsScreen(),
      ),
    ],
  );
}