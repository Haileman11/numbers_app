import 'package:dartz/dartz.dart';
import 'package:numbers/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String inputString) {
    try {
      final number = int.parse(inputString);
      if (number.isNegative) {
        throw const FormatException();
      }
      return Right(number);
    } on FormatException {
      return Left(InputFailure());
    }
  }
}

class InputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
