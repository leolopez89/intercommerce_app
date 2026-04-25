import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:intercommerce_app/features/cart/domain/logic/cart_calculator.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  late final CartLocalDataSource _localDataSource;
  late final ProductRepository _productRepository;

  @override
  Future<List<CartItem>> build() async {
    _localDataSource = sl<CartLocalDataSource>();
    _productRepository = sl<ProductRepository>();

    final savedItems = await _localDataSource.getCartItems();
    if (savedItems.isEmpty) return [];

    List<CartItem> items = [];

    for (var entry in savedItems.entries) {
      try {
        final product = await _productRepository.getProductDetail(entry.key);
        items.add(CartItem(product: product, quantity: entry.value));
      } catch (_) {
        // Manejar error si el producto ya no existe
      }
    }
    return items;
  }

  Future<void> addItem(Product product) async {
    final currentState = state.value ?? [];
    final index = currentState.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> newState;
    int newQuantity = 1;

    if (index >= 0) {
      newQuantity = currentState[index].quantity + 1;
      newState = [...currentState];
      newState[index] = CartItem(product: product, quantity: newQuantity);
    } else {
      newState = [...currentState, CartItem(product: product)];
    }

    state = AsyncData(newState);
    await _localDataSource.saveCartItem(product.id, newQuantity);
  }

  Future<void> removeItem(int productId) async {
    final currentState = state.value ?? [];
    state = AsyncData(
      currentState.where((item) => item.product.id != productId).toList(),
    );
    await _localDataSource.removeCartItem(productId);
  }
}

@riverpod
Map<String, double> cartTotals(CartTotalsRef ref) {
  final cartAsync = ref.watch(cartProvider);
  final items = cartAsync.value ?? [];

  final calculator = CartCalculator();

  final subtotal = calculator.calculateSubtotal(items);
  final tax = calculator.calculateTax(subtotal);
  final total = calculator.calculateTotal(subtotal, tax);

  return {'subtotal': subtotal, 'tax': tax, 'total': total};
}
