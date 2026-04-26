import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveProductFromCartUseCase {
  final CartRepository cartRepository;

  RemoveProductFromCartUseCase(this.cartRepository);

  Future<Either<Failure, void>> call(int productId) async {
    return await cartRepository.removeItem(productId);
  }
}
