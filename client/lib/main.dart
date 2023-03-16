import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc_survival_list_api/grpc_survival_list_api.dart';
import 'package:survival_list/bootstrap.dart';
import 'package:survival_list/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  final survivalListApi =
      GrpcSurvivalListApi(authenticationRepository: authenticationRepository);

  await bootstrap(
    authenticationRepository: authenticationRepository,
    survivalListApi: survivalListApi,
  );
}
