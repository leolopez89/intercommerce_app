import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection_container.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<Product> productDetail(ProductDetailRef ref, int id) {
  return sl<GetProductDetailUseCase>().execute(id);
}
