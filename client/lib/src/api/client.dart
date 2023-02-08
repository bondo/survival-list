import 'package:grpc/grpc.dart';
import 'package:survival_list/src/generated/api/v1/api.pbgrpc.dart';
import 'package:survival_list/src/survival/survival_item.dart';

class Client {
  static APIClient? _clientInstance;

  static APIClient get _client {
    if (_clientInstance == null) {
      final channel = ClientChannel('survival-list-server.bjarkebjarke.dk',
          port: 8080,
          options:
              const ChannelOptions(credentials: ChannelCredentials.secure()));
      _clientInstance = APIClient(channel,
          options: CallOptions(
              timeout: const Duration(seconds: 30),
              providers: [/* add authentication here */]));
    }
    return _clientInstance!;
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
