part of 'display_group_bloc.dart';

abstract class DisplayGroupEvent extends Equatable {
  const DisplayGroupEvent();

  @override
  List<Object> get props => [];
}

class LeaveGroup extends DisplayGroupEvent {
  const LeaveGroup();
}

class DisplayGroupSubscriptionRequested extends DisplayGroupEvent {
  const DisplayGroupSubscriptionRequested();
}
