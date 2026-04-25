import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> execute({int limit = 10, int skip = 0}) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}
