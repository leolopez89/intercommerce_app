import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int limit = 10,
    int skip = 0,
  });
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, Product>> getProductDetail(int id);
}
