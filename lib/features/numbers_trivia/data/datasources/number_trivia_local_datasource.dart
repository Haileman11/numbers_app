import 'dart:convert';

import 'package:numbers/core/error/exception.dart';
import 'package:numbers/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDatasource {
  Future<NumberTrivia> getCachedNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) async {
    await sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, numberTrivia.toJson().toString());
  }

  @override
  Future<NumberTrivia> getCachedNumberTrivia() {
    final cachedData = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (cachedData != null) {
      final cachedTrivia = NumberTriviaModel.fromJson(json.decode(cachedData));
      return Future.value(cachedTrivia);
    } else {
      throw CacheException();
    }
  }
}
