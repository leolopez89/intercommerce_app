import 'package:intercommerce_app/features/catalog/data/datasources/product_local_datasource.dart';
import 'package:intercommerce_app/features/catalog/data/datasources/product_remote_datasource.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts({int limit = 10, int skip = 0}) async {
    try {
      final remoteProducts = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );

      await localDataSource.cacheProducts(remoteProducts);

      return remoteProducts.map((m) => m.toEntity()).toList();
    } catch (e) {
      final localProducts = await localDataSource.getCachedProducts();

      if (localProducts.isNotEmpty) {
        return localProducts.map((m) => m.toEntity()).toList();
      }

      rethrow;
    }
  }

  @override
  Future<Product> getProductDetail(int id) async {
    // Implementar después con el datasource
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // Implementar después con el datasource
    throw UnimplementedError();
  }
}
