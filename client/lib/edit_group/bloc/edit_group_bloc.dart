import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'edit_group_event.dart';
part 'edit_group_state.dart';

class EditGroupBloc extends Bloc<EditGroupEvent, EditGroupState> {
  EditGroupBloc({
    required SurvivalListRepository survivalListRepository,
    required Group group,
  })  : _survivalListRepository = survivalListRepository,
        super(
          EditGroupState(
            group: group,
            title: group.title,
          ),
        ) {
    on<EditGroupTitleChanged>(_onTitleChanged);
    on<EditGroupSubmitted>(_onSubmitted);
  }

  final SurvivalListRepository _survivalListRepository;

  void _onTitleChanged(
    EditGroupTitleChanged event,
    Emitter<EditGroupState> emit,
  ) {
    emit(state.copyWith(title: () => event.title));
  }

  Future<void> _onSubmitted(
    EditGroupSubmitted event,
    Emitter<EditGroupState> emit,
  ) async {
    emit(state.copyWith(status: () => EditGroupStatus.loading));
    final group = state.group.copyWith(
      title: () => state.title,
    );

    try {
      await _survivalListRepository.updateGroup(group);
      emit(state.copyWith(status: () => EditGroupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => EditGroupStatus.failure));
    }
  }
}
