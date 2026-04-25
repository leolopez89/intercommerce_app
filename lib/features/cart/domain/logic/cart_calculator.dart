import '../entities/cart_item.dart';

class CartCalculator {
  static const double taxRate = 0.19;

  double calculateSubtotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double calculateTax(double subtotal) {
    return subtotal * taxRate;
  }

  double calculateTotal(double subtotal, double tax) {
    return subtotal + tax;
  }
}
