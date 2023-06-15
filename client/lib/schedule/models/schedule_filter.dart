import 'package:survival_list_repository/survival_list_repository.dart';

enum ScheduleViewFilter { all, unchecked, responsible, friends }

extension ScheduleViewFilterX on ScheduleViewFilter {
  bool _filter(Item item, Person? viewer) {
    switch (this) {
      case ScheduleViewFilter.all:
        return !item.isFriendTask;
      case ScheduleViewFilter.unchecked:
        return !item.isFriendTask && !item.isCompleted;
      case ScheduleViewFilter.responsible:
        return !item.isFriendTask && item.responsible == viewer;
      case ScheduleViewFilter.friends:
        return item.isFriendTask && !item.isCompleted;
    }
  }

  Iterable<Item> apply(Iterable<Item> todos, Person? viewer) {
    return todos.where((t) => _filter(t, viewer));
  }
}
