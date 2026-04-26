import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, Map<int, int>>> getCart();
  Future<Either<Failure, void>> addOrUpdateItem(int productId, int quantity);
  Future<Either<Failure, void>> removeItem(int productId);
}
