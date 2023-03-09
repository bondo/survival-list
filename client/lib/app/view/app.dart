import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/settings/settings_controller.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required SettingsController settingsController,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _settingsController = settingsController;

  final AuthenticationRepository _authenticationRepository;
  final SettingsController _settingsController;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: AnimatedBuilder(
          animation: _settingsController,
          builder: (context, child) {
            return AppView(
              locale: _settingsController.locale,
              themeMode: _settingsController.themeMode,
            );
          },
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    required Locale? locale,
    required ThemeMode themeMode,
    super.key,
  })  : _locale = locale,
        _themeMode = themeMode;

  final Locale? _locale;
  final ThemeMode _themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Localization
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Title
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      // Theme
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,

      // Flow
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
