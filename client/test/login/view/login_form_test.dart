import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survival_list/login/login.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_raisedButton');

  group('LoginForm', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = MockLoginCubit();
      when(() => loginCubit.state).thenReturn(const LoginState());
      when(() => loginCubit.logInWithGoogle()).thenAnswer((_) async {});
    });

    group('calls', () {
      testWidgets('logInWithGoogle when sign in with google button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginCubit.logInWithGoogle()).called(1);
      });
    });

    group('renders', () {
      testWidgets('AuthenticationFailure SnackBar when submission fails',
          (tester) async {
        whenListen(
          loginCubit,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Authentication Failure'), findsOneWidget);
      });

      testWidgets('Sign in with Google Button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });
    });
  });
}
