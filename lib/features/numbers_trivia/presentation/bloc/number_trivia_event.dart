part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
  @override
  bool? get stringify => false;
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;
  GetConcreteNumberTriviaEvent(this.numberString);
}
