import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required SurvivalListRepository survivalListRepository,
  })  : _authenticationRepository = authenticationRepository,
        _survivalListRepository = survivalListRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _sendUserInfo(authenticationRepository.currentUser);
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final SurvivalListRepository _survivalListRepository;
  late final StreamSubscription<User> _userSubscription;

  void _sendUserInfo(User user) {
    if (user.isNotEmpty) {
      unawaited(
        _survivalListRepository.updateUserInfo(
          name: user.name,
          pictureUrl: user.photo,
        ),
      );
    }
  }

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    _sendUserInfo(event.user);
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
