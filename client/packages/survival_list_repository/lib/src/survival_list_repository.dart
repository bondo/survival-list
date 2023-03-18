import 'dart:async';
import 'dart:collection';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:generated_grpc_api/api/v1/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

/// {@template survival_list_api}
/// An implementation of the Survival List API that uses gRPC.
/// {@endtemplate}
class SurvivalListRepository {
  /// {@macro survival_list_api}
  SurvivalListRepository({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository {
    _init();
  }

  late final APIClient _client;

  final AuthenticationRepository _authenticationRepository;

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
        .map(
      (response) => Item(
        id: response.id,
        title: response.title,
        isCompleted: response.isCompleted,
      ),
    )
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

  void _upsertItem(Item item) {
    final newValue = HashMap<int, Item>.from(_itemsStreamController.value);
    newValue[item.id] = item;
    _itemsStreamController.add(newValue);
  }

  Future<void> createItem(String title) async {
    final response = await _client.createTask(CreateTaskRequest(title: title));
    _upsertItem(
      Item(id: response.id, title: response.title, isCompleted: false),
    );
  }

  Future<void> deleteItem(Item item) async {
    final newValue = HashMap<int, Item>.from(_itemsStreamController.value)
      ..remove(item.id);
    _itemsStreamController.add(newValue);

    try {
      await _client.deleteTask(DeleteTaskRequest(id: item.id));
    } catch (e) {
      _upsertItem(item);
      rethrow;
    }
  }

  Stream<List<Item>> get items {
    return _itemsStreamController
        .asBroadcastStream()
        .map((event) => event.values.toList());
  }

  Stream<bool> get isFetching {
    return _isFetchingStreamController.asBroadcastStream();
  }

  Future<void> updateItem(Item newItem) async {
    final oldItem = _itemsStreamController.value[newItem.id];
    if (oldItem == null) {
      throw Exception('Existing item not found');
    }

    _upsertItem(newItem);

    try {
      await _client
          .updateTask(UpdateTaskRequest(id: newItem.id, title: newItem.title));
    } catch (e) {
      _upsertItem(oldItem);
      rethrow;
    }
  }

  Future<void> toggleItem({
    required Item item,
    required bool isCompleted,
  }) async {
    final newItem = item.copyWith(isCompleted: isCompleted);
    _upsertItem(newItem);

    try {
      await _client.toggleTaskCompleted(
        ToggleTaskCompletedRequest(
          id: newItem.id,
          isCompleted: newItem.isCompleted,
        ),
      );
    } catch (e) {
      _upsertItem(item);
      rethrow;
    }
  }
}
