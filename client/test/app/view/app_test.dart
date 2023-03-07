import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survival_list/app/app.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/login/login.dart';
import 'package:survival_list/settings/settings_controller.dart';

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockSettingsController extends Mock implements SettingsController {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late SettingsController settingsController;
    late User user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      settingsController = MockSettingsController();
      user = MockUser();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => settingsController.themeMode).thenReturn(ThemeMode.system);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: authenticationRepository,
          settingsController: settingsController,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AuthenticationRepository authenticationRepository;
    late AppBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: appBloc,
              child: const AppView(
                locale: null,
                themeMode: ThemeMode.system,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: appBloc,
              child: const AppView(
                locale: null,
                themeMode: ThemeMode.system,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
