import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:intercommerce_app/core/network/error_interceptor.dart';
import 'package:intercommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:intercommerce_app/features/catalog/data/datasources/product_local_datasource.dart';
import 'package:intercommerce_app/features/catalog/data/datasources/product_local_datasource_sqlite.dart';
import 'package:intercommerce_app/features/catalog/data/datasources/product_remote_datasource.dart';
import 'package:intercommerce_app/features/catalog/data/repositories/product_repository_impl.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/search_products_usecase.dart';
import 'package:intercommerce_app/features/product_detail/domain/usecases/get_product_detail_usecase.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/get_products_usecase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // Database
  final database = await _initDatabase();
  sl.registerLazySingleton(() => database);

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));

  // Core
  sl.registerLazySingleton(
    () =>
        Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
          ..interceptors.add(ErrorInterceptor()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceSQLite(sl()),
  );

  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceSQLite(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
}

Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final database = await openDatabase(
    join(dbPath, 'commerce_cache.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT, description TEXT, price REAL, thumbnail TEXT)',
      );
      await db.execute(
        'CREATE TABLE cart_items(product_id INTEGER PRIMARY KEY, quantity INTEGER)',
      );
    },
    version: 2,
  );

  return database;
}
