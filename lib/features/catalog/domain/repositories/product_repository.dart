import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit = 10, int skip = 0});
  Future<List<Product>> searchProducts(String query);
  Future<Product> getProductDetail(int id);
}
