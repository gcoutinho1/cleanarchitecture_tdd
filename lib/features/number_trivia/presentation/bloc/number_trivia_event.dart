part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  // const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
// check for list object get props => [] inside this method
  GetTriviaForConcreteNumber(this.numberString);
  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
