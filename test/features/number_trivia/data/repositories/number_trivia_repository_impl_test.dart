import 'package:cleanrchitecture_tdd/core/error/exceptions.dart';
import 'package:cleanrchitecture_tdd/core/error/failures.dart';
import 'package:cleanrchitecture_tdd/core/platform/network_info.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/repositories_impl/number_trivia_repository_impl.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(
      as: #MockRemoteDataSource, returnNullOnMissingStub: false)
])
@GenerateMocks([], customMocks: [
  MockSpec<NumberTriviaLocalDataSource>(
      as: #MockLocalDataSource, returnNullOnMissingStub: false)
])
@GenerateMocks([], customMocks: [
  MockSpec<NetworkInfo>(as: #MockNetworkInfo, returnNullOnMissingStub: false)
])
void main() {
  NumberTriviaRepositoryImpl? repositoryImpl;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('Should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
      //act
      // await repositoryImpl?.getConcreteNumberTrivia(tNumber);
      await repositoryImpl?.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo?.isConnected);
      // verify(repositoryImpl?.getConcreteNumberTrivia(tNumber));
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
      });
      test(
          'Should return remote data when the call to remote data source is sucessfull',
          () async {
        //arrange
        when(mockRemoteDataSource?.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl?.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'Should cache the data localy when the call to remote data source is sucessfull',
          () async {
        //arrange
        when(mockRemoteDataSource?.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repositoryImpl!.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource?.cacheNumberTrivia(tNumberTriviaModel));
      });
    });
    test(
        'Should return server failure when the call to remote data source is unsucessfull',
        () async {
      //arrange
      when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource?.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());
      //act
      final result = await repositoryImpl?.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
    });

    test(
        'Should return last locally cached data when the cached data is present',
        () async {
      //arrange
      when(mockLocalDataSource?.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repositoryImpl?.getConcreteNumberTrivia(tNumber);
      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource?.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('Should return CacheFailure when there is no cached data present',
        () async {
      //arrange
      when(mockLocalDataSource?.getLastNumberTrivia())
          .thenThrow(CacheException());
      //act
      final result = await repositoryImpl?.getConcreteNumberTrivia(tNumber);
      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource?.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
