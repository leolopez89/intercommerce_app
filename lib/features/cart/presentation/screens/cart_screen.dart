import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_summary.dart';
import 'package:intercommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:intercommerce_app/features/cart/presentation/widgets/cart_item_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartAsync.when(
        data: (state) => state.items.isEmpty
            ? const Center(child: Text('The cart is empty'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Your Products',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${state.items.length} ${state.items.length == 1 ? 'product' : 'products'}',
                                ),
                              ],
                            ),
                          );
                        }
                        final item = state.items[index - 1];
                        return CartItemCard(productId: item.product.id);
                      },
                    ),
                  ),
                  if (state.summary != null)
                    _buildSummaryCard(context, state.summary!, ref),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    CartSummary summary,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ColumnTotal(label: 'Subtotal', value: summary.subtotal),
              _ColumnTotal(label: 'Tax (19%)', value: summary.tax),
              _ColumnTotal(label: 'Total', value: summary.total, isBold: true),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your purchase!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('CHECKOUT'),
          ),
        ],
      ),
    );
  }
}

class _ColumnTotal extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const _ColumnTotal({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isBold ? 20 : 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: isBold ? Colors.indigo : Colors.black87,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
