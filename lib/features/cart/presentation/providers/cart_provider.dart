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
    final savedItems = (await sl<GetCartItemsUseCase>()()).fold(
      (failure) => throw failure,
      (items) => items,
    );

    if (savedItems.isEmpty) {
      return CartState();
    }

    List<CartItem> itemsList = [];
    final producDetails = sl<GetProductDetailUseCase>();

    for (var entry in savedItems.entries) {
      final product = (await producDetails(
        entry.key,
      )).fold((failure) => throw failure, (p) => p);

      itemsList.add(CartItem(product: product, quantity: entry.value));
    }

    final summary = sl<CalculateCartSummaryUsecase>()(itemsList);
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

    final summary = sl<CalculateCartSummaryUsecase>()(items);

    final result = await sl<AddProductToCartUseCase>()(product.id, newQuantity);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        throw failure;
      },
      (_) {
        state = AsyncData(
          currentState.copyWith(
            items: items,
            summary: summary,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> decrementItem(Product product) async {
    final currentState = state.value ?? CartState(items: []);
    state = AsyncData(currentState.copyWith(isLoading: true));

    final index = currentState.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index < 0) {
      state = AsyncData(currentState.copyWith(isLoading: false));
      return;
    }

    final items = [...currentState.items];
    final currentItem = items[index];
    final newQuantity = currentItem.quantity - 1;

    if (newQuantity <= 0) {
      final itemsUpdated = items
          .where((item) => item.product.id != product.id)
          .toList();
      final summary = itemsUpdated.isEmpty
          ? null
          : sl<CalculateCartSummaryUsecase>()(itemsUpdated);

      final result = await sl<RemoveProductFromCartUseCase>()(product.id);

      result.fold(
        (failure) {
          state = AsyncError(failure, StackTrace.current);
          throw failure;
        },
        (_) {
          state = AsyncData(
            currentState.copyWith(
              items: itemsUpdated,
              summary: summary,
              isLoading: false,
            ),
          );
        },
      );
      return;
    }

    items[index] = currentItem.copyWith(quantity: newQuantity);
    final summary = sl<CalculateCartSummaryUsecase>()(items);

    final result = await sl<AddProductToCartUseCase>()(product.id, newQuantity);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        throw failure;
      },
      (_) {
        state = AsyncData(
          currentState.copyWith(
            items: items,
            summary: summary,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> removeItem(int productId) async {
    final currentState = state.value ?? CartState(items: []);
    state = AsyncData(currentState.copyWith(isLoading: true));

    final itemsUpdated = currentState.items
        .where((item) => item.product.id != productId)
        .toList();

    final summary = itemsUpdated.isEmpty
        ? null
        : sl<CalculateCartSummaryUsecase>()(itemsUpdated);

    final result = await sl<RemoveProductFromCartUseCase>()(productId);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        throw failure;
      },
      (_) {
        state = AsyncData(
          currentState.copyWith(
            items: itemsUpdated,
            summary: summary,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> clearCart() async {
    final currentState = state.value ?? CartState(items: []);
    state = AsyncData(currentState.copyWith(isLoading: true));

    final result = await sl<ClearCartItemsUseCase>()();

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        throw failure;
      },
      (_) {
        state = const AsyncData(
          CartState(items: [], summary: null, isLoading: false),
        );
      },
    );
  }
}
