import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:survival_list/src/authentication_controller.dart';
import 'package:survival_list/src/generated/api/v1/api.pbgrpc.dart';
import 'package:survival_list/src/survival/survival_item.dart';

class Client {
  static late APIClient _client;
  static late AuthenticationController _authenticationController;

  static initialize(AuthenticationController authenticationController) {
    _authenticationController = authenticationController;

    if (kDebugMode) {
      final channel = ClientChannel('10.0.2.2',
          port: 8080,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));
      _client = APIClient(channel,
          options: CallOptions(
              timeout: const Duration(seconds: 30),
              providers: [_authProvider]));
    } else {
      final channel = ClientChannel('survival-list-server.bjarkebjarke.dk',
          port: 443,
          options:
              const ChannelOptions(credentials: ChannelCredentials.secure()));
      _client = APIClient(channel,
          options: CallOptions(
              timeout: const Duration(seconds: 30),
              providers: [_authProvider]));
    }
  }

  static Future<void> _authProvider(
      Map<String, String> metadata, String uri) async {
    if (_authenticationController.isAuthenticated()) {
      var token = await _authenticationController.user!.getIdToken();
      metadata.addEntries({'Authorization': 'Bearer $token'}.entries);
    }
  }

  static Future<List<SurvivalItem>> getTasks() {
    return _client
        .getTasks(GetTasksRequest())
        .map((task) =>
            SurvivalItem(id: task.id, title: task.title, checked: false))
        .toList();
  }

  static Future<void> createTask(String title) async {
    await _client.createTask(CreateTaskRequest(title: title));
  }
}
