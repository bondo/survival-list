part of 'join_group_bloc.dart';

abstract class JoinGroupEvent extends Equatable {
  const JoinGroupEvent();

  @override
  List<Object> get props => [];
}

class JoinGroupQrCodeScanned extends JoinGroupEvent {
  const JoinGroupQrCodeScanned(this.data);

  final String data;

  @override
  List<Object> get props => [data];
}
