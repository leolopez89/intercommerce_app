import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/clear_cart_items_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late ClearCartItemsUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = ClearCartItemsUseCase(mockRepository);
  });

  test('should clear cart through repository successfully', () async {
    when(
      () => mockRepository.clearCart(),
    ).thenAnswer((_) async => Right<Failure, void>(null));

    final result = await useCase();

    expect(result, Right<Failure, void>(null));
    verify(() => mockRepository.clearCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when repository clearCart fails', () async {
    final tFailure = ServerFailure();
    when(
      () => mockRepository.clearCart(),
    ).thenAnswer((_) async => Left<Failure, void>(tFailure));

    final result = await useCase();

    expect(result, Left<Failure, void>(tFailure));
    verify(() => mockRepository.clearCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
