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

  $async.Stream<$0.GetTasksResponse> getTasks_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetTasksRequest> request) async* {
    yield* getTasks(call, await request);
  }

  $async.Future<$0.CreateTaskResponse> createTask(
      $grpc.ServiceCall call, $0.CreateTaskRequest request);
  $async.Stream<$0.GetTasksResponse> getTasks(
      $grpc.ServiceCall call, $0.GetTasksRequest request);
}
