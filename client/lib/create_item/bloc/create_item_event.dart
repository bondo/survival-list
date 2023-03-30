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

class CreateItemStartDateChanged extends CreateItemEvent {
  const CreateItemStartDateChanged(this.startDate);

  final DateTime? startDate;

  @override
  List<Object> get props => [startDate ?? 'null'];
}

class CreateItemEndDateChanged extends CreateItemEvent {
  const CreateItemEndDateChanged(this.endDate);

  final DateTime? endDate;

  @override
  List<Object> get props => [endDate ?? 'null'];
}

class CreateItemSubmitted extends CreateItemEvent {
  const CreateItemSubmitted();
}
