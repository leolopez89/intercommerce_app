import 'package:go_router/go_router.dart';
import 'package:intercommerce_app/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:intercommerce_app/features/product_detail/presentation/screens/product_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CatalogScreen(),
      routes: [
        GoRoute(
          path: 'product/:id', // Ruta nominada con parámetro
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProductDetailScreen(productId: id);
          },
        ),
      ],
    ),
  ],
);
