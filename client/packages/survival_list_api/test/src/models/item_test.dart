// ignore_for_file: avoid_redundant_argument_values
import 'package:survival_list_api/survival_list_api.dart';
import 'package:test/test.dart';

void main() {
  group('Item', () {
    Item createSubject({
      int id = 1,
      String title = 'title',
      bool isCompleted = true,
    }) {
      return Item(
        id: id,
        title: title,
        isCompleted: isCompleted,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          1, // id
          'title', // title
          true, // isCompleted
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            id: null,
            title: null,
            isCompleted: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            id: 2,
            title: 'new title',
            isCompleted: false,
          ),
          equals(
            createSubject(
              id: 2,
              title: 'new title',
              isCompleted: false,
            ),
          ),
        );
      });
    });
  });
}
