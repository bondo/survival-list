import 'package:mocktail/mocktail.dart';
import 'package:survival_list_api/survival_list_api.dart';
import 'package:survival_list_repository/survival_list_repository.dart';
import 'package:test/test.dart';

class MockSurvivalListApi extends Mock implements SurvivalListApi {}

void main() {
  group('SurvivalListRepository', () {
    late SurvivalListApi survivalListApi;

    setUp(() {
      survivalListApi = MockSurvivalListApi();
    });

    test('can be instantiated', () {
      expect(SurvivalListRepository(api: survivalListApi), isNotNull);
    });
  });
}
