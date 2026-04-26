import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intercommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';

class CartItemCard extends ConsumerWidget {
  final int productId;

  const CartItemCard({required this.productId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItem = ref.watch(
      cartProvider.select((state) {
        final items = state.value?.items;
        if (items == null) {
          return null;
        }

        for (final item in items) {
          if (item.product.id == productId) {
            return item;
          }
        }

        return null;
      }),
    );

    if (cartItem == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: cartItem.product.thumbnail,
            placeholder: (context, url) => const ProductShimmerCard(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image),
            fit: BoxFit.cover,
            height: 128,
            width: double.infinity,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cartItem.product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => ref
                    .read(cartProvider.notifier)
                    .removeItem(cartItem.product.id),
                icon: Icon(Icons.delete_outline),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => ref
                            .read(cartProvider.notifier)
                            .addItem(cartItem.product),
                        child: Container(
                          alignment: Alignment.center,
                          width: 32,
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                      VerticalDivider(color: Colors.grey.shade300, width: 2),
                      Container(
                        alignment: Alignment.center,
                        width: 32,
                        child: Text(
                          cartItem.quantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      VerticalDivider(color: Colors.grey.shade300, width: 2),
                      InkWell(
                        onTap: () => ref
                            .read(cartProvider.notifier)
                            .decrementItem(cartItem.product),
                        child: Container(
                          alignment: Alignment.center,
                          width: 32,
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
