import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_marks/src/logic/providers/auth_providers.dart';
import 'package:mindful_marks/src/presentation/widgets/loading_overlay.dart';

// Enum to define the two modes of the screen
enum AuthMode { login, signup }

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for managing local UI state
    final authMode = useState(AuthMode.login);
    final isLoading = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // Helper function to handle the submission logic
    Future<void> submit() async {
      // First, validate the form.
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        try {
          // Depending on the mode, call the appropriate repository method.
          if (authMode.value == AuthMode.login) {
            await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
          } else {
            await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
          }
          // If successful, the GoRouter redirect will handle navigation.
          // We don't need to manually pop the screen here.
        } on FirebaseAuthException catch (e) {
          // If an error occurs, show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'An unknown error occurred.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } finally {
          // Ensure the loading indicator is always turned off.
          isLoading.value = false;
        }
      }
    }

    final theme = Theme.of(context);
    final isLogin = authMode.value == AuthMode.login;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Mindful Marks',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLogin ? 'Welcome back.' : 'Create your account.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: buttonStyle, 
                    onPressed: submit,
                    child: Text(isLogin ? 'Login' : 'Sign Up'),
                  ),
                  TextButton(
                    onPressed: () {
                      authMode.value = isLogin ? AuthMode.signup : AuthMode.login;
                    },
                    child: Text(
                      isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}