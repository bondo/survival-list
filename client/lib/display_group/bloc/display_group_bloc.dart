import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'display_group_event.dart';
part 'display_group_state.dart';

class DisplayGroupBloc extends Bloc<DisplayGroupEvent, DisplayGroupState> {
  DisplayGroupBloc({
    required SurvivalListRepository survivalListRepository,
    required Group group,
  })  : _survivalListRepository = survivalListRepository,
        super(DisplayGroupState(group: group)) {
    on<DisplayGroupSubscriptionRequested>(_onSubscriptionRequested);
    on<LeaveGroup>(_onLeaveGroup);
  }

  final SurvivalListRepository _survivalListRepository;

  Future<void> _onSubscriptionRequested(
    DisplayGroupSubscriptionRequested event,
    Emitter<DisplayGroupState> emit,
  ) async {
    emit(state.copyWith(status: () => DisplayGroupStatus.loading));

    await emit.forEach(
      CombineLatestStream.combine3(
        _survivalListRepository.getGroup(state.group.id),
        _survivalListRepository.groupParticipants(state.group),
        _survivalListRepository.isFetchingGroupParticipants,
        (Group? group, List<Person> participants, bool isFetching) =>
            (group: group, participants: participants, isFetching: isFetching),
      ),
      onData: (data) => state.copyWith(
        group: () => data.group ?? state.group,
        status: () => data.isFetching
            ? DisplayGroupStatus.loading
            : DisplayGroupStatus.success,
        participants: () => data.participants,
      ),
      onError: (_, __) => state.copyWith(
        status: () => DisplayGroupStatus.failure,
      ),
    );
  }

  Future<void> _onLeaveGroup(
    LeaveGroup event,
    Emitter<DisplayGroupState> emit,
  ) async {
    await _survivalListRepository.leaveGroup(state.group);
  }
}
