import 'dart:convert';

import 'package:cleanrchitecture_tdd/core/error/exceptions.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    registerFallbackValue(Uri());
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHtppClientSucess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHtppClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
            (_) async => http.Response('Something wrong happened', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''Should perform a GET request on a URL with number 
    being the endpoint and with application/json header''', () async {
      // arrange
      setUpMockHtppClientSucess200();
      // act
      remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);

      //asset
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('Should return number trivia when the response code is 200(SUCESS)',
        () async {
      // arrange
      setUpMockHtppClientSucess200();
      // act
      final result =
          await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      // asset
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHtppClientFailure404();
      //act
      final call = remoteDataSourceImpl.getConcreteNumberTrivia;
      //asset
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

    group('getRandomNumberTrivia', () {
    
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''Should perform a GET request on a URL with number 
    being the endpoint and with application/json header''', () async {
      // arrange
      setUpMockHtppClientSucess200();
      // act
      remoteDataSourceImpl.getRandomNumberTrivia();

      //asset
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('Should return a Random number trivia when the response code is 200(SUCESS)',
        () async {
      // arrange
      setUpMockHtppClientSucess200();
      // act
      final result =
          await remoteDataSourceImpl.getRandomNumberTrivia();
      // asset
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHtppClientFailure404();
      //act
      final call = remoteDataSourceImpl.getRandomNumberTrivia;
      //asset
      expect(
          () => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
