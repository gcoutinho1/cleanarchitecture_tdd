part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
// check for list object get props => [] inside this method
  const GetTriviaForConcreteNumber(this.numberString) : super();
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
