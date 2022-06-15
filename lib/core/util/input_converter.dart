import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    return Right(int.parse(str));
  }
}

class InvalidInputFailure extends Failure {}
