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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: CartBadgeIconButton(),
              ),
            ),
          ),
        ],
      ),
      body: detailAsync.when(
        data: (state) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: state.product!.thumbnail,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ProductShimmerCard(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.product!.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.product!.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: state.product!.rating >= 4
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            state.product!.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${state.product!.price}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    Divider(),
                    const SizedBox(height: 16),
                    Text(
                      "Product Details".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(state.product!.description),
                    const SizedBox(height: 16),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.5,
                          ),
                      children: [
                        _InfoCard(
                          icon: Icons.check_circle_outline,
                          title: state.product!.availabilityStatus,
                        ),
                        _InfoCard(
                          icon: Icons.local_shipping_outlined,
                          title: state.product!.shippingInformation,
                        ),
                        _InfoCard(
                          icon: Icons.shield_outlined,
                          title: state.product!.warrantyInformation,
                        ),
                        _InfoCard(
                          icon: Icons.assignment_return_outlined,
                          title: state.product!.returnPolicy,
                        ),
                      ],
                    ),
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
                content: Text('Product added to cart'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Add to Cart'),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _InfoCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.indigo),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
