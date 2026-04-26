import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';

class GetProductDetailUseCase {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  Future<Either<Failure, Product>> call(int id) =>
      repository.getProductDetail(id);
}
