import 'package:dartz/dartz.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:numbers/features/numbers_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  Future<Either<Failure, NumberTrivia>> call({required int number}) {
    return numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}
