import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/calculate_cart_summary_usecase.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

void main() {
  late CalculateCartSummaryUsecase useCase;

  setUp(() {
    useCase = CalculateCartSummaryUsecase();
  });

  group('CalculateCartSummaryUsecase', () {
    test('should calculate cart summary with empty cart', () {
      final result = useCase([]);

      expect(result.subtotal, 0.0);
      expect(result.total, 0.0);
      expect(result.totalItems, 0);
      expect(result.discount, 0.0);
    });

    test('should calculate cart summary with single item', () {
      final cartItems = [
        CartItem(
          product: Product(
            id: 1,
            title: 'Product 1',
            description: 'Description 1',
            price: 100.0,
            thumbnail: 'https://example.com/image1.jpg',
          ),
          quantity: 1,
        ),
      ];

      final result = useCase(cartItems);

      expect(result.subtotal, 100.0);
      expect(result.tax, 100.0 * 0.19);
      expect(result.totalItems, 1);
      expect(result.total, 100.0 * 1.19);
    });

    test('should calculate cart summary with multiple items', () {
      final cartItems = [
        CartItem(
          product: Product(
            id: 1,
            title: 'Product 1',
            description: 'Description 1',
            price: 100.0,
            thumbnail: 'https://example.com/image1.jpg',
          ),
          quantity: 2,
        ),
        CartItem(
          product: Product(
            id: 2,
            title: 'Product 2',
            description: 'Description 2',
            price: 50.0,
            thumbnail: 'https://example.com/image2.jpg',
          ),
          quantity: 3,
        ),
      ];

      final result = useCase(cartItems);

      expect(result.subtotal, 350.0);
      expect(result.totalItems, 5);
      expect(result.tax, 350.0 * 0.19);
      expect(result.total, 350.0 * 1.19);
    });
  });
}
