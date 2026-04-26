import 'dart:async';

import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/get_products_usecase.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/search_products_usecase.dart';
import 'package:intercommerce_app/features/catalog/presentation/providers/state/catalog_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_provider.g.dart';

@riverpod
class Catalog extends _$Catalog {
  final int _limit = 10;
  Timer? _debounce;

  @override
  Future<CatalogState> build() async {
    ref.onDispose(() => _debounce?.cancel());

    final products = await _fetchProducts(query: '', skip: 0);
    return CatalogState(products: products);
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value ?? CatalogState();

    if (currentState.isFetching ||
        !currentState.hasMore ||
        currentState.query.isNotEmpty) {
      return;
    }

    state = AsyncData(currentState.copyWith(isFetching: true));

    final nextSkip = currentState.skip + _limit;

    try {
      final nextProducts = await _fetchProducts(
        query: currentState.query,
        skip: nextSkip,
      );

      state = AsyncData(
        currentState.copyWith(
          products: [...currentState.products, ...nextProducts],
          skip: nextSkip,
          isFetching: false,
          hasMore: nextProducts.isNotEmpty,
        ),
      );
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> search(String query) async {
    final currentState = state.value ?? CatalogState();

    if (currentState.query == query) return;

    _debounce?.cancel();

    if (query.isEmpty) {
      ref.invalidateSelf();

      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      state = AsyncData(
        currentState.copyWith(
          isFetching: true,
          query: query,
          products: [],
          skip: 0,
        ),
      );

      try {
        final products = await _fetchProducts(query: query, skip: 0);

        state = AsyncData(
          CatalogState(
            products: products,
            query: query,
            skip: 0,
            isFetching: false,
            hasMore: false,
          ),
        );
      } catch (e, stack) {
        state = AsyncError(e, stack);
      }
    });
  }

  Future<List<Product>> _fetchProducts({
    required String query,
    required int skip,
  }) async {
    if (query.isNotEmpty == true) {
      final result = (await sl<SearchProductsUseCase>()(query));
      return result.fold((failure) => throw failure, (products) => products);
    }

    final result = (await sl<GetProductsUseCase>()(limit: _limit, skip: skip));
    return result.fold((failure) => throw failure, (products) => products);
  }
}
