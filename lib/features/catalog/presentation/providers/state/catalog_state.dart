import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

part 'catalog_state.freezed.dart';

@freezed
class CatalogState with _$CatalogState {
  const factory CatalogState({
    @Default([]) List<Product> products,
    @Default(false) bool isFetching,
    @Default(true) bool hasMore,
    @Default('') String query,
    @Default(0) int skip,
  }) = _CatalogState;
}
