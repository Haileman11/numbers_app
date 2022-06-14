import 'package:dartz/dartz.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:numbers/features/numbers_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia {
  NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  Future<Either<Failure, NumberTrivia>> execute() {
    return numberTriviaRepository.getRandomNumberTrivia();
  }
}
