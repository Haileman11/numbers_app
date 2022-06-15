import 'package:numbers/core/error/exception.dart';
import 'package:numbers/core/network/network_info.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';

import 'package:numbers/core/error/failure.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDataSource;
  final NumberTriviaLocalDatasource localDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTriviaModel> Function() getTriviaHandler) async {
    if (await networkInfo.isConnected) {
      try {
        final numberTriviaModel = await getTriviaHandler();
        localDataSource.cacheNumberTrivia(numberTriviaModel);
        return Right(numberTriviaModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final numberTriviaModel = await localDataSource.getCachedNumberTrivia();
        return Right(numberTriviaModel);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
