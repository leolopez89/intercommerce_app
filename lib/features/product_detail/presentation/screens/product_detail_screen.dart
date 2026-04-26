import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intercommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:intercommerce_app/features/cart/presentation/widgets/cart_badge_icon_button.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/error_message.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';
import 'package:intercommerce_app/features/product_detail/presentation/providers/product_detail_provider.dart';
import 'package:intercommerce_app/features/product_detail/presentation/providers/state/product_detail_state.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productIdInt = int.tryParse(productId) ?? -1;
    final detailAsync = ref.watch(productDetailProvider(productIdInt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        actions: [CartBadgeIconButton()],
      ),
      body: detailAsync.when(
        data: (state) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: state.product!.thumbnail,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ProductShimmerCard(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.product!.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${state.product!.price}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(state.product!.description),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorMessage(
          error: err,
          onRetry: () => ref.refresh(productDetailProvider(productIdInt)),
        ),
      ),
      bottomNavigationBar: _buildAddToCartButton(context, ref, detailAsync),
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<ProductDetailState> detailAsync,
  ) {
    return detailAsync.when(
      data: (state) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            ref.read(cartProvider.notifier).addItem(state.product!);
            HapticFeedback.lightImpact();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Producto agregado al carrito'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Agregar al carrito'),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
