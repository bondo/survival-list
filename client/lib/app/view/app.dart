import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/settings/settings_controller.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required SettingsController settingsController,
    required SurvivalListRepository survivalListRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _survivalListRepository = survivalListRepository,
        _settingsController = settingsController;

  final AuthenticationRepository _authenticationRepository;
  final SettingsController _settingsController;
  final SurvivalListRepository _survivalListRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _survivalListRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
          survivalListRepository: context.read<SurvivalListRepository>(),
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
      onGenerateTitle: (BuildContext context) => context.l10n.appTitle,

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
