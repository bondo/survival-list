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
    required this.startDate,
    required this.endDate,
    this.status = EditItemStatus.initial,
  });

  final EditItemStatus status;
  final Item item;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  EditItemState copyWith({
    EditItemStatus Function()? status,
    Item Function()? item,
    String Function()? title,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
  }) {
    return EditItemState(
      status: status != null ? status() : this.status,
      item: item != null ? item() : this.item,
      title: title != null ? title() : this.title,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
    );
  }

  @override
  List<Object?> get props => [status, item, title, startDate, endDate];
}
