part of 'display_group_bloc.dart';

enum DisplayGroupStatus { initial, loading, success, failure }

class DisplayGroupState extends Equatable {
  const DisplayGroupState({
    required this.group,
    this.status = DisplayGroupStatus.initial,
    this.participants = const [],
  });

  final Group group;
  final DisplayGroupStatus status;
  final List<Person> participants;

  DisplayGroupState copyWith({
    Group Function()? group,
    DisplayGroupStatus Function()? status,
    List<Person> Function()? participants,
  }) {
    return DisplayGroupState(
      group: group != null ? group() : this.group,
      status: status != null ? status() : this.status,
      participants: participants != null ? participants() : this.participants,
    );
  }

  @override
  List<Object?> get props => [group, status, participants];
}
