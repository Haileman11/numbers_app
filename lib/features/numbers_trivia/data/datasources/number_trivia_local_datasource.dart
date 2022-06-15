import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDatasource {
  Future<NumberTrivia> getCachedNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}
