import 'package:survival_list_repository/survival_list_repository.dart';

enum ScheduleViewVariant { survival, todo, overview }

extension on DateTime {
  DateTime operator -(ShortDuration duration) =>
      subtract(duration.intoDuration());
}

extension ScheduleViewVariantX on ScheduleViewVariant {
  bool _filter(Item item) {
    final startDate = item.startDate;
    final endDate = item.endDate;

    switch (this) {
      case ScheduleViewVariant.survival:
        if (endDate == null) {
          return false;
        }
        return (endDate - item.estimate).isBefore(DateTime.now());
      case ScheduleViewVariant.todo:
        return startDate == null || startDate.isBefore(DateTime.now());
      case ScheduleViewVariant.overview:
        return true;
    }
  }

  Iterable<Item> _filterAll(Iterable<Item> todos) {
    return todos.where(_filter);
  }

  List<Item> apply(Iterable<Item> todos) {
    return _filterAll(todos).toList();
  }
}
