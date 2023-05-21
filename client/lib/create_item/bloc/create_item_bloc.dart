import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  CreateItemBloc({
    required SurvivalListRepository survivalListRepository,
  })  : _survivalListRepository = survivalListRepository,
        super(const CreateItemState()) {
    on<CreateItemTitleChanged>(_onTitleChanged);
    on<CreateItemStartDateChanged>(_onStartDateChanged);
    on<CreateItemEndDateChanged>(_onEndDateChanged);
    on<CreateItemGroupChanged>(_onGroupChanged);
    on<CreateItemResponsibleChanged>(_onResponsibleChanged);
    on<CreateItemSubmitted>(_onSubmitted);
    on<CreateItemSubscriptionRequested>(_onSubscriptionRequested);
    on<CreateItemGroupParticipantsSubscriptionRequested>(
      _onGroupParticipantsSubscriptionRequested,
    );
  }

  final SurvivalListRepository _survivalListRepository;

  void _onTitleChanged(
    CreateItemTitleChanged event,
    Emitter<CreateItemState> emit,
  ) {
    emit(state.copyWith(title: () => event.title));
  }

  void _onStartDateChanged(
    CreateItemStartDateChanged event,
    Emitter<CreateItemState> emit,
  ) {
    emit(state.copyWith(startDate: () => event.startDate));
  }

  void _onEndDateChanged(
    CreateItemEndDateChanged event,
    Emitter<CreateItemState> emit,
  ) {
    emit(state.copyWith(endDate: () => event.endDate));
  }

  void _onGroupChanged(
    CreateItemGroupChanged event,
    Emitter<CreateItemState> emit,
  ) {
    final group = event.group;
    if (group != null) {
      emit(state.copyWith(group: () => group));
      add(CreateItemGroupParticipantsSubscriptionRequested(group));
    } else {
      emit(
        state.copyWith(
          group: () => group,
          groupParticipantsStatus: () => CreateItemStatus.success,
          groupParticipants: () => [],
        ),
      );
    }
    add(const CreateItemResponsibleChanged(null));
  }

  void _onResponsibleChanged(
    CreateItemResponsibleChanged event,
    Emitter<CreateItemState> emit,
  ) {
    emit(state.copyWith(responsible: () => event.responsible));
  }

  Future<void> _onSubmitted(
    CreateItemSubmitted event,
    Emitter<CreateItemState> emit,
  ) async {
    emit(state.copyWith(status: () => CreateItemStatus.loading));

    try {
      await _survivalListRepository.createItem(
        title: state.title,
        startDate: state.startDate,
        endDate: state.endDate,
        estimate: state.estimate,
        group: state.group,
        responsible: state.responsible,
      );
      emit(state.copyWith(status: () => CreateItemStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => CreateItemStatus.failure));
    }
  }

  Future<void> _onSubscriptionRequested(
    CreateItemSubscriptionRequested event,
    Emitter<CreateItemState> emit,
  ) async {
    emit(state.copyWith(groupsStatus: () => CreateItemStatus.loading));

    await emit.forEach(
      CombineLatestStream.combine3(
        _survivalListRepository.groups,
        _survivalListRepository.isFetchingGroups,
        _survivalListRepository.viewerPerson,
        (List<Group> groups, bool isFetching, Person? viewerPerson) => (
          groups: groups,
          isFetching: isFetching,
          viewerPerson: viewerPerson
        ),
      ),
      onData: (data) => state.copyWith(
        groupsStatus: () => data.isFetching
            ? CreateItemStatus.loading
            : CreateItemStatus.success,
        groups: () => data.groups,
        viewerPerson: () => data.viewerPerson,
      ),
      onError: (_, __) => state.copyWith(
        groupsStatus: () => CreateItemStatus.failure,
      ),
    );
  }

  Future<void> _onGroupParticipantsSubscriptionRequested(
    CreateItemGroupParticipantsSubscriptionRequested event,
    Emitter<CreateItemState> emit,
  ) async {
    emit(
      state.copyWith(groupParticipantsStatus: () => CreateItemStatus.loading),
    );

    await emit.forEach(
      CombineLatestStream.combine2(
        _survivalListRepository.groupParticipants(event.group),
        _survivalListRepository.isFetchingGroupParticipants,
        (List<Person> groupParticipants, bool isFetching) =>
            (groupParticipants: groupParticipants, isFetching: isFetching),
      ),
      onData: (data) => state.copyWith(
        groupParticipantsStatus: () => data.isFetching
            ? CreateItemStatus.loading
            : CreateItemStatus.success,
        groupParticipants: () => data.groupParticipants,
      ),
      onError: (_, __) => state.copyWith(
        groupParticipantsStatus: () => CreateItemStatus.failure,
      ),
    );
  }
}
