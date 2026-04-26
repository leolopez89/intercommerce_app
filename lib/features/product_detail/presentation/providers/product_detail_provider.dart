import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/product_detail/domain/usecases/get_product_detail_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<Product> productDetail(ProductDetailRef ref, int id) {
  return sl<GetProductDetailUseCase>().execute(id);
}
