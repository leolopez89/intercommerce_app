import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/product_detail/domain/usecases/get_product_detail_usecase.dart';
import 'package:intercommerce_app/features/product_detail/presentation/providers/state/product_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<ProductDetailState> productDetail(ProductDetailRef ref, int id) async {
  final result = (await sl<GetProductDetailUseCase>().execute(id));

  return result.fold(
    (failure) => throw failure,
    (product) => ProductDetailState(product: product),
  );
}
