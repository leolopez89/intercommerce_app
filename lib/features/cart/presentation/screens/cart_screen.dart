import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_summary.dart';
import 'package:intercommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: cartAsync.when(
        data: (state) => state.items.isEmpty
            ? const Center(child: Text('El carrito está vacío'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: item.product.thumbnail,
                            placeholder: (context, url) =>
                                const ProductShimmerCard(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                            fit: BoxFit.cover,
                            width: 50,
                          ),
                          title: Text(item.product.title),
                          subtitle: Text('Cantidad: ${item.quantity}'),
                          trailing: Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                          ),
                          onLongPress: () => ref
                              .read(cartProvider.notifier)
                              .removeItem(item.product.id),
                        );
                      },
                    ),
                  ),
                  if (state.summary != null)
                    _buildSummaryCard(context, state.summary!),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, CartSummary summary) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _RowTotal(label: 'Subtotal', value: summary.subtotal),
            _RowTotal(label: 'IVA (19%)', value: summary.tax),
            const Divider(),
            _RowTotal(label: 'Total', value: summary.total, isBold: true),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                /* Lógica de Checkout */
              },
              child: const Text('FINALIZAR COMPRA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowTotal extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const _RowTotal({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isBold ? 18 : 14,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
