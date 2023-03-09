import 'package:authentication_repository/authentication_repository.dart';
import 'package:grpc/grpc.dart';
import 'package:survival_list/generated/api/v1/api.pbgrpc.dart';
import 'package:survival_list/src/survival/survival_item.dart';

class Client {
  static late APIClient _client;
  static late AuthenticationRepository _authenticationRepository;

  static void initialize(AuthenticationRepository authenticationRepository) {
    _authenticationRepository = authenticationRepository;

    final channel = ClientChannel(
      'survival-list-server.bjarkebjarke.dk',
    );
    _client = APIClient(
      channel,
      options: CallOptions(
        timeout: const Duration(seconds: 30),
        providers: [_authProvider],
      ),
    );
  }

  static Future<void> _authProvider(
    Map<String, String> metadata,
    String uri,
  ) async {
    final token = await _authenticationRepository.currentToken;
    if (token != null) {
      metadata.addEntries({'Authorization': 'Bearer $token'}.entries);
    }
  }

  static Future<List<SurvivalItem>> getTasks() {
    return _client
        .getTasks(GetTasksRequest())
        .map(
          (task) =>
              SurvivalItem(id: task.id, title: task.title, checked: false),
        )
        .toList();
  }

  static Future<void> createTask(String title) async {
    await _client.createTask(CreateTaskRequest(title: title));
  }
}
