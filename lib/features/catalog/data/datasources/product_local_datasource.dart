import 'package:intercommerce_app/features/catalog/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
}
