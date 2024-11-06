// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productCategoryHash() => r'd4a1903fe5abc91994693a6bba369df996bea256';

/// See also [ProductCategory].
@ProviderFor(ProductCategory)
final productCategoryProvider =
    AutoDisposeNotifierProvider<ProductCategory, String>.internal(
  ProductCategory.new,
  name: r'productCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductCategory = AutoDisposeNotifier<String>;
String _$productNotifierHash() => r'bfb29e440464aa06151b88b5a1d5dc6760a31728';

/// See also [ProductNotifier].
@ProviderFor(ProductNotifier)
final productNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProductNotifier, List<Vehicle>>.internal(
  ProductNotifier.new,
  name: r'productNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductNotifier = AutoDisposeAsyncNotifier<List<Vehicle>>;
String _$productPageHash() => r'a17f55c4f5d3fdd7d2564d4f621bbc04394a42e0';

/// See also [ProductPage].
@ProviderFor(ProductPage)
final productPageProvider =
    AutoDisposeNotifierProvider<ProductPage, int>.internal(
  ProductPage.new,
  name: r'productPageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productPageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductPage = AutoDisposeNotifier<int>;
String _$productDetailNotifierHash() =>
    r'c74dd66bfa0e2af0f35c50cbae89faa578b108c5';

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

abstract class _$ProductDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Vehicle> {
  late final String productId;

  FutureOr<Vehicle> build(
    String productId,
  );
}

/// See also [ProductDetailNotifier].
@ProviderFor(ProductDetailNotifier)
const productDetailNotifierProvider = ProductDetailNotifierFamily();

/// See also [ProductDetailNotifier].
class ProductDetailNotifierFamily extends Family<AsyncValue<Vehicle>> {
  /// See also [ProductDetailNotifier].
  const ProductDetailNotifierFamily();

  /// See also [ProductDetailNotifier].
  ProductDetailNotifierProvider call(
    String productId,
  ) {
    return ProductDetailNotifierProvider(
      productId,
    );
  }

  @override
  ProductDetailNotifierProvider getProviderOverride(
    covariant ProductDetailNotifierProvider provider,
  ) {
    return call(
      provider.productId,
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
  String? get name => r'productDetailNotifierProvider';
}

/// See also [ProductDetailNotifier].
class ProductDetailNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ProductDetailNotifier,
        Vehicle> {
  /// See also [ProductDetailNotifier].
  ProductDetailNotifierProvider(
    String productId,
  ) : this._internal(
          () => ProductDetailNotifier()..productId = productId,
          from: productDetailNotifierProvider,
          name: r'productDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDetailNotifierHash,
          dependencies: ProductDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProductDetailNotifierFamily._allTransitiveDependencies,
          productId: productId,
        );

  ProductDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  FutureOr<Vehicle> runNotifierBuild(
    covariant ProductDetailNotifier notifier,
  ) {
    return notifier.build(
      productId,
    );
  }

  @override
  Override overrideWith(ProductDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailNotifierProvider._internal(
        () => create()..productId = productId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductDetailNotifier, Vehicle>
      createElement() {
    return _ProductDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailNotifierProvider &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductDetailNotifierRef on AutoDisposeAsyncNotifierProviderRef<Vehicle> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductDetailNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProductDetailNotifier,
        Vehicle> with ProductDetailNotifierRef {
  _ProductDetailNotifierProviderElement(super.provider);

  @override
  String get productId => (origin as ProductDetailNotifierProvider).productId;
}

String _$imageNotifierHash() => r'01cdd440c4d154bcc9b15b7ecc58b9ca0fb49a21';

/// See also [ImageNotifier].
@ProviderFor(ImageNotifier)
final imageNotifierProvider =
    AutoDisposeNotifierProvider<ImageNotifier, int>.internal(
  ImageNotifier.new,
  name: r'imageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$imageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ImageNotifier = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
