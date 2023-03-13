import 'package:survival_list_repository/survival_list_repository.dart';

enum ScheduleViewFilter { all, activeOnly, completedOnly }

extension ScheduleViewFilterX on ScheduleViewFilter {
  bool apply(Item item) {
    switch (this) {
      case ScheduleViewFilter.all:
        return true;
      case ScheduleViewFilter.activeOnly:
        return !item.isCompleted;
      case ScheduleViewFilter.completedOnly:
        return item.isCompleted;
    }
  }

  Iterable<Item> applyAll(Iterable<Item> todos) {
    return todos.where(apply);
  }
}
