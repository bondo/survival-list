import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'invite_group_state.dart';

class InviteGroupCubit extends Cubit<InviteGroupState> {
  InviteGroupCubit(Group group) : super(InviteGroupState(group: group));
}
