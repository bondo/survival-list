import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc({
    required SurvivalListRepository survivalListRepository,
  })  : _survivalListRepository = survivalListRepository,
        super(const GroupsState()) {
    on<GroupLeft>(_onGroupLeft);
    on<GroupsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final SurvivalListRepository _survivalListRepository;

  Future<void> _onSubscriptionRequested(
    GroupsSubscriptionRequested event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(status: () => GroupsStatus.loading));

    await emit.forEach(
      CombineLatestStream.combine2(
        _survivalListRepository.groups,
        _survivalListRepository.isFetchingGroups,
        (List<Group> groups, bool isFetching) => (groups: groups, isFetching: isFetching),
      ),
      onData: (data) => state.copyWith(
        status: () => data.isFetching ? GroupsStatus.loading : GroupsStatus.success,
        groups: () => data.groups,
      ),
      onError: (_, __) => state.copyWith(
        status: () => GroupsStatus.failure,
      ),
    );
  }

  Future<void> _onGroupLeft(
    GroupLeft event,
    Emitter<GroupsState> emit,
  ) {
    return _survivalListRepository.leaveGroup(event.group);
  }
}
