class CartSummary {
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final int totalItems;

  CartSummary({
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.totalItems,
  });
}
