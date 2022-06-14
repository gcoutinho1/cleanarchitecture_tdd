import 'dart:convert';

import 'package:cleanrchitecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test(
    'Should be a subclass of NumberTrivia entity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );
  group('fromJson', () {
    test('Should return a valid model when the JSON number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'Should return a valid model when the JSON number is regarded as a double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedMap = {
        "text": "Test text",
        "number": 1
      };
      expect(
        result, expectedMap
      );
    });
  });
}
