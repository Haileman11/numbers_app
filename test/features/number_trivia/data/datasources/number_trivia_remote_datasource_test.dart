import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/core/error/exception.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
import 'number_trivia_remote_datasource_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDatasourceImpl remoteDatasourceImpl;
  setUp(() {
    mockClient = MockClient();
    remoteDatasourceImpl = NumberTriviaRemoteDatasourceImpl(mockClient);
  });
  group('getRandomNumberTrivia', () {
    late NumberTriviaModel numberTriviaModel;
    setUp(() {
      numberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia')));
    });
    test('should return a trivia json when get method call is successful ',
        () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(fixture('trivia'), 200));
      final result = await remoteDatasourceImpl.getRandomNumberTrivia();
      verify(mockClient.get(Uri.parse(getRandomNumberTriviaUrl)));
      expect(result, numberTriviaModel);
    });
    test('should return a ServerException when get method call fails ', () {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Something went south', 404));
      final call = remoteDatasourceImpl.getRandomNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
  group('getConcreteNumberTrivia', () {
    late NumberTriviaModel numberTriviaModel;
    int number = 1;
    setUp(() {
      numberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia')));
    });
    test('should return a trivia json when get method call is successful ',
        () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(fixture('trivia'), 200));
      final result = await remoteDatasourceImpl.getConcreteNumberTrivia(number);
      verify(mockClient.get(Uri.parse(getConcreteNumberTriviaUrl(number))));
      expect(result, numberTriviaModel);
    });
    test('should return a ServerException when get method call fails ', () {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Something went south', 404));
      final call = remoteDatasourceImpl.getConcreteNumberTrivia;
      expect(() => call(number), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
