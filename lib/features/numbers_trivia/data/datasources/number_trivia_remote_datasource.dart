import 'dart:convert';
import 'dart:io';

import 'package:numbers/core/error/exception.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:numbers/features/numbers_trivia/domain/usecases/get_random_number_trivia.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<NumberTriviaModel> getRandomNumberTrivia();
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
}

const getRandomNumberTriviaUrl = 'http://numbersapi.com/random?json';
getConcreteNumberTriviaUrl(int number) => 'http://numbersapi.com/$number?json';

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client httpClient;

  NumberTriviaRemoteDatasourceImpl(this.httpClient);
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response =
        await httpClient.get(Uri.parse(getConcreteNumberTriviaUrl(number)));
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response =
        await httpClient.get(Uri.parse(getRandomNumberTriviaUrl), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
