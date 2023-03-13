import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({
    required SurvivalListRepository survivalListRepository,
    required Item? initialItem,
  })  : _survivalListRepository = survivalListRepository,
        super(
          EditItemState(
            initialItem: initialItem,
            title: initialItem?.title ?? '',
          ),
        ) {
    on<EditItemTitleChanged>(_onTitleChanged);
    on<EditItemSubmitted>(_onSubmitted);
  }

  final SurvivalListRepository _survivalListRepository;

  void _onTitleChanged(
    EditItemTitleChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  Future<void> _onSubmitted(
    EditItemSubmitted event,
    Emitter<EditItemState> emit,
  ) async {
    emit(state.copyWith(status: EditItemStatus.loading));
    final item = (state.initialItem ?? const Item(title: '')).copyWith(
      title: state.title,
    );

    try {
      await _survivalListRepository.saveItem(item);
      emit(state.copyWith(status: EditItemStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditItemStatus.failure));
    }
  }
}
