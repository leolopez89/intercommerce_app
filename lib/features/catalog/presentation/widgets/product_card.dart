import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/product/${product.id}'),
      child: Card(
        child: Column(
          children: [
            Expanded(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.title, maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}
