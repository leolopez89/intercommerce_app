import 'package:dartz/dartz.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Map<int, int>>> getCart() async {
    try {
      final savedItems = await localDataSource.getCartItems();

      if (savedItems.isEmpty) return Right({});

      return Right(savedItems);
    } on Exception {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addOrUpdateItem(
    int productId,
    int quantity,
  ) async {
    try {
      await localDataSource.saveCartItem(productId, quantity);

      return const Right(null);
    } on Exception {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(int productId) async {
    try {
      await localDataSource.removeCartItem(productId);

      return const Right(null);
    } on Exception {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();

      return const Right(null);
    } on Exception {
      return Left(DatabaseFailure());
    }
  }
}
