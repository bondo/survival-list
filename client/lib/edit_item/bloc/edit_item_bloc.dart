import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({
    required SurvivalListRepository survivalListRepository,
    required Item item,
  })  : _survivalListRepository = survivalListRepository,
        super(
          EditItemState(
            item: item,
            title: item.title,
            startDate: item.startDate,
            endDate: item.endDate,
            estimate: item.estimate,
            group: item.group,
            responsible: item.responsible,
          ),
        ) {
    on<EditItemTitleChanged>(_onTitleChanged);
    on<EditItemStartDateChanged>(_onStartDateChanged);
    on<EditItemEndDateChanged>(_onEndDateChanged);
    on<EditItemEstimateChanged>(_onEstimateChanged);
    on<EditItemGroupChanged>(_onGroupChanged);
    on<EditItemResponsibleChanged>(_onResponsibleChanged);
    on<EditItemSubmitted>(_onSubmitted);
    on<EditItemSubscriptionRequested>(_onSubscriptionRequested);
    on<EditItemGroupParticipantsSubscriptionRequested>(
      _onGroupParticipantsSubscriptionRequested,
    );
  }

  final SurvivalListRepository _survivalListRepository;

  void _onTitleChanged(
    EditItemTitleChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(title: () => event.title));
  }

  void _onStartDateChanged(
    EditItemStartDateChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(startDate: () => event.startDate));
  }

  void _onEndDateChanged(
    EditItemEndDateChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(endDate: () => event.endDate));
  }

  void _onEstimateChanged(
    EditItemEstimateChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(estimate: () => event.estimate));
  }

  void _onGroupChanged(
    EditItemGroupChanged event,
    Emitter<EditItemState> emit,
  ) {
    final group = event.group;
    if (group != null) {
      emit(state.copyWith(group: () => group));
      add(EditItemGroupParticipantsSubscriptionRequested(group));
    } else {
      emit(
        state.copyWith(
          group: () => group,
          groupParticipantsStatus: () => EditItemStatus.success,
          groupParticipants: () => [],
        ),
      );
    }
    add(const EditItemResponsibleChanged(null));
  }

  void _onResponsibleChanged(
    EditItemResponsibleChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(responsible: () => event.responsible));
  }

  Future<void> _onSubmitted(
    EditItemSubmitted event,
    Emitter<EditItemState> emit,
  ) async {
    emit(state.copyWith(status: () => EditItemStatus.loading));
    final item = state.item.copyWith(
      title: () => state.title,
      startDate: () => state.startDate,
      endDate: () => state.endDate,
      estimate: () => state.estimate,
      group: () => state.group,
      responsible: () => state.responsible,
    );

    try {
      await _survivalListRepository.updateItem(item);
      emit(state.copyWith(status: () => EditItemStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => EditItemStatus.failure));
    }
  }

  Future<void> _onSubscriptionRequested(
    EditItemSubscriptionRequested event,
    Emitter<EditItemState> emit,
  ) async {
    emit(state.copyWith(groupsStatus: () => EditItemStatus.loading));

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
        groupsStatus: () =>
            data.isFetching ? EditItemStatus.loading : EditItemStatus.success,
        groups: () => data.groups,
        viewerPerson: () => data.viewerPerson,
      ),
      onError: (_, __) => state.copyWith(
        groupsStatus: () => EditItemStatus.failure,
      ),
    );
  }

  Future<void> _onGroupParticipantsSubscriptionRequested(
    EditItemGroupParticipantsSubscriptionRequested event,
    Emitter<EditItemState> emit,
  ) async {
    final group = event.group;
    if (group == null) {
      return;
    }

    emit(state.copyWith(groupParticipantsStatus: () => EditItemStatus.loading));

    await emit.forEach(
      CombineLatestStream.combine2(
        _survivalListRepository.groupParticipants(group),
        _survivalListRepository.isFetchingGroupParticipants,
        (List<Person> groupParticipants, bool isFetching) =>
            (groupParticipants: groupParticipants, isFetching: isFetching),
      ),
      onData: (data) => state.copyWith(
        groupParticipantsStatus: () =>
            data.isFetching ? EditItemStatus.loading : EditItemStatus.success,
        groupParticipants: () => data.groupParticipants,
      ),
      onError: (_, __) => state.copyWith(
        groupParticipantsStatus: () => EditItemStatus.failure,
      ),
    );
  }
}
