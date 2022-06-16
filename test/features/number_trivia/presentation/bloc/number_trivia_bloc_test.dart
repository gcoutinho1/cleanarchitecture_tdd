import 'package:bloc_test/bloc_test.dart';
import 'package:cleanrchitecture_tdd/core/error/failures.dart';
import 'package:cleanrchitecture_tdd/core/usecases/usecase.dart';
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

      void setUpMockInputConverterSucess() =>
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));

      // void setUpMockInputConverterFailure() =>
      //     when(() => mockInputConverter.stringToUnsignedInteger(any()))
      //         .thenReturn(const Left(Failure()));

      test(
          'Should call inputConverter to validate and convert the string to an unsigned integer',
          () async {
        // arrange
        setUpMockInputConverterSucess();
        when(() => mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(any()));
        // asset
        verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
      });

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
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [
          const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
        ],
      );

      test('Should get data from the concrete use case', () async {
        //arrange
        setUpMockInputConverterSucess();
        when(() => mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        //act
        bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(() =>
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
        //asset
        verify(() =>
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      });

      blocTest(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        setUp: () {
          setUpMockInputConverterSucess();
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => const Right(tNumberTrivia));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)],
      );

      blocTest(
        'Should emit [Loading, Error] when getting data fails',
        setUp: () {
          setUpMockInputConverterSucess();
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () =>
            [Loading(), const Error(errorMessage: SERVER_FAILURE_MESSAGE)],
      );

      blocTest(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        setUp: () {
          setUpMockInputConverterSucess();
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () =>
            [Loading(), const Error(errorMessage: CACHE_FAILURE_MESSAGE)],
      );
    },
  );

  group(
    'GetTriviaForRandomNumber',
    () {
      const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

      test('Should get data from the random use case', () async {
        //arrange
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        //act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(() => mockGetRandomNumberTrivia(NoParams()));
        //asset
        verify(() => mockGetRandomNumberTrivia(NoParams()));
      });

      blocTest(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        setUp: () {
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForRandomNumber()),
        expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)],
      );

      blocTest(
        'Should emit [Loading, Error] when getting data fails',
        setUp: () {
          
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForRandomNumber()),
        expect: () =>
            [Loading(), const Error(errorMessage: SERVER_FAILURE_MESSAGE)],
      );

      blocTest(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        setUp: () {
          
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForRandomNumber()),
        expect: () =>
            [Loading(), const Error(errorMessage: CACHE_FAILURE_MESSAGE)],
      );
    },
  );
}
