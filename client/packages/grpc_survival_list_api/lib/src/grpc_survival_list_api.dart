import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc_survival_list_client/grpc_survival_list_client.dart';
import 'package:rxdart/rxdart.dart';
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

  final _isFetchingStreamController = BehaviorSubject<bool>.seeded(false);
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

    _itemsStreamController
      ..onListen = _onItemsListen
      ..onCancel = _onItemsCancel;
  }

  void _onItemsListen() {
    assert(_userNotEmptySubscription == null, 'Already listening for items');

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

  void _onItemsCancel() {
    assert(_userNotEmptySubscription != null, 'Not listening for items');
    _userNotEmptySubscription!.cancel();
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

  ResponseStream<GetTasksResponse>? _pendingItemsResponse;
  Future<void> _fetchItems() async {
    if (_pendingItemsResponse != null) {
      unawaited(_pendingItemsResponse!.cancel());
      _pendingItemsResponse = null;
    } else {
      _isFetchingStreamController.add(true);
    }

    _pendingItemsResponse = _client.getTasks(GetTasksRequest());
    final result = <Item>[];
    _pendingItemsResponse!
        .map((response) => Item(id: response.id, title: response.title))
        .listen(
      result.add,
      onDone: () {
        _pendingItemsResponse = null;
        _itemsStreamController.add(result);
        _isFetchingStreamController.add(false);
      },
      cancelOnError: true,
    );
  }

  @override
  Future<void> createItem(String title) async {
    final response = await _client.createTask(CreateTaskRequest(title: title));
    _itemsStreamController.add([
      ..._itemsStreamController.value,
      Item(id: response.id, title: response.title)
    ]);
  }

  @override
  Future<void> deleteItem(int id) {
    // TODO(bba): implement deleteItem
    throw UnimplementedError();
  }

  @override
  Stream<List<Item>> get items {
    return _itemsStreamController.asBroadcastStream();
  }

  @override
  Stream<bool> get isFetching {
    return _isFetchingStreamController.asBroadcastStream();
  }

  @override
  Future<void> updateItem(Item item) {
    // TODO(bba): implement updateItem
    throw UnimplementedError();
  }
}
