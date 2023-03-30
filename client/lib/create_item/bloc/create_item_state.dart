part of 'create_item_bloc.dart';

enum CreateItemStatus { initial, loading, success, failure }

extension CreateItemStatusX on CreateItemStatus {
  bool get isLoadingOrSuccess => [
        CreateItemStatus.loading,
        CreateItemStatus.success,
      ].contains(this);
}

class CreateItemState extends Equatable {
  const CreateItemState({
    this.status = CreateItemStatus.initial,
    this.title = '',
    this.startDate,
    this.endDate,
  });

  final CreateItemStatus status;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  CreateItemState copyWith({
    CreateItemStatus Function()? status,
    String Function()? title,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
  }) {
    return CreateItemState(
      status: status != null ? status() : this.status,
      title: title != null ? title() : this.title,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
    );
  }

  @override
  List<Object?> get props => [status, title, startDate, endDate];
}
