part of 'groups_bloc.dart';

enum GroupsStatus { initial, loading, success, failure }

class GroupsState extends Equatable {
  const GroupsState({
    this.status = GroupsStatus.initial,
    this.groups = const [],
  });

  final GroupsStatus status;
  final List<Group> groups;

  GroupsState copyWith({
    GroupsStatus Function()? status,
    List<Group> Function()? groups,
  }) {
    return GroupsState(
      status: status != null ? status() : this.status,
      groups: groups != null ? groups() : this.groups,
    );
  }

  @override
  List<Object?> get props => [status, groups];
}
