// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartTotalsHash() => r'34e42c5f79fde2ea9b1ec8f312ce7712b859ffe4';

/// See also [cartTotals].
@ProviderFor(cartTotals)
final cartTotalsProvider = AutoDisposeProvider<Map<String, double>>.internal(
  cartTotals,
  name: r'cartTotalsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartTotalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalsRef = AutoDisposeProviderRef<Map<String, double>>;
String _$cartHash() => r'59e0d5bae421a59892f8e11fd95c4fd4d1b24846';

/// See also [Cart].
@ProviderFor(Cart)
final cartProvider = AsyncNotifierProvider<Cart, List<CartItem>>.internal(
  Cart.new,
  name: r'cartProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Cart = AsyncNotifier<List<CartItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
