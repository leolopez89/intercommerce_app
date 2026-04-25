import 'package:go_router/go_router.dart';
import 'package:intercommerce_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:intercommerce_app/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:intercommerce_app/features/product_detail/presentation/screens/product_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'catalog',
      builder: (context, state) => const CatalogScreen(),
      routes: [
        GoRoute(
          path: 'product/:id',
          name: 'product_detail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProductDetailScreen(productId: id);
          },
        ),
        GoRoute(
          path: 'cart',
          name: 'cart',
          builder: (context, state) => const CartScreen(),
        ),
      ],
    ),
  ],
);
