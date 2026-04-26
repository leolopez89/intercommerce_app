import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/search_products_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late SearchProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = SearchProductsUseCase(mockRepository);
  });

  const tQuery = 'shirt';
  final tProducts = [
    Product(
      id: 1,
      title: 'Shirt',
      description: 'A stylish shirt',
      price: 49.99,
      thumbnail: 'https://example.com/shirt.jpg',
    ),
    Product(
      id: 2,
      title: 'T-shirt',
      description: 'A comfortable tee',
      price: 29.99,
      thumbnail: 'https://example.com/tshirt.jpg',
    ),
  ];

  test('should return matching products from the repository', () async {
    when(
      () => mockRepository.searchProducts(tQuery),
    ).thenAnswer((_) async => Right(tProducts));

    final result = await useCase(tQuery);

    expect(result, Right(tProducts));
    verify(() => mockRepository.searchProducts(tQuery)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'should return a Failure when repository searchProducts fails',
    () async {
      final tFailure = ServerFailure();
      when(
        () => mockRepository.searchProducts(tQuery),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await useCase(tQuery);

      expect(result, Left(tFailure));
      verify(() => mockRepository.searchProducts(tQuery)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
