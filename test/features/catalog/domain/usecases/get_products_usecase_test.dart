import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:mocktail/mocktail.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';
import 'package:intercommerce_app/features/catalog/domain/usecases/get_products_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  final tProducts = [
    Product(
      id: 1,
      title: 'Product 1',
      description: 'Description of product 1',
      price: 100.0,
      thumbnail: 'https://example.com/product1.jpg',
      category: '',
      shippingInformation: '',
      warrantyInformation: '',
      returnPolicy: '',
      availabilityStatus: '',
      rating: 0,
    ),
    Product(
      id: 2,
      title: 'Product 2',
      description: 'Description of product 2',
      price: 200.0,
      thumbnail: 'https://example.com/product2.jpg',
      category: '',
      shippingInformation: '',
      warrantyInformation: '',
      returnPolicy: '',
      availabilityStatus: '',
      rating: 0,
    ),
  ];

  test('product list successfully retrieved from the repository', () async {
    when(
      () => mockRepository.getProducts(limit: 10, skip: 0),
    ).thenAnswer((_) async => Right(tProducts));

    final result = await useCase(limit: 10, skip: 0);

    expect(result, Right(tProducts));
    verify(() => mockRepository.getProducts(limit: 10, skip: 0)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when the repository fails', () async {
    final tFailure = ServerFailure();
    when(
      () => mockRepository.getProducts(limit: 10, skip: 0),
    ).thenAnswer((_) async => Left(tFailure));

    final result = await useCase(limit: 10, skip: 0);

    expect(result, Left(tFailure));
    verify(() => mockRepository.getProducts(limit: 10, skip: 0)).called(1);
  });
}
