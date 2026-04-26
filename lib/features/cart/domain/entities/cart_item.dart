import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

part 'cart_item.freezed.dart';

@freezed
class CartItem with _$CartItem {
  factory CartItem({required Product product, required int quantity}) =
      _CartItem;

  CartItem._();

  double get totalPrice => product.price * quantity;
}
