import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/presentation/widgets/cart_badge_icon_button.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/pagination_shimmer_row.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          ref.read(catalogProvider.notifier).hasMore &&
          !ref.read(catalogProvider.notifier).isFetching) {
        ref.read(catalogProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogProvider);
    final hasMore = ref.watch(catalogProvider.notifier).hasMore;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          catalogAsync.when(
            data: (products) => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= products.length) {
                    return const ProductShimmerCard();
                  }

                  return ProductCard(product: products[index]);
                }, childCount: products.length),
              ),
            ),
            loading: () => const SliverFillRemaining(child: ProductShimmer()),
            error: (err, _) => SliverFillRemaining(
              child: Center(child: Text(_mapErrorToMessage(err))),
            ),
          ),
          if (hasMore && catalogAsync.value != null)
            const PaginationShimmerRow(
              crossAxisSpacing: 10,
              horizontalPadding: 16,
              aspectRatio: 0.7,
            ),
        ],
      ),
    );
  }

  String _mapErrorToMessage(Object error) {
    if (error is ConnectionFailure) return 'Por favor, revisa tu conexión.';
    if (error is ServerFailure) return 'El servidor está en mantenimiento.';
    return 'Algo salió mal. Inténtalo de nuevo.';
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      title: const Text('InterCommerce'),
      actions: const [CartBadgeIconButton()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            hintText: 'Buscar productos...',
            onChanged: (value) =>
                ref.read(catalogProvider.notifier).search(value),
            leading: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

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
            Expanded(child: Image.network(product.thumbnail)),
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
