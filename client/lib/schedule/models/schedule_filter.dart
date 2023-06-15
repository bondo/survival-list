import 'package:survival_list_repository/survival_list_repository.dart';

enum ScheduleViewFilter { all, unchecked, responsible }

extension ScheduleViewFilterX on ScheduleViewFilter {
  bool _filter(Item item, Person? viewer) {
    if (item.isFriendTask) {
      return false;
    }
    switch (this) {
      case ScheduleViewFilter.all:
        return true;
      case ScheduleViewFilter.unchecked:
        return !item.isCompleted;
      case ScheduleViewFilter.responsible:
        return item.responsible == viewer;
    }
  }

  Iterable<Item> apply(Iterable<Item> todos, Person? viewer) {
    return todos.where((t) => _filter(t, viewer));
  }
}
