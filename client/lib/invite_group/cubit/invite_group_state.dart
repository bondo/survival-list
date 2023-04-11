part of 'invite_group_cubit.dart';

class InviteGroupState extends Equatable {
  const InviteGroupState({
    required this.group,
  });

  final Group group;

  @override
  List<Object> get props => [group];
}
