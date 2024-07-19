import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({required this.controller, super.key});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageSettingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user
              // selects a theme.
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
                ),
              ],
            ),
            DropdownButton<Locale?>(
              value: controller.locale,
              onChanged: controller.updateLocale,
              items: [
                DropdownMenuItem<Locale?>(
                  child: Text(l10n.pageSettingsLanguageDefault),
                ),
                for (final Locale locale in AppLocalizations.supportedLocales)
                  DropdownMenuItem(
                    value: locale,
                    child: Text(
                      locale.languageCode == 'da'
                          ? l10n.pageSettingsLanguageDanish
                          : (locale.languageCode == 'en'
                              ? l10n.pageSettingsLanguageEnglish
                              : locale.toLanguageTag()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
