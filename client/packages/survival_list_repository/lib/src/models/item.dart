import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

@immutable
class Item extends Equatable {
  const Item({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
    required this.estimate,
    required this.recurrence,
    required this.responsible,
    required this.group,
    required this.category,
    required this.subcategory,
    required this.canUpdate,
    required this.canToggle,
    required this.canDelete,
    required this.isFriendTask,
    required this.randSortValue,
  });

  final int id;
  final String title;
  final bool isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;
  final ShortDuration estimate;
  final Recurrence recurrence;
  final Person? responsible;
  final Group? group;
  final Category? category;
  final Subcategory? subcategory;
  final bool canUpdate;
  final bool canToggle;
  final bool canDelete;
  final bool isFriendTask;
  final double randSortValue;

  Item copyWith({
    int Function()? id,
    String Function()? title,
    bool Function()? isCompleted,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    ShortDuration Function()? estimate,
    Recurrence Function()? recurrence,
    Person? Function()? responsible,
    Group? Function()? group,
    Category? Function()? category,
    Subcategory? Function()? subcategory,
    bool Function()? canUpdate,
    bool Function()? canToggle,
    bool Function()? canDelete,
    bool Function()? isFriendTask,
    double Function()? randSortValue,
  }) {
    return Item(
      id: id != null ? id() : this.id,
      title: title != null ? title() : this.title,
      isCompleted: isCompleted != null ? isCompleted() : this.isCompleted,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      estimate: estimate != null ? estimate() : this.estimate,
      recurrence: recurrence != null ? recurrence() : this.recurrence,
      responsible: responsible != null ? responsible() : this.responsible,
      group: group != null ? group() : this.group,
      category: category != null ? category() : this.category,
      subcategory: subcategory != null ? subcategory() : this.subcategory,
      canUpdate: canUpdate != null ? canUpdate() : this.canUpdate,
      canToggle: canToggle != null ? canToggle() : this.canToggle,
      canDelete: canDelete != null ? canDelete() : this.canDelete,
      isFriendTask: isFriendTask != null ? isFriendTask() : this.isFriendTask,
      randSortValue:
          randSortValue != null ? randSortValue() : this.randSortValue,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        isCompleted,
        startDate,
        endDate,
        estimate,
        recurrence,
        responsible,
        group,
        category,
        subcategory,
        canUpdate,
        canToggle,
        canDelete,
        isFriendTask,
        randSortValue,
      ];
}
