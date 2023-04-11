part of 'edit_group_bloc.dart';

enum EditGroupStatus { initial, loading, success, failure }

extension EditGroupStatusX on EditGroupStatus {
  bool get isLoadingOrSuccess => [
        EditGroupStatus.loading,
        EditGroupStatus.success,
      ].contains(this);
}

class EditGroupState extends Equatable {
  const EditGroupState({
    required this.group,
    required this.title,
    this.status = EditGroupStatus.initial,
  });

  final EditGroupStatus status;
  final Group group;
  final String title;

  EditGroupState copyWith({
    EditGroupStatus Function()? status,
    Group Function()? group,
    String Function()? title,
  }) {
    return EditGroupState(
      status: status != null ? status() : this.status,
      group: group != null ? group() : this.group,
      title: title != null ? title() : this.title,
    );
  }

  @override
  List<Object?> get props => [status, group, title];
}
