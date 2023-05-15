import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list/schedule/schedule.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required AuthenticationRepository authenticationRepository,
    required SurvivalListRepository survivalListRepository,
    required ScheduleViewVariant variant,
  })  : _authenticationRepository = authenticationRepository,
        _survivalListRepository = survivalListRepository,
        super(ScheduleState(variant: variant)) {
    on<ScheduleFilterChanged>(_onFilterChanged);
    on<ScheduleItemCompletionToggled>(_onItemCompletionToggled);
    on<ScheduleItemDeleted>(_onItemDeleted);
    on<ScheduleLogoutRequested>(_onLogoutRequested);
    on<ScheduleSubscriptionRequested>(_onSubscriptionRequested);
    on<ScheduleUndoDeletionRequested>(_onUndoDeletionRequested);
  }

  final AuthenticationRepository _authenticationRepository;
  final SurvivalListRepository _survivalListRepository;

  Future<void> _onSubscriptionRequested(
    ScheduleSubscriptionRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: () => ScheduleStatus.loading));

    await emit.forEach(
      CombineLatestStream.combine4(
        _authenticationRepository.user.map((user) => user.photo).distinct(),
        _survivalListRepository.items,
        _survivalListRepository.isFetchingItems,
        _survivalListRepository.viewerPerson,
        (
          String? photo,
          List<Item> items,
          bool isFetching,
          Person? viewerPerson,
        ) =>
            (
          photo: photo,
          items: items,
          isFetching: isFetching,
          viewerPerson: viewerPerson
        ),
      ),
      onData: (data) => state.copyWith(
        status: () =>
            data.isFetching ? ScheduleStatus.loading : ScheduleStatus.success,
        userPhotoUrl: () => data.photo,
        todos: () => data.items,
        viewerPerson: () => data.viewerPerson,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ScheduleStatus.failure,
      ),
    );
  }

  Future<void> _onItemCompletionToggled(
    ScheduleItemCompletionToggled event,
    Emitter<ScheduleState> emit,
  ) async {
    await _survivalListRepository.toggleItem(
      item: event.item,
      isCompleted: event.isCompleted,
    );
  }

  Future<void> _onItemDeleted(
    ScheduleItemDeleted event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(lastDeletedItem: () => event.item));
    await _survivalListRepository.deleteItem(event.item);
  }

  Future<void> _onLogoutRequested(
    ScheduleLogoutRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    await _authenticationRepository.logOut();
  }

  Future<void> _onUndoDeletionRequested(
    ScheduleUndoDeletionRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    assert(
      state.lastDeletedItem != null,
      'Last deleted item can not be null.',
    );

    final item = state.lastDeletedItem!;
    emit(state.copyWith(lastDeletedItem: () => null));
    await _survivalListRepository.createItem(
      title: item.title,
      startDate: item.startDate,
      endDate: item.endDate,
      group: item.group,
      responsible: item.responsible,
    );
  }

  void _onFilterChanged(
    ScheduleFilterChanged event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }
}
