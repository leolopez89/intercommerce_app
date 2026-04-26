import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';

class ClearCartItemsUseCase {
  final CartRepository repository;

  ClearCartItemsUseCase(this.repository);

  Future<Either<Failure, void>> execute() async {
    return await repository.clearCart();
  }
}
