import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaModel numberTriviaModel;
  setUp(() {
    numberTriviaModel = const NumberTriviaModel(number: 1, text: 'Test');
  });
  test('should be a NumberTrivia entity ', () {
    //execute
    // final result = NumberTriviaModel.fromJson(trivia.json);
    //assert
    expect(numberTriviaModel, isA<NumberTrivia>());
  });
  group('fromJson', () {
    test(
        'should return a NumberTriviaModel from trivia.json when number is int',
        () {
      final trivia = json.decode(fixture('trivia'));
      final result = NumberTriviaModel.fromJson(trivia);
      expect(result, numberTriviaModel);
    });
    test(
        'should return a NumberTriviaModel from trivia.json when number is double',
        () {
      final trivia = json.decode(fixture('trivia_double'));
      final result = NumberTriviaModel.fromJson(trivia);
      expect(result, numberTriviaModel);
    });
  });
  group('toJson', () {
    test('should return a json from a NumberTriviaModel ', () {
      final expectedJson = {
        "text": "Test",
        "number": 1,
      };
      final result = numberTriviaModel.toJson();
      expect(result, expectedJson);
    });
  });
}
