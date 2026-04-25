import 'package:intercommerce_app/features/catalog/data/datasources/product_local_datasource.dart';
import 'package:intercommerce_app/features/catalog/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDataSourceSQLite implements ProductLocalDataSource {
  final Database database;
  ProductLocalDataSourceSQLite(this.database);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final batch = database.batch();
    for (var product in products) {
      batch.insert(
        'products',
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final List<Map<String, dynamic>> maps = await database.query('products');
    return maps.map((json) => ProductModel.fromJson(json)).toList();
  }
}
