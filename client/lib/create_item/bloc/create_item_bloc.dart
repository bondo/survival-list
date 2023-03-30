import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  CreateItemBloc({
    required SurvivalListRepository survivalListRepository,
  })  : _survivalListRepository = survivalListRepository,
        super(
          const CreateItemState(),
        ) {
    on<CreateItemTitleChanged>(_onTitleChanged);
    on<CreateItemStartDateChanged>(_onStartDateChanged);
    on<CreateItemEndDateChanged>(_onEndDateChanged);
    on<CreateItemSubmitted>(_onSubmitted);
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
      );
      emit(state.copyWith(status: () => CreateItemStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => CreateItemStatus.failure));
    }
  }
}
