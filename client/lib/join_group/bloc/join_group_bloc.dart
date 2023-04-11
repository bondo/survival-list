import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  JoinGroupBloc({
    required SurvivalListRepository survivalListRepository,
  })  : _survivalListRepository = survivalListRepository,
        super(const JoinGroupState()) {
    on<JoinGroupQrCodeScanned>(_onQrCodeScanned);
  }

  final SurvivalListRepository _survivalListRepository;

  Future<void> _onQrCodeScanned(
    JoinGroupQrCodeScanned event,
    Emitter<JoinGroupState> emit,
  ) async {
    emit(state.copyWith(status: () => JoinGroupStatus.loading));
    try {
      await _survivalListRepository.joinGroup(
        uid: event.data,
      );
      emit(state.copyWith(status: () => JoinGroupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => JoinGroupStatus.failure));
    }
  }
}
