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
    on<ScheduleOrderChanged>(_onOrderChanged);
    on<ScheduleItemCompletionToggled>(_onItemCompletionToggled);
    on<ScheduleLogoutRequested>(_onLogoutRequested);
    on<ScheduleSubscriptionRequested>(_onSubscriptionRequested);
    on<ScheduleRefreshRequested>(_onRefreshRequested);
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

  Future<void> _onLogoutRequested(
    ScheduleLogoutRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    await _authenticationRepository.logOut();
  }

  void _onFilterChanged(
    ScheduleFilterChanged event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  void _onOrderChanged(
    ScheduleOrderChanged event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(order: () => event.order));
  }

  void _onRefreshRequested(
    ScheduleRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) {
    _survivalListRepository.refreshItems();
  }
}
