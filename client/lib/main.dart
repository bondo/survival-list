import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/firebase_options.dart';
import 'package:survival_list/settings/settings_controller.dart';
import 'package:survival_list/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  // TODO(bba): Blocify
  // Client.initialize(authenticationRepository);

  // TODO(bba): Blocify
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  if (settingsController.locale != null) {
    // TODO(bba): Update on locale change
    Intl.systemLocale = settingsController.locale.toString();
  }

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      settingsController: settingsController,
    ),
  );
}
