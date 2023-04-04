///
//  Generated code. Do not modify.
//  source: api/v1/api.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = const {
  '1': 'LoginRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'picture_url', '3': 2, '4': 1, '5': 9, '10': 'pictureUrl'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode('CgxMb2dpblJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIfCgtwaWN0dXJlX3VybBgCIAEoCVIKcGljdHVyZVVybA==');
@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = const {
  '1': 'LoginResponse',
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode('Cg1Mb2dpblJlc3BvbnNl');
@$core.Deprecated('Use createTaskRequestDescriptor instead')
const CreateTaskRequest$json = const {
  '1': 'CreateTaskRequest',
  '2': const [
    const {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'start_date', '3': 2, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
  ],
};

/// Descriptor for `CreateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVUYXNrUmVxdWVzdBIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSMAoKc3RhcnRfZGF0ZRgCIAEoCzIRLmdvb2dsZS50eXBlLkRhdGVSCXN0YXJ0RGF0ZRIsCghlbmRfZGF0ZRgDIAEoCzIRLmdvb2dsZS50eXBlLkRhdGVSB2VuZERhdGU=');
@$core.Deprecated('Use createTaskResponseDescriptor instead')
const CreateTaskResponse$json = const {
  '1': 'CreateTaskResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'start_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
  ],
};

/// Descriptor for `CreateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskResponseDescriptor = $convert.base64Decode('ChJDcmVhdGVUYXNrUmVzcG9uc2USDgoCaWQYASABKAVSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIwCgpzdGFydF9kYXRlGAMgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIJc3RhcnREYXRlEiwKCGVuZF9kYXRlGAQgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIHZW5kRGF0ZQ==');
@$core.Deprecated('Use updateTaskRequestDescriptor instead')
const UpdateTaskRequest$json = const {
  '1': 'UpdateTaskRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'start_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
  ],
};

/// Descriptor for `UpdateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVUYXNrUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEjAKCnN0YXJ0X2RhdGUYAyABKAsyES5nb29nbGUudHlwZS5EYXRlUglzdGFydERhdGUSLAoIZW5kX2RhdGUYBCABKAsyES5nb29nbGUudHlwZS5EYXRlUgdlbmREYXRl');
@$core.Deprecated('Use updateTaskResponseDescriptor instead')
const UpdateTaskResponse$json = const {
  '1': 'UpdateTaskResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'is_completed', '3': 3, '4': 1, '5': 8, '10': 'isCompleted'},
    const {'1': 'start_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 5, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
  ],
};

/// Descriptor for `UpdateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskResponseDescriptor = $convert.base64Decode('ChJVcGRhdGVUYXNrUmVzcG9uc2USDgoCaWQYASABKAVSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIhCgxpc19jb21wbGV0ZWQYAyABKAhSC2lzQ29tcGxldGVkEjAKCnN0YXJ0X2RhdGUYBCABKAsyES5nb29nbGUudHlwZS5EYXRlUglzdGFydERhdGUSLAoIZW5kX2RhdGUYBSABKAsyES5nb29nbGUudHlwZS5EYXRlUgdlbmREYXRl');
@$core.Deprecated('Use toggleTaskCompletedRequestDescriptor instead')
const ToggleTaskCompletedRequest$json = const {
  '1': 'ToggleTaskCompletedRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'is_completed', '3': 2, '4': 1, '5': 8, '10': 'isCompleted'},
  ],
};

/// Descriptor for `ToggleTaskCompletedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleTaskCompletedRequestDescriptor = $convert.base64Decode('ChpUb2dnbGVUYXNrQ29tcGxldGVkUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQSIQoMaXNfY29tcGxldGVkGAIgASgIUgtpc0NvbXBsZXRlZA==');
@$core.Deprecated('Use toggleTaskCompletedResponseDescriptor instead')
const ToggleTaskCompletedResponse$json = const {
  '1': 'ToggleTaskCompletedResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'is_completed', '3': 2, '4': 1, '5': 8, '10': 'isCompleted'},
  ],
};

