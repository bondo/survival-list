import 'package:flutter/widgets.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
