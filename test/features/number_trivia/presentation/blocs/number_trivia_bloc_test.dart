import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/core/error/failure.dart';
import 'package:numbers/core/utils/input_converter.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:numbers/features/numbers_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers/features/numbers_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers/features/numbers_trivia/presentation/bloc/number_trivia_bloc.dart';
@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  tearDown(() {
    numberTriviaBloc.close();
  });
  test('number trivia should have empty state when initialized', () {
    expect(numberTriviaBloc.state, Empty());
  });
  group('get random number trivia event', () {
    const testNumberTrivia = NumberTrivia(text: 'test', number: 1);
    blocTest(
      'should get data from get random number trivia',
      setUp: () async {
        when(mockGetRandomNumberTrivia()).thenAnswer(
            (realInvocation) async => const Right(testNumberTrivia));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      verify: (bloc) {
        verify(mockGetRandomNumberTrivia());
      },
    );
    blocTest(
      'should emit [loading,error] state with server failure message when get random number trivia call fails with server failure',
      setUp: () {
        when(mockGetRandomNumberTrivia())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ],
      verify: (bloc) {
        verify(mockGetRandomNumberTrivia());
      },
    );

    blocTest(
      'should emit [loading,error] state with cache failure message when get random number trivia call fails with cache failure',
      setUp: () {
        when(mockGetRandomNumberTrivia())
            .thenAnswer((realInvocation) async => Left(CacheFailure()));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      expect: () =>
          <NumberTriviaState>[Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
      verify: (bloc) {
        verify(mockGetRandomNumberTrivia());
      },
    );

    blocTest(
      'should emit [loading,loaded] state when get random number trivia is call is successful',
      setUp: () {
        when(mockGetRandomNumberTrivia()).thenAnswer(
            (realInvocation) async => const Right(testNumberTrivia));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(numberTrivia: testNumberTrivia)
      ],
      verify: (bloc) {
        verify(mockGetRandomNumberTrivia());
      },
    );
  });
  group('get concrete number trivia event', () {
    const testNumberString = '1';
    const testNumberParsed = 1;
    const testNumberTrivia = NumberTrivia(text: 'test', number: 1);
    blocTest(
      'should get data from get concrete number trivia',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(testNumberString))
            .thenReturn(Right(testNumberParsed));
        when(mockGetConcreteNumberTrivia(number: testNumberParsed)).thenAnswer(
            (realInvocation) async => const Right(testNumberTrivia));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) {
        bloc.add(GetConcreteNumberTriviaEvent(testNumberString));
      },
      verify: (bloc) {
        verify(mockGetConcreteNumberTrivia(number: testNumberParsed));
      },
    );
    blocTest(
      'should emit error state with invalid input message when invalid input is entered',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InputFailure()));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetConcreteNumberTriviaEvent(testNumberString)),
      expect: () => <NumberTriviaState>[Error(message: INVALID_INPUT_MESSAGE)],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
      },
    );

    blocTest(
      'should emit [loading,error] state with server failure message when get concrete number trivia call fails with server failure',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(testNumberParsed));
        when(mockGetConcreteNumberTrivia(number: testNumberParsed))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetConcreteNumberTriviaEvent(testNumberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
        verify(mockGetConcreteNumberTrivia(number: testNumberParsed));
      },
    );
    blocTest(
      'should emit [loading,error] state with cache failure message when get concrete number trivia call fails with cache failure',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(testNumberParsed));
        when(mockGetConcreteNumberTrivia(number: testNumberParsed))
            .thenAnswer((realInvocation) async => Left(CacheFailure()));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetConcreteNumberTriviaEvent(testNumberString)),
      expect: () =>
          <NumberTriviaState>[Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
        verify(mockGetConcreteNumberTrivia(number: testNumberParsed));
      },
    );
    blocTest(
      'should emit [loading, loaded] states when get concrete number trivia call with unsigned int is successful',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(testNumberParsed));
        when(mockGetConcreteNumberTrivia(number: testNumberParsed)).thenAnswer(
            (realInvocation) async => const Right(testNumberTrivia));
      },
      build: () => numberTriviaBloc,
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetConcreteNumberTriviaEvent(testNumberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(numberTrivia: testNumberTrivia)
      ],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
        verify(mockGetConcreteNumberTrivia(number: testNumberParsed));
      },
    );
  });
}
