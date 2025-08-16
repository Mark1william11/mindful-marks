// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'1afdae7fc15ec21816a06db65445019bfac0fe32';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$onboardingCompletionHash() =>
    r'0c50b16ab37bc1f2e92a6fb0cebc37ab8ff9da7a';

/// See also [OnboardingCompletion].
@ProviderFor(OnboardingCompletion)
final onboardingCompletionProvider =
    AutoDisposeNotifierProvider<OnboardingCompletion, bool>.internal(
  OnboardingCompletion.new,
  name: r'onboardingCompletionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingCompletionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnboardingCompletion = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
