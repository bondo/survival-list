import 'package:survival_list_repository/survival_list_repository.dart';

enum ScheduleViewVariant { survival, todo, overview }

enum _NullIs { smallest, largest }

extension ScheduleViewVariantX on ScheduleViewVariant {
  bool _filter(Item item) {
    switch (this) {
      case ScheduleViewVariant.survival:
        return item.endDate != null && item.endDate!.isBefore(DateTime.now());
      case ScheduleViewVariant.todo:
        return item.startDate == null ||
            item.startDate!.isBefore(DateTime.now());
      case ScheduleViewVariant.overview:
        return true;
    }
  }

  int _compareMaybeDateTime(DateTime? a, DateTime? b, _NullIs nullIs) {
    if (a == null && b == null) {
      return 0;
    }
    if (a == null && b != null) {
      return nullIs == _NullIs.smallest ? -1 : 1;
    }
    if (a != null && b == null) {
      return nullIs == _NullIs.smallest ? 1 : -1;
    }
    if (a != null && b != null) {
      return a.compareTo(b);
    }
    throw Exception('Unreachable');
  }

  int _compare(Item a, Item b) {
    switch (this) {
      case ScheduleViewVariant.survival:
        final endDateCmp =
            _compareMaybeDateTime(a.endDate, b.endDate, _NullIs.largest);
        if (endDateCmp != 0) {
          return endDateCmp;
        }
        return a.title.compareTo(b.title);
      case ScheduleViewVariant.todo:
        final endDateCmp =
            _compareMaybeDateTime(a.endDate, b.endDate, _NullIs.largest);
        if (endDateCmp != 0) {
          return endDateCmp;
        }
        final startDateCmp =
            _compareMaybeDateTime(a.startDate, b.startDate, _NullIs.smallest);
        if (startDateCmp != 0) {
          return startDateCmp;
        }
        return a.title.compareTo(b.title);
      case ScheduleViewVariant.overview:
        final endDateCmp =
            _compareMaybeDateTime(a.endDate, b.endDate, _NullIs.largest);
        if (endDateCmp != 0) {
          return endDateCmp;
        }
        final startDateCmp =
            _compareMaybeDateTime(a.startDate, b.startDate, _NullIs.smallest);
        if (startDateCmp != 0) {
          return startDateCmp;
        }
        return a.title.compareTo(b.title);
    }
  }

  Iterable<Item> _filterAll(Iterable<Item> todos) {
    return todos.where(_filter);
  }

  List<Item> apply(Iterable<Item> todos) {
    return _filterAll(todos).toList()..sort(_compare);
  }
}
