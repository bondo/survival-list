part of 'edit_group_bloc.dart';

abstract class EditGroupEvent extends Equatable {
  const EditGroupEvent();

  @override
  List<Object> get props => [];
}

class EditGroupTitleChanged extends EditGroupEvent {
  const EditGroupTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditGroupSubmitted extends EditGroupEvent {
  const EditGroupSubmitted();
}
