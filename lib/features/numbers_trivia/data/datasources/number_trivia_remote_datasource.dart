import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<NumberTriviaModel> getRandomNumberTrivia();
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
}
