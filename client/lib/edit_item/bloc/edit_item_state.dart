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
    required this.item,
    required this.title,
    this.status = EditItemStatus.initial,
  });

  final EditItemStatus status;
  final Item item;
  final String title;

  EditItemState copyWith({
    EditItemStatus? status,
    Item? item,
    String? title,
    String? description,
  }) {
    return EditItemState(
      status: status ?? this.status,
      item: item ?? this.item,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [status, item, title];
}
