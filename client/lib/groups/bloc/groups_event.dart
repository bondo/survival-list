part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class GroupsSubscriptionRequested extends GroupsEvent {
  const GroupsSubscriptionRequested();
}
