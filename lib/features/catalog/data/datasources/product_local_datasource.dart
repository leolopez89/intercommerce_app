import 'package:intercommerce_app/features/catalog/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts({int limit = 10, int skip = 0});
  Future<ProductModel?> getCachedProductDetail(int id);
}
