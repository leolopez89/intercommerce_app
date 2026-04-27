import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/get_products_usecase.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/search_products_usecase.dart';
import 'package:intercommerce_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

void main() {
  late MockGetProductsUseCase mockGetProducts;
  late MockSearchProductsUseCase mockSearchProducts;
  late ProviderContainer container;

  setUp(() async {
    mockGetProducts = MockGetProductsUseCase();
    mockSearchProducts = MockSearchProductsUseCase();

    await GetIt.instance.reset();
    final sl = GetIt.instance;

    sl.registerFactory<GetProductsUseCase>(() => mockGetProducts);
    sl.registerFactory<SearchProductsUseCase>(() => mockSearchProducts);

    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  final tProducts = [
    Product(
      id: 1,
      title: 'Laptop',
      price: 999.0,
      description: 'A powerful laptop',
      thumbnail: '',
      category: '',
      shippingInformation: '',
      warrantyInformation: '',
      returnPolicy: '',
      availabilityStatus: '',
      rating: 0,
    ),
  ];

  group('CatalogNotifier Tests', () {
    test(
      'initial state should be AsyncData with the list of products',
      () async {
        when(
          () => mockGetProducts(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
          ),
        ).thenAnswer((_) async => Right(tProducts));

        container.listen(catalogProvider, (_, _) {});

        final state = await container.read(catalogProvider.future);

        expect(state.products, tProducts);
        expect(state.isFetching, false);
      },
    );

    test(
      'fetchNextPage should add new products to the existing state',
      () async {
        final initialProducts = List.generate(
          10,
          (index) => Product(
            id: index + 1,
            title: 'Product ${index + 1}',
            price: 20.0 + index,
            description: '',
            thumbnail: '',
            category: '',
            shippingInformation: '',
            warrantyInformation: '',
            returnPolicy: '',
            availabilityStatus: '',
            rating: 0,
          ),
        );

        final nextProducts = [
          Product(
            id: 11,
            title: 'Mouse',
            price: 20.0,
            description: '',
            thumbnail: '',
            category: '',
            shippingInformation: '',
            warrantyInformation: '',
            returnPolicy: '',
            availabilityStatus: '',
            rating: 0,
          ),
        ];

        when(
          () => mockGetProducts(limit: 10, skip: 0),
        ).thenAnswer((_) async => Right(initialProducts));
        when(
          () => mockGetProducts(limit: 10, skip: 10),
        ).thenAnswer((_) async => Right(nextProducts));

        final notifier = container.read(catalogProvider.notifier);
        await container.read(catalogProvider.future);

        await notifier.fetchNextPage();

        final finalState = container.read(catalogProvider).asData!.value;
        expect(finalState.products.length, 11);
        expect(finalState.products, [...initialProducts, ...nextProducts]);
        expect(finalState.skip, 10);
      },
    );

    test(
      'search should update the products after the debounce delay',
      () async {
        when(
          () => mockSearchProducts('Laptop'),
        ).thenAnswer((_) async => Right(tProducts));
        when(
          () => mockGetProducts(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
          ),
        ).thenAnswer((_) async => Right(tProducts));

        final notifier = container.read(catalogProvider.notifier);
        final listener = container.listen(catalogProvider, (_, _) {});
        await container.read(catalogProvider.future);

        notifier.search('Laptop');

        expect(container.read(catalogProvider).value!.isFetching, false);

        await Future.delayed(const Duration(milliseconds: 700));

        final state = container.read(catalogProvider).value;
        expect(state, isNotNull);
        expect(state!.products, tProducts);
        expect(state.query, 'Laptop');

        listener.close();
      },
    );
  });

  group('CatalogNotifier Failure Tests', () {
    test('Must emit AsyncError on failure', () async {
      final tFailure = ServerFailure('Error de conexión');
      when(
        () => mockGetProducts(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
        ),
      ).thenAnswer((_) async => Left(tFailure));

      container.listen(catalogProvider, (_, _) {});

      try {
        await container.read(catalogProvider.future);
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 1000));

      final currentState = container.read(catalogProvider);
      expect(currentState, isA<AsyncError>());
      if (currentState is AsyncError) {
        expect(currentState.error, tFailure);
      }
    });

    test('search retry should recover after previous failure', () async {
      final tFailure = ConnectionFailure();
      when(
        () => mockGetProducts(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
        ),
      ).thenAnswer((_) async => Right(tProducts));
      when(
        () => mockSearchProducts('Laptop'),
      ).thenAnswer((_) async => Left(tFailure));

      final notifier = container.read(catalogProvider.notifier);
      container.listen(catalogProvider, (_, _) {});
      await container.read(catalogProvider.future);

      notifier.search('Laptop');
      await Future.delayed(const Duration(milliseconds: 1000));

      final failedState = container.read(catalogProvider);
      expect(failedState, isA<AsyncError>());
      if (failedState is AsyncError) {
        expect(failedState.error, tFailure);
      }

      when(
        () => mockSearchProducts('Laptop'),
      ).thenAnswer((_) async => Right(tProducts));

      notifier.search('Laptop');
      await Future.delayed(const Duration(milliseconds: 1000));

      final recoveredState = container.read(catalogProvider);
      recoveredState.maybeWhen(
        data: (catalogState) {
          expect(catalogState.products, tProducts);
          expect(catalogState.query, 'Laptop');
        },
        orElse: () => fail('Expected AsyncData after retry'),
      );
    });
  });
}
