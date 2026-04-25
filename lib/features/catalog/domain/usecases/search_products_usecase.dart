import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository repository;
  SearchProductsUseCase(this.repository);

  Future<List<Product>> execute(String query) =>
      repository.searchProducts(query);
}
