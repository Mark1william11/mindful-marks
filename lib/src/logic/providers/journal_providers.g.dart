// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalRepositoryHash() => r'04974d02c665b0c83c18a24b75c9b6078696e791';

/// See also [journalRepository].
@ProviderFor(journalRepository)
final journalRepositoryProvider =
    AutoDisposeProvider<JournalRepository>.internal(
  journalRepository,
  name: r'journalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalRepositoryRef = AutoDisposeProviderRef<JournalRepository>;
String _$journalEntriesHash() => r'acbd806c2e7e3ce511c6e422014e326269ff164b';

/// See also [journalEntries].
@ProviderFor(journalEntries)
final journalEntriesProvider =
    AutoDisposeStreamProvider<List<JournalEntryWithTags>>.internal(
  journalEntries,
  name: r'journalEntriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalEntriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalEntriesRef
    = AutoDisposeStreamProviderRef<List<JournalEntryWithTags>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