/// Descriptor for `ToggleTaskCompletedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleTaskCompletedResponseDescriptor = $convert.base64Decode('ChtUb2dnbGVUYXNrQ29tcGxldGVkUmVzcG9uc2USDgoCaWQYASABKAVSAmlkEiEKDGlzX2NvbXBsZXRlZBgCIAEoCFILaXNDb21wbGV0ZWQ=');
@$core.Deprecated('Use deleteTaskRequestDescriptor instead')
const DeleteTaskRequest$json = const {
  '1': 'DeleteTaskRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `DeleteTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTaskRequestDescriptor = $convert.base64Decode('ChFEZWxldGVUYXNrUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQ=');
@$core.Deprecated('Use deleteTaskResponseDescriptor instead')
const DeleteTaskResponse$json = const {
  '1': 'DeleteTaskResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `DeleteTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTaskResponseDescriptor = $convert.base64Decode('ChJEZWxldGVUYXNrUmVzcG9uc2USDgoCaWQYASABKAVSAmlk');
@$core.Deprecated('Use getTasksRequestDescriptor instead')
const GetTasksRequest$json = const {
  '1': 'GetTasksRequest',
};

/// Descriptor for `GetTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTasksRequestDescriptor = $convert.base64Decode('Cg9HZXRUYXNrc1JlcXVlc3Q=');
@$core.Deprecated('Use getTasksResponseDescriptor instead')
const GetTasksResponse$json = const {
  '1': 'GetTasksResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'is_completed', '3': 3, '4': 1, '5': 8, '10': 'isCompleted'},
    const {'1': 'start_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 5, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
  ],
};

/// Descriptor for `GetTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTasksResponseDescriptor = $convert.base64Decode('ChBHZXRUYXNrc1Jlc3BvbnNlEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSIQoMaXNfY29tcGxldGVkGAMgASgIUgtpc0NvbXBsZXRlZBIwCgpzdGFydF9kYXRlGAQgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIJc3RhcnREYXRlEiwKCGVuZF9kYXRlGAUgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIHZW5kRGF0ZQ==');
@$core.Deprecated('Use createGroupRequestDescriptor instead')
const CreateGroupRequest$json = const {
  '1': 'CreateGroupRequest',
  '2': const [
    const {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `CreateGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGroupRequestDescriptor = $convert.base64Decode('ChJDcmVhdGVHcm91cFJlcXVlc3QSFAoFdGl0bGUYASABKAlSBXRpdGxl');
@$core.Deprecated('Use createGroupResponseDescriptor instead')
const CreateGroupResponse$json = const {
  '1': 'CreateGroupResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `CreateGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGroupResponseDescriptor = $convert.base64Decode('ChNDcmVhdGVHcm91cFJlc3BvbnNlEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGU=');
@$core.Deprecated('Use updateGroupRequestDescriptor instead')
const UpdateGroupRequest$json = const {
  '1': 'UpdateGroupRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `UpdateGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGroupRequestDescriptor = $convert.base64Decode('ChJVcGRhdGVHcm91cFJlcXVlc3QSDgoCaWQYASABKAVSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZQ==');
@$core.Deprecated('Use updateGroupResponseDescriptor instead')
const UpdateGroupResponse$json = const {
  '1': 'UpdateGroupResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `UpdateGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGroupResponseDescriptor = $convert.base64Decode('ChNVcGRhdGVHcm91cFJlc3BvbnNlEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGU=');
@$core.Deprecated('Use leaveGroupRequestDescriptor instead')
const LeaveGroupRequest$json = const {
  '1': 'LeaveGroupRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `LeaveGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveGroupRequestDescriptor = $convert.base64Decode('ChFMZWF2ZUdyb3VwUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQ=');
@$core.Deprecated('Use leaveGroupResponseDescriptor instead')
const LeaveGroupResponse$json = const {
  '1': 'LeaveGroupResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `LeaveGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveGroupResponseDescriptor = $convert.base64Decode('ChJMZWF2ZUdyb3VwUmVzcG9uc2USDgoCaWQYASABKAVSAmlk');
@$core.Deprecated('Use getGroupsRequestDescriptor instead')
const GetGroupsRequest$json = const {
  '1': 'GetGroupsRequest',
};

/// Descriptor for `GetGroupsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupsRequestDescriptor = $convert.base64Decode('ChBHZXRHcm91cHNSZXF1ZXN0');
@$core.Deprecated('Use getGroupsResponseDescriptor instead')
const GetGroupsResponse$json = const {
  '1': 'GetGroupsResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `GetGroupsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupsResponseDescriptor = $convert.base64Decode('ChFHZXRHcm91cHNSZXNwb25zZRIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxl');
