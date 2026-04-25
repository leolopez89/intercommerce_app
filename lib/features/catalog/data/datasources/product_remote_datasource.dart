import 'package:dio/dio.dart';
import 'package:intercommerce_app/features/catalog/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 10, int skip = 0});
  Future<ProductModel> getProductDetail(int id);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts({int limit = 10, int skip = 0}) async {
    final response = await dio.get(
      '/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    final List data = response.data['products'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    final response = await dio.get('/products/$id');
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await dio.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    final List data = response.data['products'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
