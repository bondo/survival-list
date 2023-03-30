import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
          ),
        ) {
    on<EditItemTitleChanged>(_onTitleChanged);
    on<EditItemStartDateChanged>(_onStartDateChanged);
    on<EditItemEndDateChanged>(_onEndDateChanged);
    on<EditItemSubmitted>(_onSubmitted);
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

  Future<void> _onSubmitted(
    EditItemSubmitted event,
    Emitter<EditItemState> emit,
  ) async {
    emit(state.copyWith(status: () => EditItemStatus.loading));
    final item = state.item.copyWith(
      title: () => state.title,
      startDate: () => state.startDate,
      endDate: () => state.endDate,
    );

    try {
      await _survivalListRepository.updateItem(item);
      emit(state.copyWith(status: () => EditItemStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => EditItemStatus.failure));
    }
  }
}
