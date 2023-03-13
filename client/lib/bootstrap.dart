import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/settings/settings_controller.dart';
import 'package:survival_list/settings/settings_service.dart';
import 'package:survival_list_api/survival_list_api.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

Future<void> bootstrap({
  required AuthenticationRepository authenticationRepository,
  required SurvivalListApi survivalListApi,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

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
