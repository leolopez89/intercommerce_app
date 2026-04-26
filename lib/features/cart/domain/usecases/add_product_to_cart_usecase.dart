import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';

class AddProductToCartUseCase {
  final CartRepository repository;
  AddProductToCartUseCase(this.repository);

  Future<Either<Failure, void>> execute(int productId, int quantity) async {
    return await repository.addOrUpdateItem(productId, quantity);
  }
}
