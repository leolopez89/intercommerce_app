import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

part 'product_detail_state.freezed.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(null) Product? product,
    @Default(false) bool isFetching,
  }) = _ProductDetailState;
}
