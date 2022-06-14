import 'package:cleanrchitecture_tdd/core/usecases/usecase.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get random trivia from repository', () async {
    //assert
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //act

    final result = await usecase(NoParams());

    //assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}