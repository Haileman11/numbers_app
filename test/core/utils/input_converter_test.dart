import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('input converter', () {
    test('should return an integer when a unsigned int input string is passed',
        () {
      const inputString = '123';
      final result = inputConverter.stringToUnsignedInteger(inputString);
      expect(result, const Right(123));
    });
    test('should return a failure when a signed int input string is passed',
        () {
      const inputString = '-123';
      final result = inputConverter.stringToUnsignedInteger(inputString);
      expect(result, Left(InputFailure()));
    });
    test('should return a failure when a non int input string is passed', () {
      const inputString = '123.0';
      final result = inputConverter.stringToUnsignedInteger(inputString);
      expect(result, Left(InputFailure()));
    });
  });
}
