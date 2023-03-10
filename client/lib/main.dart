import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc_survival_list_api/grpc_survival_list_api.dart';
import 'package:intl/intl.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/firebase_options.dart';
import 'package:survival_list/settings/settings_controller.dart';
import 'package:survival_list/settings/settings_service.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  final survivalListApi =
      GrpcSurvivalListApi(authenticationRepository: authenticationRepository)
        ..startServerSubscription();

  final survivalListRepository = SurvivalListRepository(api: survivalListApi);

  // TODO(bba): Blocify
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  if (settingsController.locale != null) {
    // TODO(bba): Update on locale change
    Intl.systemLocale = settingsController.locale.toString();
  }

  runZonedGuarded(
    () => runApp(
      App(
        authenticationRepository: authenticationRepository,
        settingsController: settingsController,
        survivalListRepository: survivalListRepository,
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
