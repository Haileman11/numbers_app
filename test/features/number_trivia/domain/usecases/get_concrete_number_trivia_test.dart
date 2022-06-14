import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:numbers/features/numbers_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers/features/numbers_trivia/domain/usecases/get_concrete_number_trivia.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}
@GenerateMocks([NumberTriviaRepository])
import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  var testNumber = 1;
  var testNumberTrivia = NumberTrivia(text: 'test', number: testNumber);

  test("should get a trivia for the number from the repository", () async {
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber))
        .thenAnswer((realInvocation) async => Right(testNumberTrivia));
    //execute
    final result = await usecase.execute(number: testNumber);
    //verify
    expect(result, Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
