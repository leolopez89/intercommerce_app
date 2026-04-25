import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intercommerce_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(catalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('InterCommerce'), centerTitle: true),
      body: catalogAsync.when(
        data: (products) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return InkWell(
              onTap: () => context.go('/product/${product.id}'),
              child: Card(
                child: Column(
                  children: [
                    Expanded(child: Image.network(product.thumbnail)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(product.title, maxLines: 2),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const ProductShimmer(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
