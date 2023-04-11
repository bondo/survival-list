import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc({
    required SurvivalListRepository survivalListRepository,
  })  : _survivalListRepository = survivalListRepository,
        super(
          const CreateGroupState(),
        ) {
    on<CreateGroupTitleChanged>(_onTitleChanged);
    on<CreateGroupSubmitted>(_onSubmitted);
  }

  final SurvivalListRepository _survivalListRepository;

  void _onTitleChanged(
    CreateGroupTitleChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(state.copyWith(title: () => event.title));
  }

  Future<void> _onSubmitted(
    CreateGroupSubmitted event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(status: () => CreateGroupStatus.loading));

    try {
      await _survivalListRepository.createGroup(
        title: state.title,
      );
      emit(state.copyWith(status: () => CreateGroupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => CreateGroupStatus.failure));
    }
  }
}
