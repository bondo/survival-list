// ignore_for_file: prefer_const_constructors
import 'package:survival_list_api/survival_list_api.dart';
import 'package:test/test.dart';

class TestSurvivalListApi extends SurvivalListApi {
  TestSurvivalListApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('SurvivalListApi', () {
    test('can be constructed', () {
      expect(TestSurvivalListApi.new, returnsNormally);
    });
  });
}
