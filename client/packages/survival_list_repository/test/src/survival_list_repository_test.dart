import 'package:mocktail/mocktail.dart';
import 'package:survival_list_api/survival_list_api.dart';
import 'package:survival_list_repository/survival_list_repository.dart';
import 'package:test/test.dart';

class MockSurvivalListApi extends Mock implements SurvivalListApi {}

class FakeItem extends Fake implements Item {}

void main() {
  group('SurvivalListRepository', () {
    late SurvivalListApi api;

    const items = [
      Item(
        id: 1,
        title: 'title 1',
      ),
      Item(
        id: 2,
        title: 'title 2',
      ),
      Item(
        id: 3,
        title: 'title 3',
        isCompleted: true,
      ),
    ];

    setUpAll(() {
      registerFallbackValue(FakeItem());
    });

    setUp(() {
      api = MockSurvivalListApi();
      when(() => api.items).thenAnswer((_) => Stream.value(items));
      when(() => api.createItem(any())).thenAnswer((_) async {});
      when(() => api.updateItem(any())).thenAnswer((_) async {});
      when(() => api.deleteItem(any())).thenAnswer((_) async {});
    });

    SurvivalListRepository createSubject() => SurvivalListRepository(api: api);

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    group('getItems', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(
          subject.items,
          isNot(throwsA(anything)),
        );

        verify(() => api.items).called(1);
      });

      test('returns stream of current list items', () {
        expect(
          createSubject().items,
          emits(items),
        );
      });
    });

    group('saveItem', () {
      test('create new item', () {
        const newItem = Item(
          title: 'new item 1 title',
        );

        final subject = createSubject();

        expect(subject.saveItem(newItem), completes);

        verify(() => api.createItem(newItem.title)).called(1);
      });

      test('update existing item', () {
        const newItem = Item(
          id: 1,
          title: 'new item 1 title',
        );

        final subject = createSubject();

        expect(subject.saveItem(newItem), completes);

        verify(() => api.updateItem(newItem)).called(1);
      });
    });

    group('deleteItem', () {
      test('makes correct api request', () {
        const deleteItemId = 2;

        final subject = createSubject();

        expect(subject.deleteItem(deleteItemId), completes);

        verify(() => api.deleteItem(deleteItemId)).called(1);
      });
    });
  });
}
