part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => [];
  @override
  bool? get stringify => false;
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Error extends NumberTriviaState {
  final String message;
  Error({required this.message});
  @override
  List<Object> get props => [message];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({required this.numberTrivia});
}
