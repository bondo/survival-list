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

  APIClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

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
}

abstract class APIServiceBase extends $grpc.Service {
  $core.String get $name => 'api.v1.API';

  APIServiceBase() {
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
}
