import 'dart:async';
import 'dart:collection';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:generated_grpc_api/api/v1/api.pbgrpc.dart';
import 'package:generated_grpc_api/google/type/date.pb.dart';
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
        // 'survival-list-server.bjarkebjarke.dk',
        'survival-list-server.fly.dev',
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
        startDate: _parseDate(response.startDate),
        endDate: _parseDate(response.endDate),
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

  Date? _buildDate(DateTime? date) {
    return date == null
        ? null
        : Date(year: date.year, month: date.month, day: date.day);
  }

  DateTime? _parseDate(Date date) {
    if (date.hasYear() && date.hasMonth() && date.hasDay()) {
      return DateTime(date.year, date.month, date.day);
    }
    return null;
  }

  Future<void> updateUserInfo({
    required String? name,
    required String? pictureUrl,
  }) async {
    await _client
        .login(LoginRequest(name: name ?? '?', pictureUrl: pictureUrl));
  }

  Future<void> createItem({
    required String title,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final response = await _client.createTask(
      CreateTaskRequest(
        title: title,
        startDate: _buildDate(startDate),
        endDate: _buildDate(endDate),
      ),
    );
    _upsertItem(
      Item(
        id: response.id,
        title: response.title,
        isCompleted: false,
        startDate: _parseDate(response.startDate),
        endDate: _parseDate(response.endDate),
      ),
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
      await _client.updateTask(
        UpdateTaskRequest(
          id: newItem.id,
          title: newItem.title,
          startDate: _buildDate(newItem.startDate),
          endDate: _buildDate(newItem.endDate),
        ),
      );
    } catch (e) {
      _upsertItem(oldItem);
      rethrow;
    }
  }

  Future<void> toggleItem({
    required Item item,
    required bool isCompleted,
  }) async {
    final newItem = item.copyWith(isCompleted: () => isCompleted);
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
