// ignore_for_file: prefer_const_constructors
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survival_list/login/login.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(
        () => authenticationRepository.logInWithGoogle(),
      ).thenAnswer((_) async {});
    });

    test('initial state is LoginState', () {
      expect(LoginCubit(authenticationRepository).state, LoginState());
    });

    group('logInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        verify: (_) {
          verify(() => authenticationRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithGoogle succeeds',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success)
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails due to LogInWithGoogleFailure',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(LogInWithGoogleFailure('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'oops',
          )
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails due to generic exception',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure)
        ],
      );
    });
  });
}
