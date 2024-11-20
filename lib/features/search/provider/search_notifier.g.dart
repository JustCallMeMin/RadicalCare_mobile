// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchNotifierHash() => r'4c1e330e7634b08d67ba078ba0469c2cb947b36a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SearchNotifier
    extends BuildlessAutoDisposeAsyncNotifier<AsyncValue<List<Vehicle>>> {
  late final String keyword;

  FutureOr<AsyncValue<List<Vehicle>>> build(
    String keyword,
  );
}

/// See also [SearchNotifier].
@ProviderFor(SearchNotifier)
const searchNotifierProvider = SearchNotifierFamily();

/// See also [SearchNotifier].
class SearchNotifierFamily
    extends Family<AsyncValue<AsyncValue<List<Vehicle>>>> {
  /// See also [SearchNotifier].
  const SearchNotifierFamily();

  /// See also [SearchNotifier].
  SearchNotifierProvider call(
    String keyword,
  ) {
    return SearchNotifierProvider(
      keyword,
    );
  }

  @override
  SearchNotifierProvider getProviderOverride(
    covariant SearchNotifierProvider provider,
  ) {
    return call(
      provider.keyword,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchNotifierProvider';
}

/// See also [SearchNotifier].
class SearchNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SearchNotifier, AsyncValue<List<Vehicle>>> {
  /// See also [SearchNotifier].
  SearchNotifierProvider(
    String keyword,
  ) : this._internal(
          () => SearchNotifier()..keyword = keyword,
          from: searchNotifierProvider,
          name: r'searchNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchNotifierHash,
          dependencies: SearchNotifierFamily._dependencies,
          allTransitiveDependencies:
              SearchNotifierFamily._allTransitiveDependencies,
          keyword: keyword,
        );

  SearchNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
  }) : super.internal();

  final String keyword;

  @override
  FutureOr<AsyncValue<List<Vehicle>>> runNotifierBuild(
    covariant SearchNotifier notifier,
  ) {
    return notifier.build(
      keyword,
    );
  }

  @override
  Override overrideWith(SearchNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchNotifierProvider._internal(
        () => create()..keyword = keyword,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchNotifier,
      AsyncValue<List<Vehicle>>> createElement() {
    return _SearchNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchNotifierProvider && other.keyword == keyword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<AsyncValue<List<Vehicle>>> {
  /// The parameter `keyword` of this provider.
  String get keyword;
}

class _SearchNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SearchNotifier,
        AsyncValue<List<Vehicle>>> with SearchNotifierRef {
  _SearchNotifierProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchNotifierProvider).keyword;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
