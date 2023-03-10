// ignore_for_file: prefer_const_constructors
import 'package:authentication_repository/authentication_repository.dart';
import 'package:grpc_survival_list_api/grpc_survival_list_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('GrpcSurvivalListApi', () {
    test('can be instantiated', () {
      expect(
        GrpcSurvivalListApi(
          authenticationRepository: MockAuthenticationRepository(),
        ),
        isNotNull,
      );
    });
  });
}
