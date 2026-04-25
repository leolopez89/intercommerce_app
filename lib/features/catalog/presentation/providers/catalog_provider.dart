import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/get_products_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_provider.g.dart';

@riverpod
class Catalog extends _$Catalog {
  @override
  Future<List<Product>> build() async {
    final getProducts = sl<GetProductsUseCase>();
    return getProducts.execute();
  }

  // Aquí agregaremos la lógica de Scroll Infinito más adelante
}
