import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:numbers/features/numbers_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers/features/numbers_trivia/domain/usecases/get_random_number_trivia.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}
@GenerateMocks([NumberTriviaRepository])
import 'get_random_number_trivia_test.mocks.dart';

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  var testNumber = 1;
  var testNumberTrivia = NumberTrivia(text: 'test', number: testNumber);

  test("should get a random trivia from the repository", () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => Right(testNumberTrivia));
    //execute
    final result = await usecase.execute();
    //verify
    expect(result, Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
