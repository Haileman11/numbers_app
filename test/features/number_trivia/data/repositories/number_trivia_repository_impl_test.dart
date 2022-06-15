import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/core/error/exception.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/core/network/network_info.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:numbers/features/numbers_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';

@GenerateMocks(
    [NumberTriviaLocalDatasource, NumberTriviaRemoteDatasource, NetworkInfo])
import 'number_trivia_repository_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNetworkInfo mockNetworkInfo;
  late MockNumberTriviaLocalDatasource mockNumberTriviaLocalDatasource;
  late MockNumberTriviaRemoteDatasource mockNumberTriviaRemoteDatasource;
  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockNumberTriviaLocalDatasource = MockNumberTriviaLocalDatasource();
    mockNumberTriviaRemoteDatasource = MockNumberTriviaRemoteDatasource();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: mockNumberTriviaLocalDatasource,
      remoteDataSource: mockNumberTriviaRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });
  void runTestsOnline(Function testBody) {
    group('When online ', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      testBody();
    });
  }

  void runTestsOffline(Function testBody) {
    group('When offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      testBody();
    });
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    runTestsOnline(() {
      test(
          'should check that valid data is returned when getConcreteNumberTrivia calls a remote datasource and succeeds',
          () async {
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl
            .getConcreteNumberTrivia(testNumber);
        expect(result, Right(testNumberTriviaModel));
      });
      test(
          'should check that remote data is cached when getConcreteNumberTrivia calls a remote datasource and succeeds',
          () async {
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(testNumber);
        verify(mockNumberTriviaLocalDatasource
            .cacheNumberTrivia(testNumberTriviaModel));
      });
      test(
          'should return server failure when getConcreteNumberTrivia calls a remote datasource and fails',
          () async {
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        final result = await numberTriviaRepositoryImpl
            .getConcreteNumberTrivia(testNumber);
        verify(mockNumberTriviaRemoteDatasource
            .getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDatasource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test(
          'should return a cached NumberTriviaModel when getCachedNumberTrivia calls a local datasource and succeeds',
          () async {
        when(mockNumberTriviaLocalDatasource.getCachedNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl
            .getConcreteNumberTrivia(testNumber);
        verify(mockNumberTriviaLocalDatasource.getCachedNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
        expect(result, Right(testNumberTriviaModel));
      });
      test(
          'should return CacheFailure when getCachedNumberTrivia calls a local datasource and fails',
          () async {
        when(mockNumberTriviaLocalDatasource.getCachedNumberTrivia())
            .thenThrow(CacheException());
        final result = await numberTriviaRepositoryImpl
            .getConcreteNumberTrivia(testNumber);
        verify(mockNumberTriviaLocalDatasource.getCachedNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    runTestsOnline(() {
      test(
          'should check that valid data is returned when getRandomNumberTrivia calls a remote datasource and succeeds',
          () async {
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        expect(result, Right(testNumberTriviaModel));
      });
      test(
          'should check that remote data is cached when getRandomNumberTrivia calls a remote datasource and succeeds',
          () async {
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        verify(mockNumberTriviaLocalDatasource
            .cacheNumberTrivia(testNumberTriviaModel));
      });
      test(
          'should return server failure when getRandomNumberTrivia calls a remote datasource and fails',
          () async {
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaLocalDatasource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test(
          'should return a cached NumberTriviaModel when getCachedNumberTrivia calls a local datasource and succeeds',
          () async {
        when(mockNumberTriviaLocalDatasource.getCachedNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        verify(mockNumberTriviaLocalDatasource.getCachedNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
        expect(result, Right(testNumberTriviaModel));
      });
      test(
          'should return CacheFailure when getCachedNumberTrivia calls a local datasource and fails',
          () async {
        when(mockNumberTriviaLocalDatasource.getCachedNumberTrivia())
            .thenThrow(CacheException());
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        verify(mockNumberTriviaLocalDatasource.getCachedNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
