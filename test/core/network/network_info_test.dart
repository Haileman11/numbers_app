import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers/core/network/network_info.dart';

@GenerateMocks([InternetConnectionChecker])
import 'network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(() async {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });
  group('when online', () {
    test('should return true when connectivity call is successful', () async {
      final testHasConnectionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => testHasConnectionFuture);

      final result = networkInfoImpl.isConnected;
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, testHasConnectionFuture);
    });
  });
}
