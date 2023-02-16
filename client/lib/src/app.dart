import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'authentication_controller.dart';
import 'survival/survival_item.dart';
import 'survival/survival_item_create_view.dart';
import 'survival/survival_item_details_view.dart';
import 'survival/survival_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class SurvivalListApp extends StatelessWidget {
  const SurvivalListApp({
    super.key,
    required this.authenticationController,
    required this.settingsController,
  });

  final AuthenticationController authenticationController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ChangeNotifierProvider(
        create: (context) => SurvivalItemListRefetchContainer(),
        child: AnimatedBuilder(
          animation:
              Listenable.merge([authenticationController, settingsController]),
          builder: (BuildContext context, Widget? child) {
            if (!authenticationController.isAuthenticated()) {
              authenticationController.signIn();
              return const Center(child: CircularProgressIndicator());
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,

              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',

              locale: settingsController.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,

              // Use AppLocalizations to configure the correct application title
              // depending on the user's locale.
              //
              // The appTitle is defined in .arb files found in the localization
              // directory.
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,

              // Define a light and dark color theme. Then, read the user's
              // preferred ThemeMode (light, dark, or system default) from the
              // SettingsController to display the correct theme.
              theme: ThemeData(),
              darkTheme: ThemeData.dark(),
              themeMode: settingsController.themeMode,

              // Define a function to handle named routes in order to support
              // Flutter web url navigation and deep linking.
              onGenerateRoute: (RouteSettings routeSettings) {
                return MaterialPageRoute<void>(
                  settings: routeSettings,
                  builder: (BuildContext context) {
                    switch (routeSettings.name) {
                      case SettingsView.routeName:
                        return SettingsView(controller: settingsController);
                      case SurvivalItemDetailsView.routeName:
                        return const SurvivalItemDetailsView();
                      case SurvivalItemCreateView.routeName:
                        return const SurvivalItemCreateView();
                      case SurvivalItemListView.routeName:
                      default:
                        return const SurvivalItemListView();
                    }
                  },
                );
              },
            );
          },
        ));
  }
}
