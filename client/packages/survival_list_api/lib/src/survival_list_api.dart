import 'dart:async';
import 'dart:collection';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:generated_grpc_api/api/v1/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list_api/survival_list_api.dart';

/// {@template survival_list_api}
/// An implementation of the Survival List API that uses gRPC.
/// {@endtemplate}
class SurvivalListApi {
  /// {@macro survival_list_api}
  SurvivalListApi({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository {
    _init();
  }

  late final APIClient _client;

  final AuthenticationRepository _authenticationRepository;

  final _isCreatingStreamController = BehaviorSubject<bool>.seeded(false);
  final _isFetchingStreamController = BehaviorSubject<bool>.seeded(false);
  final _itemsStreamController =
      BehaviorSubject<Map<int, Item>>.seeded(HashMap());

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
        _itemsStreamController.add(HashMap());
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
    final result = HashMap<int, Item>();
    _pendingItemsResponse!
        .map((response) => Item(id: response.id, title: response.title))
        .listen(
      (item) => result[item.id] = item,
      onDone: () {
        _pendingItemsResponse = null;
        _itemsStreamController.add(result);
        _isFetchingStreamController.add(false);
      },
      cancelOnError: true,
    );
  }

  Future<void> createItem(String title) async {
    assert(!_isCreatingStreamController.value, 'Cannot create while creating');

    _isCreatingStreamController.add(true);
    try {
      final response =
          await _client.createTask(CreateTaskRequest(title: title));
      final newValue = HashMap<int, Item>.from(_itemsStreamController.value);
      newValue[response.id] = Item(id: response.id, title: response.title);
      _itemsStreamController.add(newValue);
    } finally {
      _isCreatingStreamController.add(false);
    }
  }

  Future<void> deleteItem(int id) {
    // TODO(bba): implement deleteItem
    throw UnimplementedError();
  }

  Stream<Map<int, Item>> get items {
    return _itemsStreamController.asBroadcastStream();
  }

  Stream<bool> get isCreating {
    return _isCreatingStreamController.asBroadcastStream();
  }

  Stream<bool> get isFetching {
    return _isFetchingStreamController.asBroadcastStream();
  }

  Future<void> updateItem(Item item) {
    // TODO(bba): implement updateItem
    throw UnimplementedError();
  }
}
