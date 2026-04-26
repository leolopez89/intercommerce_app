import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late AddProductToCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddProductToCartUseCase(mockRepository);
  });

  const tProductId = 1;
  const tQuantity = 2;

  test('should add or update cart item through repository successfully', () async {
    when(
      () => mockRepository.addOrUpdateItem(tProductId, tQuantity),
    ).thenAnswer((_) async => const Right(null));

    final result = await useCase(tProductId, tQuantity);

    expect(result, const Right(null));
    verify(() => mockRepository.addOrUpdateItem(tProductId, tQuantity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when repository addOrUpdateItem fails', () async {
    final tFailure = ServerFailure();
    when(
      () => mockRepository.addOrUpdateItem(tProductId, tQuantity),
    ).thenAnswer((_) async => Left(tFailure));

    final result = await useCase(tProductId, tQuantity);

    expect(result, Left(tFailure));
    verify(() => mockRepository.addOrUpdateItem(tProductId, tQuantity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
