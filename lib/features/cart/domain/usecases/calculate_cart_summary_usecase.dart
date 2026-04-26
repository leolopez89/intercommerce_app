import '../entities/cart_item.dart';
import '../entities/cart_summary.dart';

class CalculateCartSummaryUsecase {
  CartSummary call(List<CartItem> items) {
    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    final tax = subtotal * 0.19;
    final discount = 0.0;
    final total = subtotal + tax - discount;
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);

    return CartSummary(
      subtotal: subtotal,
      tax: tax,
      discount: discount,
      total: total,
      totalItems: totalItems,
    );
  }
}
