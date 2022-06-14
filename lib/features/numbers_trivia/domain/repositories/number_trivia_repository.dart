import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository extends Equatable {
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
}
