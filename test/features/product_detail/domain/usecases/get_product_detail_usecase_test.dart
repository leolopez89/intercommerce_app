import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';
import 'package:intercommerce_app/features/catalog/domain/repositories/product_repository.dart';
import 'package:intercommerce_app/features/product_detail/domain/usecases/get_product_detail_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductDetailUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductDetailUseCase(mockRepository);
  });

  const tProductId = 1;
  final tProduct = Product(
    id: tProductId,
    title: 'Test Product',
    description: 'Test description',
    price: 99.99,
    thumbnail: 'https://example.com/product.jpg',
  );

  test('should get product detail from repository successfully', () async {
    when(
      () => mockRepository.getProductDetail(tProductId),
    ).thenAnswer((_) async => Right(tProduct));

    final result = await useCase(tProductId);

    expect(result, Right(tProduct));
    verify(() => mockRepository.getProductDetail(tProductId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'should return a Failure when repository getProductDetail fails',
    () async {
      final tFailure = ServerFailure();
      when(
        () => mockRepository.getProductDetail(tProductId),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await useCase(tProductId);

      expect(result, Left(tFailure));
      verify(() => mockRepository.getProductDetail(tProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
