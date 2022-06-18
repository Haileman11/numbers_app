import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/core/utils/input_converter.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const INVALID_INPUT_MESSAGE = "Invalid input, must be a non negative int";
const CACHE_FAILURE_MESSAGE = "Cache failure";
const SERVER_FAILURE_MESSAGE = "Server failure";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getRandomNumberTrivia,
    required this.getConcreteNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetConcreteNumberTriviaEvent>(_onGetConcreteNumberTriviaEvent);
    on<GetRandomNumberTriviaEvent>(_onGetRandomNumberTriviaEvent);
  }

  _onGetConcreteNumberTriviaEvent(GetConcreteNumberTriviaEvent event,
      Emitter<NumberTriviaState> emitter) async {
    final resultEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    resultEither.fold((failure) {
      emitter(Error(message: INVALID_INPUT_MESSAGE));
    }, (number) async {
      emitter(Loading());
      final resultEither = await getConcreteNumberTrivia(number: number);
      resultEither.fold(
        (failure) {
          emitter(Error(message: _mapFailureToMessage(failure)));
        },
        (numberTrivia) {
          emitter(Loaded(numberTrivia: numberTrivia));
        },
      );
    });
  }

  _onGetRandomNumberTriviaEvent(GetRandomNumberTriviaEvent event,
      Emitter<NumberTriviaState> emitter) async {
    emitter(Loading());
    final resultEither = await getRandomNumberTrivia();
    resultEither.fold((failure) {
      emitter(Error(message: _mapFailureToMessage(failure)));
    }, (numberTrivia) {
      emitter(Loaded(numberTrivia: numberTrivia));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
