import 'package:bloc_test/bloc_test.dart';
import 'package:cleanrchitecture_tdd/core/util/input_converter.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleanrchitecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

      test(
          'Should call inputConverter to validate and convert the string to an unsigned integer',
          () async {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));
        // when(() => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
        // .thenAnswer((invocation) async => const Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(any()));
        // asset
        verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
      });

      // test('Should emit [Error] when the input is invalid', () async {
      //   //arrange
      //   when(() => mockInputConverter.stringToUnsignedInteger(any()))
      //       .thenReturn(Left(InvalidInputFailure()));
      //   //asset later - changed order of act/asset to avoid problems like logic inside bloc be executed before expected in the test
      //   final expected = [
      //     Empty(),
      //     Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      //   ];
      //   expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      //   //act
      //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // });

      blocTest(
      'Should emit [Error] when the input is invalid',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
      },
      build: () => NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );
    },
  );
}
