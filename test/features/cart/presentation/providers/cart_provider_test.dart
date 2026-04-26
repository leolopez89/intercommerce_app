import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intercommerce_app/core/di/injection_container.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/calculate_cart_summary_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/remove_product_from_cart_usecase.dart';
import 'package:intercommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:mocktail/mocktail.dart';

class MockAddToCartUseCase extends Mock implements AddProductToCartUseCase {}

class MockGetCartItemsUseCase extends Mock implements GetCartItemsUseCase {}

class MockRemoveProductFromCartUseCase extends Mock
    implements RemoveProductFromCartUseCase {}

void main() {
  late MockAddToCartUseCase mockAddToCart;
  late MockGetCartItemsUseCase mockGetCartItems;
  late MockRemoveProductFromCartUseCase mockRemoveProductFromCart;
  late ProviderContainer container;

  setUp(() async {
    await GetIt.instance.reset();
    mockAddToCart = MockAddToCartUseCase();
    mockGetCartItems = MockGetCartItemsUseCase();
    mockRemoveProductFromCart = MockRemoveProductFromCartUseCase();

    sl.registerFactory<AddProductToCartUseCase>(() => mockAddToCart);
    sl.registerFactory<GetCartItemsUseCase>(() => mockGetCartItems);
    sl.registerFactory<RemoveProductFromCartUseCase>(
      () => mockRemoveProductFromCart,
    );
    sl.registerFactory<CalculateCartSummaryUsecase>(
      () => CalculateCartSummaryUsecase(),
    );

    when(
      () => mockGetCartItems(),
    ).thenAnswer((_) async => const Right(<int, int>{}));
    when(
      () => mockRemoveProductFromCart(any()),
    ).thenAnswer((_) async => const Right(null));

    container = ProviderContainer();
    await container.read(cartProvider.future);
  });

  tearDown(() => container.dispose());

  final tProduct = Product(
    id: 1,
    title: 'Café',
    price: 100.0,
    description: '',
    thumbnail: '',
    category: '',
    shippingInformation: '',
    warrantyInformation: '',
    returnPolicy: '',
    availabilityStatus: '',
    rating: 0,
  );

  group('CartNotifier & Summary Tests', () {
    test('Must initialize with an empty cart', () async {
      final state = await container.read(cartProvider.future);
      expect(state.items, isEmpty);
      expect(state.summary, isNull);
    });

    test('addItem must add a product and update the list', () async {
      when(
        () => mockAddToCart(any(), any()),
      ).thenAnswer((_) async => const Right(null));

      final notifier = container.read(cartProvider.notifier);

      await notifier.addItem(tProduct);

      final state = container.read(cartProvider).value;
      expect(state!.items.length, 1);
      expect(state.items.first.product, tProduct);
      expect(state.items.first.quantity, 1);
    });

    test(
      'CartTotalsProvider must recalculate the VAT (19%) automatically when adding products',
      () async {
        when(
          () => mockAddToCart(any(), any()),
        ).thenAnswer((_) async => const Right(null));

        final notifier = container.read(cartProvider.notifier);

        await notifier.addItem(tProduct);

        final summary = container.read(cartProvider).value?.summary;

        expect(summary, isNotNull);
        expect(summary!.subtotal, 100.0);
        expect(summary.tax, 19.0);
        expect(summary.total, 119.0);
      },
    );

    test(
      'removeItem must remove the product and set the totals to zero',
      () async {
        when(
          () => mockAddToCart(any(), any()),
        ).thenAnswer((_) async => const Right(null));
        final notifier = container.read(cartProvider.notifier);

        await notifier.addItem(tProduct);
        await notifier.removeItem(tProduct.id);

        final state = container.read(cartProvider).value;

        expect(state!.items, isEmpty);
        expect(state.summary, isNull);
      },
    );

    test('decrementItem must decrease quantity and update totals', () async {
      when(
        () => mockAddToCart(any(), any()),
      ).thenAnswer((_) async => const Right(null));
      final notifier = container.read(cartProvider.notifier);

      await notifier.addItem(tProduct);
      await notifier.addItem(tProduct);
      await notifier.decrementItem(tProduct);

      final state = container.read(cartProvider).value;

      expect(state!.items.length, 1);
      expect(state.items.first.quantity, 1);
      expect(state.summary, isNotNull);
      expect(state.summary!.subtotal, 100.0);
      expect(state.summary!.tax, 19.0);
      expect(state.summary!.total, 119.0);
    });

    test(
      'decrementItem must remove the product when quantity reaches zero',
      () async {
        when(
          () => mockAddToCart(any(), any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRemoveProductFromCart(any()),
        ).thenAnswer((_) async => const Right(null));
        final notifier = container.read(cartProvider.notifier);

        await notifier.addItem(tProduct);
        await notifier.decrementItem(tProduct);

        final state = container.read(cartProvider).value;

        expect(state!.items, isEmpty);
        expect(state.summary, isNull);
      },
    );
  });

  group('CartNotifier Failure Tests', () {
    test('Must emit AsyncError on failure', () async {
      final tFailure = DatabaseFailure();
      when(() => mockGetCartItems()).thenAnswer((_) async => Left(tFailure));

      final freshContainer = ProviderContainer();
      addTearDown(freshContainer.dispose);

      try {
        await freshContainer.read(cartProvider.future);
      } catch (_) {}

      final currentState = freshContainer.read(cartProvider);
      expect(currentState is AsyncError, true);
      expect(currentState.error, tFailure);
    });

    test('Must emit AsyncError when addItem fails', () async {
      final tFailure = DatabaseFailure('No se pudo guardar');
      when(
        () => mockAddToCart(any(), any()),
      ).thenAnswer((_) async => Left(tFailure));
      when(() => mockGetCartItems()).thenAnswer((_) async => Right({}));

      try {
        final notifier = container.read(cartProvider.notifier);
        await notifier.addItem(tProduct);
      } catch (_) {}

      final currentState = container.read(cartProvider);
      expect(currentState is AsyncError, true);
      expect(currentState.error, tFailure);
    });
  });
}
