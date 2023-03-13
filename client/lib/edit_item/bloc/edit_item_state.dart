part of 'edit_item_bloc.dart';

enum EditItemStatus { initial, loading, success, failure }

extension EditItemStatusX on EditItemStatus {
  bool get isLoadingOrSuccess => [
        EditItemStatus.loading,
        EditItemStatus.success,
      ].contains(this);
}

class EditItemState extends Equatable {
  const EditItemState({
    this.status = EditItemStatus.initial,
    this.initialItem,
    this.title = '',
  });

  final EditItemStatus status;
  final Item? initialItem;
  final String title;

  bool get isNewItem => initialItem == null;

  EditItemState copyWith({
    EditItemStatus? status,
    Item? initialItem,
    String? title,
    String? description,
  }) {
    return EditItemState(
      status: status ?? this.status,
      initialItem: initialItem ?? this.initialItem,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [status, initialItem, title];
}
