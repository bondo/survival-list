import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:survival_list/src/authentication_controller.dart';

import 'firebase_options.dart';
import 'src/api/client.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9090);
  }

  final authenticationController =
      AuthenticationController(FirebaseAuth.instance);

  authenticationController.initialize();

  Client.initialize(authenticationController);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  if (settingsController.locale != null) {
    // TODO: Update on locale change
    Intl.systemLocale = settingsController.locale.toString();
  }

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(SurvivalListApp(
      authenticationController: authenticationController,
      settingsController: settingsController));
}
