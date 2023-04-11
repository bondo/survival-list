part of 'create_group_bloc.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupTitleChanged extends CreateGroupEvent {
  const CreateGroupTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class CreateGroupSubmitted extends CreateGroupEvent {
  const CreateGroupSubmitted();
}
