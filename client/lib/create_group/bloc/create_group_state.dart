part of 'create_group_bloc.dart';

enum CreateGroupStatus { initial, loading, success, failure }

extension CreateGroupStatusX on CreateGroupStatus {
  bool get isLoadingOrSuccess => [
        CreateGroupStatus.loading,
        CreateGroupStatus.success,
      ].contains(this);
}

class CreateGroupState extends Equatable {
  const CreateGroupState({
    this.status = CreateGroupStatus.initial,
    this.title = '',
  });

  final CreateGroupStatus status;
  final String title;

  CreateGroupState copyWith({
    CreateGroupStatus Function()? status,
    String Function()? title,
  }) {
    return CreateGroupState(
      status: status != null ? status() : this.status,
      title: title != null ? title() : this.title,
    );
  }

  @override
  List<Object?> get props => [status, title];
}
