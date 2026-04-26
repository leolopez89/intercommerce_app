import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:intercommerce_app/features/cart/domain/logic/cart_calculator.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/remove_product_from_cart_usecase.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/product_detail/domain/usecases/get_product_detail_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  Future<List<CartItem>> build() async {
    final savedItems = (await sl<GetCartItemsUseCase>().execute()).fold(
      (failure) => throw failure,
      (items) => items,
    );
    final producDetails = sl<GetProductDetailUseCase>();

    if (savedItems.isEmpty) {
      return [];
    }

    List<CartItem> itemsList = [];

    for (var entry in savedItems.entries) {
      final product = (await producDetails.execute(
        entry.key,
      )).fold((failure) => throw failure, (p) => p);

      itemsList.add(CartItem(product: product, quantity: entry.value));
    }

    return itemsList;
  }

  Future<void> addItem(Product product) async {
    final currentState = await future;
    final index = currentState.indexWhere(
      (item) => item.product.id == product.id,
    );

    int newQuantity = 1;

    if (index >= 0) {
      newQuantity = currentState[index].quantity + 1;
    }

    (await sl<AddProductToCartUseCase>().execute(
      product.id,
      newQuantity,
    )).fold((failure) => throw failure, (_) {});

    ref.invalidateSelf();
  }

  Future<void> removeItem(int productId) async {
    final currentState = state.value ?? [];
    state = AsyncData(
      currentState.where((item) => item.product.id != productId).toList(),
    );
    final result = await sl<RemoveProductFromCartUseCase>().execute(productId);
    result.fold((failure) => throw failure, (_) {});
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
