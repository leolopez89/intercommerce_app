import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/get_products_usecase.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/search_products_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_provider.g.dart';

@riverpod
class Catalog extends _$Catalog {
  final int _limit = 10;

  int _skip = 0;
  bool _hasMore = true;
  String _currentQuery = '';
  bool _isFetching = false;

  @override
  Future<List<Product>> build() async {
    return _fetchProducts();
  }

  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore && _currentQuery.isEmpty;

  Future<List<Product>> _fetchProducts() async {
    _skip = 0;
    _hasMore = true;
    final getProducts = sl<GetProductsUseCase>();

    if (_currentQuery.isNotEmpty) {
      return (await sl<SearchProductsUseCase>().execute(
        _currentQuery,
      )).fold((failure) => throw failure, (products) => products);
    }

    return (await getProducts.execute(
      limit: _limit,
      skip: _skip,
    )).fold((failure) => throw failure, (products) => products);
  }

  Future<void> fetchNextPage() async {
    if (_isFetching || !_hasMore || _currentQuery.isNotEmpty) return;

    _isFetching = true;
    final getProducts = sl<GetProductsUseCase>();
    _skip += _limit;

    final nextProducts = (await getProducts.execute(
      limit: _limit,
      skip: _skip,
    )).fold((failure) => throw failure, (products) => products);

    if (nextProducts.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...state.value ?? [], ...nextProducts]);
    }

    _isFetching = false;
  }

  void search(String query) {
    _currentQuery = query;
    ref.invalidateSelf();
  }
}
