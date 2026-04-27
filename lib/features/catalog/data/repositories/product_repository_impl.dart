import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/data/datasources/product_local_datasource.dart';
import 'package:intercommerce_app/features/catalog/data/datasources/product_remote_datasource.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final remoteProducts = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );

      await localDataSource.cacheProducts(remoteProducts);

      return Right(remoteProducts.map((m) => m.toEntity()).toList());
    } on DioException {
      final localProducts = await localDataSource.getCachedProducts(
        limit: limit,
        skip: skip,
      );

      if (localProducts.isNotEmpty) {
        return Right(localProducts.map((m) => m.toEntity()).toList());
      }

      return Left(ConnectionFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetail(int id) async {
    try {
      final remoteProduct = await remoteDataSource.getProductDetail(id);

      return Right(remoteProduct.toEntity());
    } on DioException {
      final localProduct = await localDataSource.getCachedProductDetail(id);

      if (localProduct != null) {
        return Right(localProduct.toEntity());
      }

      return Left(ConnectionFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final models = await remoteDataSource.searchProducts(query);

      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException {
      return Left(ConnectionFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
