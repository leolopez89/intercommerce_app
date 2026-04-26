import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_summary.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool isLoading,
    CartSummary? summary,
  }) = _CartState;
}
