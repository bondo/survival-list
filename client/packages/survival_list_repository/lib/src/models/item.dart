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
    required this.canUpdate,
    required this.canToggle,
    required this.canDelete,
    required this.isFriendTask,
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
  final bool canUpdate;
  final bool canToggle;
  final bool canDelete;
  final bool isFriendTask;

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
    bool Function()? canUpdate,
    bool Function()? canToggle,
    bool Function()? canDelete,
    bool Function()? isFriendTask,
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
      canUpdate: canUpdate != null ? canUpdate() : this.canUpdate,
      canToggle: canToggle != null ? canToggle() : this.canToggle,
      canDelete: canDelete != null ? canDelete() : this.canDelete,
      isFriendTask: isFriendTask != null ? isFriendTask() : this.isFriendTask,
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
        canUpdate,
        canToggle,
        canDelete,
        isFriendTask,
      ];
}
