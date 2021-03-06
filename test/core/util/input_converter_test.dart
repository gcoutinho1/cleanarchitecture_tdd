import 'package:cleanrchitecture_tdd/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'Should return an intenger when the string represents an unsigned intenger',
        () {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });

    test('Should return a Failure when the string is not a intenger', () {
        // arrange
      const str = 'kdzf';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('Should return a Failure when the string is a negative intenger', () {
        // arrange
      const str = '-123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

  });
}
