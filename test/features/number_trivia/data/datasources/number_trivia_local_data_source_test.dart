import 'dart:convert';

import 'package:cleanrchitecture_tdd/core/error/exceptions.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'Should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSourceImpl.getLastNumberTrivia();
      //assert
      verify(() => mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('Should throw a CachedException when there is not a cached value',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = dataSourceImpl.getLastNumberTrivia;
      //assert

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('Should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences.setString(CACHE_NUMBER_TRIVIA, any()))
          .thenAnswer((_) async => true);
      // act
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(
          CACHE_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
