part of 'join_group_bloc.dart';

enum JoinGroupStatus { initial, loading, success, failure }

extension JoinGroupStatusX on JoinGroupStatus {
  bool get isLoadingOrSuccess => [
        JoinGroupStatus.loading,
        JoinGroupStatus.success,
      ].contains(this);
}

class JoinGroupState extends Equatable {
  const JoinGroupState({
    this.status = JoinGroupStatus.initial,
  });

  final JoinGroupStatus status;

  JoinGroupState copyWith({
    JoinGroupStatus Function()? status,
  }) {
    return JoinGroupState(
      status: status != null ? status() : this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
