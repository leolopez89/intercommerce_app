import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intercommerce_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(
      catalogProvider.select(
        (state) => state.value?.products.firstWhere((p) => p.id == productId),
      ),
    );

    if (product == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => context.go('/product/${product.id}'),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RepaintBoundary(
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  placeholder: (context, url) => const ProductShimmerCard(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                  fit: BoxFit.cover,
                  memCacheWidth: 250,
                  memCacheHeight: 250,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                product.category.toUpperCase(),
                maxLines: 1,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.title, maxLines: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                maxLines: 1,
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
