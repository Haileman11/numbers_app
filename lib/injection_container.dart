import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:numbers/core/network/network_info.dart';
import 'package:numbers/core/utils/input_converter.dart';
import 'package:numbers/features/numbers_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers/features/numbers_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers/features/numbers_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers/features/numbers_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers/features/numbers_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/numbers_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/numbers_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
Future<void> init() async {
  //! Feature - number trivia
  // bloc
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));
  // usecase
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  // datasources
  sl.registerLazySingleton<NumberTriviaLocalDatasource>(
      () => NumberTriviaLocalDatasourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceImpl(sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // external
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
