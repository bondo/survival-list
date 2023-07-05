import 'package:survival_list_repository/survival_list_repository.dart';

enum _NullIs { smallest, largest }

enum ScheduleViewOrder {
  byDate,
  byEstimate,
  byRandom,
  byTitle,
}

extension ScheduleViewOrderX on ScheduleViewOrder {
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

  int compare(Item a, Item b) {
    switch (this) {
      case ScheduleViewOrder.byDate:
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

        return ScheduleViewOrder.byTitle.compare(a, b);
      case ScheduleViewOrder.byEstimate:
        final estimateCmp = a.estimate.compareTo(b.estimate);
        if (estimateCmp != 0) {
          return estimateCmp;
        }
        return ScheduleViewOrder.byTitle.compare(a, b);
      case ScheduleViewOrder.byRandom:
        return a.randSortValue.compareTo(b.randSortValue);
      case ScheduleViewOrder.byTitle:
        final titleCmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        if (titleCmp != 0) {
          return titleCmp;
        }
        return a.id.compareTo(b.id);
    }
  }
}
