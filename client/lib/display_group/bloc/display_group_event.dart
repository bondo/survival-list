part of 'display_group_bloc.dart';

abstract class DisplayGroupEvent extends Equatable {
  const DisplayGroupEvent();

  @override
  List<Object> get props => [];
}

class DisplayGroupSubscriptionRequested extends DisplayGroupEvent {
  const DisplayGroupSubscriptionRequested();
}
