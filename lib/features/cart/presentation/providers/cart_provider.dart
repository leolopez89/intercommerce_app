import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/calculate_cart_summary_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/clear_cart_items_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/remove_product_from_cart_usecase.dart';
import 'package:intercommerce_app/features/cart/presentation/providers/state/cart_state.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/product_detail/domain/usecases/get_product_detail_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  Future<CartState> build() async {
    final savedItems = (await sl<GetCartItemsUseCase>().execute()).fold(
      (failure) => throw failure,
      (items) => items,
    );

    if (savedItems.isEmpty) {
      return CartState();
    }

    List<CartItem> itemsList = [];
    final producDetails = sl<GetProductDetailUseCase>();

    for (var entry in savedItems.entries) {
      final product = (await producDetails.execute(
        entry.key,
      )).fold((failure) => throw failure, (p) => p);

      itemsList.add(CartItem(product: product, quantity: entry.value));
    }

    final summary = sl<CalculateCartSummaryUsecase>().execute(itemsList);
    return CartState(items: itemsList, summary: summary);
  }

  Future<void> addItem(Product product) async {
    final currentState = state.value ?? CartState(items: []);
    state = AsyncData(currentState.copyWith(isLoading: true));

    final items = [...currentState.items];
    final index = items.indexWhere((item) => item.product.id == product.id);

    int newQuantity = 1;

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      newQuantity = items[index].quantity;
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }

    state = AsyncData(currentState.copyWith(items: items, isLoading: false));

    (await sl<AddProductToCartUseCase>().execute(
      product.id,
      newQuantity,
    )).fold((failure) => throw failure, (_) {});
  }

  Future<void> removeItem(int productId) async {
    final currentState = state.value ?? CartState(items: []);
    state = AsyncData(currentState.copyWith(isLoading: true));

    final itemsUpdated = currentState.items
        .where((item) => item.product.id != productId)
        .toList();

    state = AsyncData(
      currentState.copyWith(items: itemsUpdated, isLoading: false),
    );

    final result = await sl<RemoveProductFromCartUseCase>().execute(productId);
    result.fold((failure) => throw failure, (_) {});
  }

  Future<void> clearCart() async {
    state = const AsyncData(CartState(items: []));

    final result = await sl<ClearCartItemsUseCase>().execute();
    result.fold((failure) => throw failure, (_) {});
  }
}
