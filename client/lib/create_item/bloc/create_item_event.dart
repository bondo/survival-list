part of 'create_item_bloc.dart';

abstract class CreateItemEvent extends Equatable {
  const CreateItemEvent();

  @override
  List<Object> get props => [];
}

class CreateItemTitleChanged extends CreateItemEvent {
  const CreateItemTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class CreateItemSubmitted extends CreateItemEvent {
  const CreateItemSubmitted();
}
