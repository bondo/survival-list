import 'package:survival_list_repository/survival_list_repository.dart';

enum ScheduleViewFilter { all, activeOnly, completedOnly }

extension ScheduleViewFilterX on ScheduleViewFilter {
  bool _filter(Item item) {
    switch (this) {
      case ScheduleViewFilter.all:
        return true;
      case ScheduleViewFilter.activeOnly:
        return !item.isCompleted;
      case ScheduleViewFilter.completedOnly:
        return item.isCompleted;
    }
  }

  Iterable<Item> apply(Iterable<Item> todos) {
    return todos.where(_filter);
  }
}
