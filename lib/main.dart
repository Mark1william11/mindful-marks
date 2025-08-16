import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'src/logic/providers/router_provider.dart';
import 'src/logic/providers/settings_providers.dart';
import 'src/presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load SharedPreferences before the app starts.
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [
        // Override the sharedPreferencesProvider with the instance we just loaded.
        // This makes it available synchronously to all other providers.
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MindfulMarksApp(),
    ),
  );
}

class MindfulMarksApp extends ConsumerWidget {
  const MindfulMarksApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The router provider now manages its own dependencies internally.
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Mindful Marks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}