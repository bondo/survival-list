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
  });

  final CreateItemStatus status;
  final String title;

  CreateItemState copyWith({
    CreateItemStatus? status,
    String? title,
  }) {
    return CreateItemState(
      status: status ?? this.status,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [status, title];
}
