import 'package:cleanrchitecture_tdd/core/platform/network_info.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/data/repositories_impl/number_trivia_repository_impl.dart';
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
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });
}
