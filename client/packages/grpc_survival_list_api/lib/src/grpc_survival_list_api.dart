import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc_survival_list_client/grpc_survival_list_client.dart';
import 'package:rxdart/subjects.dart';
import 'package:survival_list_api/survival_list_api.dart';

/// {@template grpc_survival_list_api}
/// An implementation of the Survival List API that uses gRPC.
/// {@endtemplate}
class GrpcSurvivalListApi extends SurvivalListApi {
  /// {@macro grpc_survival_list_api}
  GrpcSurvivalListApi({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository {
    _init();
  }

  late final APIClient _client;

  final AuthenticationRepository _authenticationRepository;

  final _itemsStreamController = BehaviorSubject<List<Item>>.seeded(const []);

  StreamSubscription<bool>? _userNotEmptySubscription;

  void _init() {
    _client = APIClient(
      ClientChannel(
        'survival-list-server.bjarkebjarke.dk',
      ),
      options: CallOptions(
        timeout: const Duration(seconds: 30),
        providers: [_authProvider],
      ),
    );
  }

  void startServerSubscription() {
    endServerSubscription();

    if (_authenticationRepository.currentUser.isNotEmpty) {
      unawaited(_fetchItems());
    }
    _userNotEmptySubscription = _authenticationRepository.user
        .map((u) => u.isNotEmpty)
        .distinct()
        .listen((isNotEmpty) {
      if (isNotEmpty) {
        unawaited(_fetchItems());
      } else {
        _itemsStreamController.add(const []);
      }
    });
  }

  void endServerSubscription() {
    _userNotEmptySubscription?.cancel();
    _userNotEmptySubscription = null;
  }

  Future<void> _authProvider(
    Map<String, String> metadata,
    String uri,
  ) async {
    final token = await _authenticationRepository.currentToken;
    if (token != null) {
      metadata.addEntries({'Authorization': 'Bearer $token'}.entries);
    }
  }

  Future<void> _fetchItems() async {
    final items = await _client
        .getTasks(GetTasksRequest())
        .map((result) => Item(id: result.id, title: result.title))
        .toList();
    _itemsStreamController.add(items);
  }

  @override
  Future<void> createItem(String title) async {
    await _client.createTask(CreateTaskRequest(title: title));
  }

  @override
  Future<void> deleteItem(int id) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Stream<List<Item>> getItems() => _itemsStreamController.asBroadcastStream();

  @override
  Future<void> updateItem(Item item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }
}
