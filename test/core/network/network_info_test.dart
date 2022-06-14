import 'package:cleanrchitecture_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('Should forward the call to DataConnectionChecker.hasConnection',
        () async {
      // arrange
      when(() => mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      // act
      final result = await networkInfoImpl.isConnected;
      // assert
      verify(() => mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
