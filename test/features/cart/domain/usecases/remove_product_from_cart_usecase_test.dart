import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/remove_product_from_cart_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late RemoveProductFromCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = RemoveProductFromCartUseCase(mockRepository);
  });

  const tProductId = 1;

  test(
    'should remove product from cart through repository successfully',
    () async {
      when(
        () => mockRepository.removeItem(tProductId),
      ).thenAnswer((_) async => Right<Failure, void>(null));

      final result = await useCase(tProductId);

      expect(result, Right<Failure, void>(null));
      verify(() => mockRepository.removeItem(tProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return a Failure when repository removeItem fails', () async {
    final tFailure = ServerFailure();
    when(
      () => mockRepository.removeItem(tProductId),
    ).thenAnswer((_) async => Left<Failure, void>(tFailure));

    final result = await useCase(tProductId);

    expect(result, Left<Failure, void>(tFailure));
    verify(() => mockRepository.removeItem(tProductId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
