import 'package:sqflite/sqflite.dart';

abstract class CartLocalDataSource {
  Future<void> saveCartItem(int productId, int quantity);
  Future<void> removeCartItem(int productId);
  Future<Map<int, int>> getCartItems();
  Future<void> clearCart();
}

class CartLocalDataSourceSQLite implements CartLocalDataSource {
  final Database database;
  CartLocalDataSourceSQLite(this.database);

  @override
  Future<void> saveCartItem(int productId, int quantity) async {
    await database.insert('cart_items', {
      'product_id': productId,
      'quantity': quantity,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeCartItem(int productId) async {
    await database.delete(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<Map<int, int>> getCartItems() async {
    final List<Map<String, dynamic>> maps = await database.query('cart_items');

    return {for (var m in maps) m['product_id'] as int: m['quantity'] as int};
  }

  @override
  Future<void> clearCart() async {
    await database.delete('cart_items');
  }
}
