import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intercommerce_app/features/cart/presentation/widgets/cart_badge_icon_button.dart';
import 'package:intercommerce_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/error_message.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/pagination_shimmer_row.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final catalogState = ref.read(catalogProvider).value;

      if (catalogState == null) return;

      final thresholdReached =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8;

      if (thresholdReached &&
          catalogState.hasMore &&
          !catalogState.isFetching &&
          catalogState.query.isEmpty) {
        ref.read(catalogProvider.notifier).fetchNextPage();
      }
    });

    final initialQuery = ref.read(catalogProvider).value?.query ?? '';
    _searchController = TextEditingController(text: initialQuery)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          catalogAsync.when(
            data: (catalogState) => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ProductCard(
                    productId: catalogState.products[index].id,
                  );
                }, childCount: catalogState.products.length),
              ),
            ),
            loading: () => const SliverFillRemaining(child: ProductShimmer()),
            error: (err, _) => SliverFillRemaining(
              child: ErrorMessage(
                error: err,
                onRetry: () => ref
                    .read(catalogProvider.notifier)
                    .search(_searchController.text),
              ),
            ),
          ),
          if (catalogAsync.value?.hasMore == true)
            const PaginationShimmerRow(
              crossAxisSpacing: 10,
              horizontalPadding: 16,
              aspectRatio: 0.7,
            ),
        ],
      ),
    );
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
            controller: _searchController,
            hintText: 'Search products...',
            onChanged: (value) =>
                ref.read(catalogProvider.notifier).search(value),
            leading: const Icon(Icons.search, color: Colors.grey),
            trailing: _searchController.text.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(catalogProvider.notifier).search('');
                      },
                    ),
                  ]
                : null,
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            hintStyle: WidgetStateProperty.all(
              const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
