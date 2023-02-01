import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  Future<ThemeMode> themeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeStr = prefs.getString('theme');
    ThemeMode? themeMode = themeStr == null
        ? null
        : EnumToString.fromString(ThemeMode.values, themeStr);
    return themeMode ?? ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', EnumToString.convertToString(theme));
  }

  Future<Locale?> locale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode == null) {
      return null;
    }
    return Locale(languageCode);
  }

  Future<void> updateLocale(Locale? locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove('languageCode');
    } else {
      await prefs.setString('languageCode', locale.languageCode);
    }
  }
}
