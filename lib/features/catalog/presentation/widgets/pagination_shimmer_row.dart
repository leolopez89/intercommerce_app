import 'package:flutter/material.dart';
import 'package:intercommerce_app/features/catalog/presentation/widgets/product_shimmer_card.dart';

class PaginationShimmerRow extends StatelessWidget {
  final double crossAxisSpacing;
  final double horizontalPadding;
  final double aspectRatio;

  const PaginationShimmerRow({
    super.key,
    this.crossAxisSpacing = 10,
    this.horizontalPadding = 16,
    this.aspectRatio = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
          final itemWidth = (availableWidth - crossAxisSpacing) / 2;
          final itemHeight = itemWidth / aspectRatio;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: const ProductShimmerCard(),
                ),
                SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: const ProductShimmerCard(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
