import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercommerce_app/core/errors/failures.dart';
import 'package:intercommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:intercommerce_app/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late GetCartItemsUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartItemsUseCase(mockRepository);
  });

  final tCartItems = <int, int>{1: 2, 3: 1};

  test('should return cart items from repository successfully', () async {
    when(() => mockRepository.getCart()).thenAnswer((_) async => Right(tCartItems));

    final result = await useCase();

    expect(result, Right(tCartItems));
    verify(() => mockRepository.getCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when repository getCart fails', () async {
    final tFailure = ServerFailure();
    when(() => mockRepository.getCart()).thenAnswer((_) async => Left(tFailure));

    final result = await useCase();

    expect(result, Left(tFailure));
    verify(() => mockRepository.getCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
