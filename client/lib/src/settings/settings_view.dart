import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageSettingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownButton<ThemeMode>(
            // Read the selected themeMode from the controller
            value: controller.themeMode,
            // Call the updateThemeMode method any time the user selects a theme.
            onChanged: controller.updateThemeMode,
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(l10n.pageSettingsThemeSystem),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(l10n.pageSettingsThemeLight),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(l10n.pageSettingsThemeDark),
              )
            ],
          ),
          DropdownButton<Locale?>(
              value: controller.locale,
              onChanged: controller.updateLocale,
              items: [
                DropdownMenuItem<Locale?>(
                  value: null,
                  child: Text(l10n.pageSettingsLanguageDefault),
                ),
                for (Locale locale in AppLocalizations.supportedLocales)
                  DropdownMenuItem(
                      value: locale,
                      child: Text(locale.languageCode == 'da'
                          ? l10n.pageSettingsLanguageDanish
                          : (locale.languageCode == 'en'
                              ? l10n.pageSettingsLanguageEnglish
                              : locale.toLanguageTag())))
              ]),
        ]),
      ),
    );
  }
}
