import 'dart:async';
import 'dart:collection';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:generated_grpc_api/api/v1/api.pbgrpc.dart' as api;
import 'package:generated_grpc_api/google/type/date.pb.dart' as google;
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

  late final api.APIClient _client;

  final AuthenticationRepository _authenticationRepository;

  void _init() {
    _client = api.APIClient(
      ClientChannel('survival-list-server.fly.dev'),
      options: CallOptions(
        timeout: const Duration(seconds: 30),
        providers: [_authProvider],
      ),
    );

    _itemsStreamController
      ..onListen = _onItemsListen
      ..onCancel = _onItemsCancel;

    _groupsStreamController
      ..onListen = _onGroupsListen
      ..onCancel = _onGroupsCancel;
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

  /*+++++++++++++++*
   + VIEWER PERSON +
   *+++++++++++++++*/

  final _viewerPersonStreamController = BehaviorSubject<Person?>.seeded(null);

  Stream<Person?> get viewerPerson {
    return _viewerPersonStreamController.asBroadcastStream();
  }

  /*+++++++*
   + ITEMS +
   *+++++++*/

  final _isFetchingItemsStreamController = BehaviorSubject<bool>.seeded(false);
  final _itemsStreamController =
      BehaviorSubject<Map<int, Item>>.seeded(HashMap());
  StreamSubscription<bool>? _itemsUserSubscription;

  Stream<List<Item>> get items {
    return _itemsStreamController
        .asBroadcastStream()
        .map((event) => event.values.toList());
  }

  Stream<bool> get isFetchingItems {
    return _isFetchingItemsStreamController.asBroadcastStream();
  }

  void refreshItems() {
    unawaited(_fetchItems());
  }

  void _onItemsListen() {
    assert(_itemsUserSubscription == null, 'Already listening for items');

    if (_authenticationRepository.currentUser.isNotEmpty) {
      unawaited(_fetchItems());
    }
    _itemsUserSubscription = _authenticationRepository.user
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
    assert(_itemsUserSubscription != null, 'Not listening for items');
    _itemsUserSubscription!.cancel();
  }

  ResponseStream<api.GetTasksResponse>? _pendingItemsResponse;
  Future<void> _fetchItems() async {
    if (_pendingItemsResponse != null) {
      unawaited(_pendingItemsResponse!.cancel());
      _pendingItemsResponse = null;
    } else {
      _isFetchingItemsStreamController.add(true);
    }

    _pendingItemsResponse = _client.getTasks(api.GetTasksRequest());
    final result = HashMap<int, Item>();
    _pendingItemsResponse!
        .map(
      (response) => Item(
        id: response.id,
        title: response.title,
        isCompleted: response.isCompleted,
        startDate: _parseDate(response.startDate),
        endDate: _parseDate(response.endDate),
        estimate: _parseDuration(response.estimate),
        recurrence: switch (response.whichRecurring()) {
          api.GetTasksResponse_Recurring.notSet => const Recurrence(
              kind: RecurrenceKind.none,
              frequency: LongDuration(months: 0, days: 0),
            ),
          api.GetTasksResponse_Recurring.every => Recurrence(
              kind: RecurrenceKind.every,
              frequency: _parseRecurrenceEvery(response.every),
            ),
          api.GetTasksResponse_Recurring.checked => Recurrence(
              kind: RecurrenceKind.checked,
              frequency: _parseRecurrenceChecked(response.checked),
            )
        },
        responsible: _parseUser(response.responsible),
        group: _parseGroup(response.group),
      ),
    )
        .listen(
      (item) => result[item.id] = item,
      onDone: () {
        _pendingItemsResponse = null;
        _itemsStreamController.add(result);
        _isFetchingItemsStreamController.add(false);
      },
      cancelOnError: true,
    );
  }

  void _upsertItem(Item item) {
    final newValue = HashMap<int, Item>.from(_itemsStreamController.value);
    newValue[item.id] = item;
    _itemsStreamController.add(newValue);
  }

  Future<void> updateUserInfo({
    required String? name,
    required String? pictureUrl,
  }) async {
    final response = await _client
        .login(api.LoginRequest(name: name ?? '?', pictureUrl: pictureUrl));
    _viewerPersonStreamController.add(_parseUser(response.user));
  }

  Future<void> createItem({
    required String title,
    required DateTime? startDate,
    required DateTime? endDate,
    required Group? group,
    required Person? responsible,
    required ShortDuration estimate,
    required Recurrence recurrence,
  }) async {
    final response = await _client.createTask(
      api.CreateTaskRequest(
        title: title,
        startDate: _buildDate(startDate),
        endDate: _buildDate(endDate),
        estimate: _buildDuration(estimate),
        groupId: group?.id,
        responsibleId: responsible?.id,
        every: recurrence.kind == RecurrenceKind.every
            ? api.RecurringEveryRequest(
                months: recurrence.frequency.months,
                days: recurrence.frequency.days,
              )
            : null,
        checked: recurrence.kind == RecurrenceKind.checked
            ? api.RecurringChecked(
                months: recurrence.frequency.months,
                days: recurrence.frequency.days,
              )
            : null,
      ),
    );
    _upsertItem(_parseCreateTaskResponse(response));
  }

  Future<void> deleteItem(Item item) async {
    final newValue = HashMap<int, Item>.from(_itemsStreamController.value)
      ..remove(item.id);
    _itemsStreamController.add(newValue);

    try {
      await _client.deleteTask(api.DeleteTaskRequest(id: item.id));
    } catch (e) {
      _upsertItem(item);
      rethrow;
    }
  }

  Future<void> updateItem(Item newItem) async {
    final oldItem = _itemsStreamController.value[newItem.id];
    if (oldItem == null) {
      throw Exception('Existing item not found');
    }

    _upsertItem(newItem);

    try {
      await _client.updateTask(
        api.UpdateTaskRequest(
          id: newItem.id,
          title: newItem.title,
          startDate: _buildDate(newItem.startDate),
          endDate: _buildDate(newItem.endDate),
          estimate: _buildDuration(newItem.estimate),
          groupId: newItem.group?.id,
          responsibleId: newItem.responsible?.id,
          every: newItem.recurrence.kind == RecurrenceKind.every
              ? api.RecurringEveryRequest(
                  months: newItem.recurrence.frequency.months,
                  days: newItem.recurrence.frequency.days,
                )
              : null,
          checked: newItem.recurrence.kind == RecurrenceKind.checked
              ? api.RecurringChecked(
                  months: newItem.recurrence.frequency.months,
                  days: newItem.recurrence.frequency.days,
                )
              : null,
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
      final response = await _client.toggleTaskCompleted(
        api.ToggleTaskCompletedRequest(
          id: newItem.id,
          isCompleted: newItem.isCompleted,
        ),
      );
      if (response.hasTaskCreated()) {
        _upsertItem(_parseCreateTaskResponse(response.taskCreated));
      }
      if (response.hasTaskDeleted()) {
        final newValue = HashMap<int, Item>.from(_itemsStreamController.value)
          ..remove(response.taskDeleted.id);
        _itemsStreamController.add(newValue);
      }
    } catch (e) {
      _upsertItem(item);
      rethrow;
    }
  }

  /*++++++++*
   + GROUPS +
   *++++++++*/

  final _isFetchingGroupsStreamController = BehaviorSubject<bool>.seeded(false);
  final _groupsStreamController =
      BehaviorSubject<Map<int, Group>>.seeded(HashMap());
  StreamSubscription<bool>? _groupsUserSubscription;

  Stream<List<Group>> get groups {
    return _groupsStreamController
        .asBroadcastStream()
        .map((event) => event.values.toList());
  }

  Stream<Group?> getGroup(int id) {
    return _groupsStreamController
        .asBroadcastStream()
        .map((event) => event[id])
        .distinct();
  }

  Stream<bool> get isFetchingGroups {
    return _isFetchingGroupsStreamController.asBroadcastStream();
  }

  void _onGroupsListen() {
    assert(_groupsUserSubscription == null, 'Already listening for groups');

    if (_authenticationRepository.currentUser.isNotEmpty) {
      unawaited(_fetchGroups());
    }
    _groupsUserSubscription = _authenticationRepository.user
        .map((u) => u.isNotEmpty)
        .distinct()
        .listen((isNotEmpty) {
      if (isNotEmpty) {
        unawaited(_fetchGroups());
      } else {
        _groupsStreamController.add(HashMap());
      }
    });
  }

  void _onGroupsCancel() {
    assert(_groupsUserSubscription != null, 'Not listening for groups');
    _groupsUserSubscription!.cancel();
  }

  ResponseStream<api.GetGroupsResponse>? _pendingGroupsResponse;
  Future<void> _fetchGroups() async {
    if (_pendingGroupsResponse != null) {
      unawaited(_pendingGroupsResponse!.cancel());
      _pendingGroupsResponse = null;
    } else {
      _isFetchingGroupsStreamController.add(true);
    }

    _pendingGroupsResponse = _client.getGroups(api.GetGroupsRequest());
    final result = HashMap<int, Group>();
    _pendingGroupsResponse!
        .map(
      (response) => Group(
        id: response.id,
        uid: response.uid,
        title: response.title,
      ),
    )
        .listen(
      (group) => result[group.id] = group,
      onDone: () {
        _pendingGroupsResponse = null;
        _groupsStreamController.add(result);
        _isFetchingGroupsStreamController.add(false);
      },
      cancelOnError: true,
    );
  }

  void _upsertGroup(Group group) {
    final newValue = HashMap<int, Group>.from(_groupsStreamController.value);
    newValue[group.id] = group;
    _groupsStreamController.add(newValue);
  }

  Future<void> createGroup({
    required String title,
  }) async {
    final response = await _client.createGroup(
      api.CreateGroupRequest(
        title: title,
      ),
    );
    _upsertGroup(
      Group(
        id: response.id,
        uid: response.uid,
        title: response.title,
      ),
    );
  }

  Future<void> joinGroup({
    required String uid,
  }) async {
    final response = await _client.joinGroup(api.JoinGroupRequest(uid: uid));
    _upsertGroup(
      Group(
        id: response.id,
        uid: response.uid,
        title: response.title,
      ),
    );
  }

  Future<void> updateGroup(Group newGroup) async {
    final oldGroup = _groupsStreamController.value[newGroup.id];
    if (oldGroup == null) {
      throw Exception('Existing group not found');
    }

    _upsertGroup(newGroup);

    try {
      await _client.updateGroup(
        api.UpdateGroupRequest(
          id: newGroup.id,
          title: newGroup.title,
        ),
      );
    } catch (e) {
      _upsertGroup(oldGroup);
      rethrow;
    }
  }

  Future<void> leaveGroup(Group group) async {
    final newValue = HashMap<int, Group>.from(_groupsStreamController.value)
      ..remove(group.id);
    _groupsStreamController.add(newValue);

    try {
      await _client.leaveGroup(api.LeaveGroupRequest(id: group.id));
    } catch (e) {
      _upsertGroup(group);
      rethrow;
    }
  }

  /*++++++++++++++++++++*
   + GROUP PARTICIPANTS +
   *++++++++++++++++++++*/

  final _isFetchingGroupParticipantsStreamController =
      BehaviorSubject<bool>.seeded(false);
  final _groupParticipantsStreamController =
      BehaviorSubject<Map<int, List<Person>>>.seeded(HashMap());
  // StreamSubscription<bool>? _groupParticipantsUserSubscription;

  Stream<List<Person>> groupParticipants(Group group) {
    if (_groupParticipantsStreamController.value[group.id] == null) {
      _fetchGroupParticipants(group);
    }

    return _groupParticipantsStreamController
        .asBroadcastStream()
        .map((event) => event[group.id]?.toList() ?? []);
  }

  Stream<bool> get isFetchingGroupParticipants {
    return _isFetchingGroupParticipantsStreamController.asBroadcastStream();
  }

  ResponseStream<api.GetGroupParticipantsResponse>?
      _pendingGroupParticipantsResponse;
  Future<void> _fetchGroupParticipants(Group group) async {
    if (_pendingGroupParticipantsResponse != null) {
      unawaited(_pendingGroupParticipantsResponse!.cancel());
      _pendingGroupParticipantsResponse = null;
    } else {
      _isFetchingGroupParticipantsStreamController.add(true);
    }

    _pendingGroupParticipantsResponse = _client.getGroupParticipants(
      api.GetGroupParticipantsRequest(groupId: group.id),
    );
    final result = HashMap<int, List<Person>>();
    _pendingGroupParticipantsResponse!
        .map(
      (response) => _parseUser(response.user),
    )
        .listen(
      (groupParticipant) {
        if (result[group.id] == null) {
          result[group.id] = [];
        }
        result[group.id]!.add(groupParticipant);
      },
      onDone: () {
        _pendingGroupParticipantsResponse = null;
        _groupParticipantsStreamController.add(result);
        _isFetchingGroupParticipantsStreamController.add(false);
      },
      cancelOnError: true,
    );
  }

  /*+++++++*
   + UTILS +
   *+++++++*/

  google.Date? _buildDate(DateTime? date) {
    return date == null
        ? null
        : google.Date(year: date.year, month: date.month, day: date.day);
  }

  api.Duration? _buildDuration(ShortDuration duration) {
    return duration.isEmpty
        ? null
        : api.Duration(
            days: duration.days,
            hours: duration.hours,
            minutes: duration.minutes,
          );
  }

  DateTime? _parseDate(google.Date date) {
    if (date.hasYear() && date.hasMonth() && date.hasDay()) {
      return DateTime(date.year, date.month, date.day);
    }
    return null;
  }

  ShortDuration _parseDuration(api.Duration duration) {
    return ShortDuration(
      days: duration.days,
      hours: duration.hours,
      minutes: duration.minutes,
    );
  }

  Person _parseUser(api.User user) {
    return Person(
      id: user.id,
      name: user.name,
      pictureUrl: user.hasPictureUrl() ? user.pictureUrl : null,
    );
  }

  Group? _parseGroup(api.Group group) {
    if (group.hasId()) {
      return Group(
        id: group.id,
        title: group.title,
        uid: group.uid,
      );
    } else {
      return null;
    }
  }

  LongDuration _parseRecurrenceChecked(api.RecurringChecked checked) {
    return LongDuration(months: checked.months, days: checked.days);
  }

  LongDuration _parseRecurrenceEvery(api.RecurringEveryResponse every) {
    return LongDuration(months: every.months, days: every.days);
  }

  Item _parseCreateTaskResponse(api.CreateTaskResponse task) {
    return Item(
      id: task.id,
      title: task.title,
      isCompleted: false,
      startDate: _parseDate(task.startDate),
      endDate: _parseDate(task.endDate),
      estimate: _parseDuration(task.estimate),
      responsible: _parseUser(task.responsible),
      recurrence: switch (task.whichRecurring()) {
        api.CreateTaskResponse_Recurring.notSet => const Recurrence(
            kind: RecurrenceKind.none,
            frequency: LongDuration(months: 0, days: 0),
          ),
        api.CreateTaskResponse_Recurring.every => Recurrence(
            kind: RecurrenceKind.every,
            frequency: _parseRecurrenceEvery(task.every),
          ),
        api.CreateTaskResponse_Recurring.checked => Recurrence(
            kind: RecurrenceKind.checked,
            frequency: _parseRecurrenceChecked(task.checked),
          )
      },
      group: _parseGroup(task.group),
    );
  }
}
