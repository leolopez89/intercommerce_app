import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<Either<Failure, Map<int, int>>> call() async {
    return await repository.getCart();
  }
}
