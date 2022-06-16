// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive intenger or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTrivia concrete,
      required GetRandomNumberTrivia random,
      required this.inputConverter})
      : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither.fold(
        (failure) async {
          Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (number) async {
          getConcreteNumberTrivia(Params(number: number));
        },
      );
        // final inputEither =
        //     inputConverter.stringToUnsignedInteger(event.numberString);
        // yield* inputEither.fold((failure) async* {
        //   yield Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
        // }, (integer) async* {
        //   getConcreteNumberTrivia(Params(number: integer));
        // });

        // inputEither.fold(
        //     (l) => const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
        //     (r) => throw UnimplementedError());
      }
    });
  }
}
