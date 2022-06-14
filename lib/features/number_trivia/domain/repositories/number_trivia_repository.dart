import 'package:dartz/dartz.dart';

import 'package:cleanrchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanrchitecture_tdd/core/error/failures.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
