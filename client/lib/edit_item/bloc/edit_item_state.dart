part of 'edit_item_bloc.dart';

enum EditItemStatus { initial, loading, success, failure }

extension EditItemStatusX on EditItemStatus {
  bool get isLoadingOrSuccess => [
        EditItemStatus.loading,
        EditItemStatus.success,
      ].contains(this);
}

class EditItemState extends Equatable {
  const EditItemState({
    required this.group,
    required this.item,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.status = EditItemStatus.initial,
    this.groups = const [],
    this.groupsStatus = EditItemStatus.initial,
  });

  final EditItemStatus status;
  final Group? group;
  final List<Group> groups;
  final EditItemStatus groupsStatus;
  final Item item;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  EditItemState copyWith({
    EditItemStatus Function()? status,
    Group? Function()? group,
    List<Group> Function()? groups,
    EditItemStatus Function()? groupsStatus,
    Item Function()? item,
    String Function()? title,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
  }) {
    return EditItemState(
      status: status != null ? status() : this.status,
      group: group != null ? group() : this.group,
      groups: groups != null ? groups() : this.groups,
      groupsStatus: groupsStatus != null ? groupsStatus() : this.groupsStatus,
      item: item != null ? item() : this.item,
      title: title != null ? title() : this.title,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
    );
  }

  @override
  List<Object?> get props =>
      [status, group, groups, groupsStatus, item, title, startDate, endDate];
}
