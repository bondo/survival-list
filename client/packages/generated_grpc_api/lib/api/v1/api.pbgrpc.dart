///
//  Generated code. Do not modify.
//  source: api/v1/api.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'api.pb.dart' as $0;
export 'api.pb.dart';

class APIClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/api.v1.API/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LoginResponse.fromBuffer(value));
  static final _$createTask =
      $grpc.ClientMethod<$0.CreateTaskRequest, $0.CreateTaskResponse>(
          '/api.v1.API/CreateTask',
          ($0.CreateTaskRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.CreateTaskResponse.fromBuffer(value));
  static final _$updateTask =
      $grpc.ClientMethod<$0.UpdateTaskRequest, $0.UpdateTaskResponse>(
          '/api.v1.API/UpdateTask',
          ($0.UpdateTaskRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.UpdateTaskResponse.fromBuffer(value));
  static final _$toggleTaskCompleted = $grpc.ClientMethod<
          $0.ToggleTaskCompletedRequest, $0.ToggleTaskCompletedResponse>(
      '/api.v1.API/ToggleTaskCompleted',
      ($0.ToggleTaskCompletedRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.ToggleTaskCompletedResponse.fromBuffer(value));
  static final _$deleteTask =
      $grpc.ClientMethod<$0.DeleteTaskRequest, $0.DeleteTaskResponse>(
          '/api.v1.API/DeleteTask',
          ($0.DeleteTaskRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.DeleteTaskResponse.fromBuffer(value));
  static final _$getTasks =
      $grpc.ClientMethod<$0.GetTasksRequest, $0.GetTasksResponse>(
          '/api.v1.API/GetTasks',
          ($0.GetTasksRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetTasksResponse.fromBuffer(value));
  static final _$createGroup =
      $grpc.ClientMethod<$0.CreateGroupRequest, $0.CreateGroupResponse>(
          '/api.v1.API/CreateGroup',
          ($0.CreateGroupRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.CreateGroupResponse.fromBuffer(value));
  static final _$joinGroup =
      $grpc.ClientMethod<$0.JoinGroupRequest, $0.JoinGroupResponse>(
          '/api.v1.API/JoinGroup',
          ($0.JoinGroupRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.JoinGroupResponse.fromBuffer(value));
  static final _$updateGroup =
      $grpc.ClientMethod<$0.UpdateGroupRequest, $0.UpdateGroupResponse>(
          '/api.v1.API/UpdateGroup',
          ($0.UpdateGroupRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.UpdateGroupResponse.fromBuffer(value));
  static final _$leaveGroup =
      $grpc.ClientMethod<$0.LeaveGroupRequest, $0.LeaveGroupResponse>(
          '/api.v1.API/LeaveGroup',
          ($0.LeaveGroupRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.LeaveGroupResponse.fromBuffer(value));
  static final _$getGroups =
      $grpc.ClientMethod<$0.GetGroupsRequest, $0.GetGroupsResponse>(
          '/api.v1.API/GetGroups',
          ($0.GetGroupsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetGroupsResponse.fromBuffer(value));
  static final _$getGroupParticipants = $grpc.ClientMethod<
          $0.GetGroupParticipantsRequest, $0.GetGroupParticipantsResponse>(
      '/api.v1.API/GetGroupParticipants',
      ($0.GetGroupParticipantsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.GetGroupParticipantsResponse.fromBuffer(value));
  static final _$getCategories =
      $grpc.ClientMethod<$0.GetCategoriesRequest, $0.GetCategoriesResponse>(
          '/api.v1.API/GetCategories',
          ($0.GetCategoriesRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetCategoriesResponse.fromBuffer(value));
  static final _$updateCategory =
      $grpc.ClientMethod<$0.UpdateCategoryRequest, $0.UpdateCategoryResponse>(
          '/api.v1.API/UpdateCategory',
          ($0.UpdateCategoryRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.UpdateCategoryResponse.fromBuffer(value));
  static final _$createSubcategory = $grpc.ClientMethod<
          $0.CreateSubcategoryRequest, $0.CreateSubcategoryResponse>(
      '/api.v1.API/CreateSubcategory',
      ($0.CreateSubcategoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.CreateSubcategoryResponse.fromBuffer(value));
  static final _$updateSubcategory = $grpc.ClientMethod<
          $0.UpdateSubcategoryRequest, $0.UpdateSubcategoryResponse>(
      '/api.v1.API/UpdateSubcategory',
      ($0.UpdateSubcategoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.UpdateSubcategoryResponse.fromBuffer(value));
  static final _$deleteSubcategory = $grpc.ClientMethod<
          $0.DeleteSubcategoryRequest, $0.DeleteSubcategoryResponse>(
      '/api.v1.API/DeleteSubcategory',
      ($0.DeleteSubcategoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.DeleteSubcategoryResponse.fromBuffer(value));

  APIClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.LoginResponse> login($0.LoginRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateTaskResponse> createTask(
      $0.CreateTaskRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateTaskResponse> updateTask(
      $0.UpdateTaskRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.ToggleTaskCompletedResponse> toggleTaskCompleted(
      $0.ToggleTaskCompletedRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$toggleTaskCompleted, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteTaskResponse> deleteTask(
      $0.DeleteTaskRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteTask, request, options: options);
  }

  $grpc.ResponseStream<$0.GetTasksResponse> getTasks($0.GetTasksRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getTasks, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.CreateGroupResponse> createGroup(
      $0.CreateGroupRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.JoinGroupResponse> joinGroup(
      $0.JoinGroupRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$joinGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateGroupResponse> updateGroup(
      $0.UpdateGroupRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.LeaveGroupResponse> leaveGroup(
      $0.LeaveGroupRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$leaveGroup, request, options: options);
  }

  $grpc.ResponseStream<$0.GetGroupsResponse> getGroups(
      $0.GetGroupsRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getGroups, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.GetGroupParticipantsResponse> getGroupParticipants(
      $0.GetGroupParticipantsRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getGroupParticipants, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.GetCategoriesResponse> getCategories(
      $0.GetCategoriesRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getCategories, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.UpdateCategoryResponse> updateCategory(
      $0.UpdateCategoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateCategory, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateSubcategoryResponse> createSubcategory(
      $0.CreateSubcategoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSubcategory, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateSubcategoryResponse> updateSubcategory(
      $0.UpdateSubcategoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateSubcategory, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteSubcategoryResponse> deleteSubcategory(
      $0.DeleteSubcategoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteSubcategory, request, options: options);
  }
}

abstract class APIServiceBase extends $grpc.Service {
  $core.String get $name => 'api.v1.API';

  APIServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateTaskRequest, $0.CreateTaskResponse>(
        'CreateTask',
        createTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateTaskRequest.fromBuffer(value),
        ($0.CreateTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateTaskRequest, $0.UpdateTaskResponse>(
        'UpdateTask',
        updateTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateTaskRequest.fromBuffer(value),
        ($0.UpdateTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ToggleTaskCompletedRequest,
            $0.ToggleTaskCompletedResponse>(
        'ToggleTaskCompleted',
        toggleTaskCompleted_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ToggleTaskCompletedRequest.fromBuffer(value),
        ($0.ToggleTaskCompletedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteTaskRequest, $0.DeleteTaskResponse>(
        'DeleteTask',
        deleteTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteTaskRequest.fromBuffer(value),
        ($0.DeleteTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTasksRequest, $0.GetTasksResponse>(
        'GetTasks',
        getTasks_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.GetTasksRequest.fromBuffer(value),
        ($0.GetTasksResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateGroupRequest, $0.CreateGroupResponse>(
            'CreateGroup',
            createGroup_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateGroupRequest.fromBuffer(value),
            ($0.CreateGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinGroupRequest, $0.JoinGroupResponse>(
        'JoinGroup',
        joinGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinGroupRequest.fromBuffer(value),
        ($0.JoinGroupResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateGroupRequest, $0.UpdateGroupResponse>(
            'UpdateGroup',
            updateGroup_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateGroupRequest.fromBuffer(value),
            ($0.UpdateGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaveGroupRequest, $0.LeaveGroupResponse>(
        'LeaveGroup',
        leaveGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LeaveGroupRequest.fromBuffer(value),
        ($0.LeaveGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetGroupsRequest, $0.GetGroupsResponse>(
        'GetGroups',
        getGroups_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.GetGroupsRequest.fromBuffer(value),
        ($0.GetGroupsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetGroupParticipantsRequest,
            $0.GetGroupParticipantsResponse>(
        'GetGroupParticipants',
        getGroupParticipants_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.GetGroupParticipantsRequest.fromBuffer(value),
        ($0.GetGroupParticipantsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCategoriesRequest, $0.GetCategoriesResponse>(
            'GetCategories',
            getCategories_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.GetCategoriesRequest.fromBuffer(value),
            ($0.GetCategoriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateCategoryRequest,
            $0.UpdateCategoryResponse>(
        'UpdateCategory',
        updateCategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateCategoryRequest.fromBuffer(value),
        ($0.UpdateCategoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateSubcategoryRequest,
            $0.CreateSubcategoryResponse>(
        'CreateSubcategory',
        createSubcategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateSubcategoryRequest.fromBuffer(value),
        ($0.CreateSubcategoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateSubcategoryRequest,
            $0.UpdateSubcategoryResponse>(
        'UpdateSubcategory',
        updateSubcategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateSubcategoryRequest.fromBuffer(value),
        ($0.UpdateSubcategoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteSubcategoryRequest,
            $0.DeleteSubcategoryResponse>(
        'DeleteSubcategory',
        deleteSubcategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteSubcategoryRequest.fromBuffer(value),
        ($0.DeleteSubcategoryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> login_Pre(
      $grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$0.CreateTaskResponse> createTask_Pre($grpc.ServiceCall call,
      $async.Future<$0.CreateTaskRequest> request) async {
    return createTask(call, await request);
  }

  $async.Future<$0.UpdateTaskResponse> updateTask_Pre($grpc.ServiceCall call,
      $async.Future<$0.UpdateTaskRequest> request) async {
    return updateTask(call, await request);
  }

  $async.Future<$0.ToggleTaskCompletedResponse> toggleTaskCompleted_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ToggleTaskCompletedRequest> request) async {
    return toggleTaskCompleted(call, await request);
  }

  $async.Future<$0.DeleteTaskResponse> deleteTask_Pre($grpc.ServiceCall call,
      $async.Future<$0.DeleteTaskRequest> request) async {
    return deleteTask(call, await request);
  }

  $async.Stream<$0.GetTasksResponse> getTasks_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetTasksRequest> request) async* {
    yield* getTasks(call, await request);
  }

  $async.Future<$0.CreateGroupResponse> createGroup_Pre($grpc.ServiceCall call,
      $async.Future<$0.CreateGroupRequest> request) async {
    return createGroup(call, await request);
  }

  $async.Future<$0.JoinGroupResponse> joinGroup_Pre($grpc.ServiceCall call,
      $async.Future<$0.JoinGroupRequest> request) async {
    return joinGroup(call, await request);
  }

  $async.Future<$0.UpdateGroupResponse> updateGroup_Pre($grpc.ServiceCall call,
      $async.Future<$0.UpdateGroupRequest> request) async {
    return updateGroup(call, await request);
  }

  $async.Future<$0.LeaveGroupResponse> leaveGroup_Pre($grpc.ServiceCall call,
      $async.Future<$0.LeaveGroupRequest> request) async {
    return leaveGroup(call, await request);
  }

  $async.Stream<$0.GetGroupsResponse> getGroups_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetGroupsRequest> request) async* {
    yield* getGroups(call, await request);
  }

  $async.Stream<$0.GetGroupParticipantsResponse> getGroupParticipants_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetGroupParticipantsRequest> request) async* {
    yield* getGroupParticipants(call, await request);
  }

  $async.Stream<$0.GetCategoriesResponse> getCategories_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetCategoriesRequest> request) async* {
    yield* getCategories(call, await request);
  }

  $async.Future<$0.UpdateCategoryResponse> updateCategory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.UpdateCategoryRequest> request) async {
    return updateCategory(call, await request);
  }

  $async.Future<$0.CreateSubcategoryResponse> createSubcategory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.CreateSubcategoryRequest> request) async {
    return createSubcategory(call, await request);
  }

  $async.Future<$0.UpdateSubcategoryResponse> updateSubcategory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.UpdateSubcategoryRequest> request) async {
    return updateSubcategory(call, await request);
  }

  $async.Future<$0.DeleteSubcategoryResponse> deleteSubcategory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.DeleteSubcategoryRequest> request) async {
    return deleteSubcategory(call, await request);
  }

  $async.Future<$0.LoginResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$0.CreateTaskResponse> createTask(
      $grpc.ServiceCall call, $0.CreateTaskRequest request);
  $async.Future<$0.UpdateTaskResponse> updateTask(
      $grpc.ServiceCall call, $0.UpdateTaskRequest request);
  $async.Future<$0.ToggleTaskCompletedResponse> toggleTaskCompleted(
      $grpc.ServiceCall call, $0.ToggleTaskCompletedRequest request);
  $async.Future<$0.DeleteTaskResponse> deleteTask(
      $grpc.ServiceCall call, $0.DeleteTaskRequest request);
  $async.Stream<$0.GetTasksResponse> getTasks(
      $grpc.ServiceCall call, $0.GetTasksRequest request);
  $async.Future<$0.CreateGroupResponse> createGroup(
      $grpc.ServiceCall call, $0.CreateGroupRequest request);
  $async.Future<$0.JoinGroupResponse> joinGroup(
      $grpc.ServiceCall call, $0.JoinGroupRequest request);
  $async.Future<$0.UpdateGroupResponse> updateGroup(
      $grpc.ServiceCall call, $0.UpdateGroupRequest request);
  $async.Future<$0.LeaveGroupResponse> leaveGroup(
      $grpc.ServiceCall call, $0.LeaveGroupRequest request);
  $async.Stream<$0.GetGroupsResponse> getGroups(
      $grpc.ServiceCall call, $0.GetGroupsRequest request);
  $async.Stream<$0.GetGroupParticipantsResponse> getGroupParticipants(
      $grpc.ServiceCall call, $0.GetGroupParticipantsRequest request);
  $async.Stream<$0.GetCategoriesResponse> getCategories(
      $grpc.ServiceCall call, $0.GetCategoriesRequest request);
  $async.Future<$0.UpdateCategoryResponse> updateCategory(
      $grpc.ServiceCall call, $0.UpdateCategoryRequest request);
  $async.Future<$0.CreateSubcategoryResponse> createSubcategory(
      $grpc.ServiceCall call, $0.CreateSubcategoryRequest request);
  $async.Future<$0.UpdateSubcategoryResponse> updateSubcategory(
      $grpc.ServiceCall call, $0.UpdateSubcategoryRequest request);
  $async.Future<$0.DeleteSubcategoryResponse> deleteSubcategory(
      $grpc.ServiceCall call, $0.DeleteSubcategoryRequest request);
}
