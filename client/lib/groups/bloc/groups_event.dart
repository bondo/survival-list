part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class GroupsSubscriptionRequested extends GroupsEvent {
  const GroupsSubscriptionRequested();
}

class GroupLeft extends GroupsEvent {
  const GroupLeft(this.group);

  final Group group;

  @override
  List<Object> get props => [group];
}

class GroupsUndoDeletionRequested extends GroupsEvent {
  const GroupsUndoDeletionRequested();
}
