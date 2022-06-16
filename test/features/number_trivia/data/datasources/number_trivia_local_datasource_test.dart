import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/core/error/exception.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
@GenerateMocks([SharedPreferences])
import 'number_trivia_local_datasource_test.mocks.dart';

void main() {
  late NumberTriviaLocalDatasourceImpl numberTriviaLocalDatasourceImpl;
  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDatasourceImpl =
        NumberTriviaLocalDatasourceImpl(mockSharedPreferences);
  });
  NumberTriviaModel numberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia')));
  group('cacheNumberTrivia', () {
    test(
        'should call sharedpreferences setString when cacheNumberTrivia is called',
        () {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      numberTriviaLocalDatasourceImpl.cacheNumberTrivia(numberTriviaModel);
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, numberTriviaModel.toJson().toString()));
    });
  });
  group('getCachedNumberTrivia', () {
    test('should return NumberTrivia when getCachedNumberTrivia is called',
        () async {
      when(mockSharedPreferences.getString(
        any,
      )).thenAnswer((_) => fixture('trivia'));
      final result =
          await numberTriviaLocalDatasourceImpl.getCachedNumberTrivia();
      verify(mockSharedPreferences.getString(
        CACHED_NUMBER_TRIVIA,
      ));
      expect(result, numberTriviaModel);
    });
    test('should throw a CacheException when there is no cache', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = numberTriviaLocalDatasourceImpl.getCachedNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });
}
