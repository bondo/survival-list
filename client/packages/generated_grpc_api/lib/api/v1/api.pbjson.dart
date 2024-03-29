///
//  Generated code. Do not modify.
//  source: api/v1/api.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../../google/type/date.pbjson.dart' as $0;

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
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.api.v1.User', '10': 'user'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode('Cg1Mb2dpblJlc3BvbnNlEiAKBHVzZXIYASABKAsyDC5hcGkudjEuVXNlclIEdXNlcg==');
@$core.Deprecated('Use createTaskRequestDescriptor instead')
const CreateTaskRequest$json = const {
  '1': 'CreateTaskRequest',
  '2': const [
    const {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'start_date', '3': 2, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
    const {'1': 'responsible_id', '3': 4, '4': 1, '5': 5, '10': 'responsibleId'},
    const {'1': 'group_id', '3': 5, '4': 1, '5': 5, '10': 'groupId'},
    const {'1': 'estimate', '3': 6, '4': 1, '5': 11, '6': '.api.v1.Duration', '10': 'estimate'},
    const {'1': 'checked', '3': 7, '4': 1, '5': 11, '6': '.api.v1.RecurringChecked', '9': 0, '10': 'checked'},
    const {'1': 'every', '3': 8, '4': 1, '5': 11, '6': '.api.v1.RecurringEveryRequest', '9': 0, '10': 'every'},
  ],
  '8': const [
    const {'1': 'recurring'},
  ],
};

/// Descriptor for `CreateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVUYXNrUmVxdWVzdBIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSMAoKc3RhcnRfZGF0ZRgCIAEoCzIRLmdvb2dsZS50eXBlLkRhdGVSCXN0YXJ0RGF0ZRIsCghlbmRfZGF0ZRgDIAEoCzIRLmdvb2dsZS50eXBlLkRhdGVSB2VuZERhdGUSJQoOcmVzcG9uc2libGVfaWQYBCABKAVSDXJlc3BvbnNpYmxlSWQSGQoIZ3JvdXBfaWQYBSABKAVSB2dyb3VwSWQSLAoIZXN0aW1hdGUYBiABKAsyEC5hcGkudjEuRHVyYXRpb25SCGVzdGltYXRlEjQKB2NoZWNrZWQYByABKAsyGC5hcGkudjEuUmVjdXJyaW5nQ2hlY2tlZEgAUgdjaGVja2VkEjUKBWV2ZXJ5GAggASgLMh0uYXBpLnYxLlJlY3VycmluZ0V2ZXJ5UmVxdWVzdEgAUgVldmVyeUILCglyZWN1cnJpbmc=');
@$core.Deprecated('Use createTaskResponseDescriptor instead')
const CreateTaskResponse$json = const {
  '1': 'CreateTaskResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'start_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
    const {'1': 'responsible', '3': 5, '4': 1, '5': 11, '6': '.api.v1.User', '10': 'responsible'},
    const {'1': 'group', '3': 6, '4': 1, '5': 11, '6': '.api.v1.Group', '10': 'group'},
    const {'1': 'estimate', '3': 7, '4': 1, '5': 11, '6': '.api.v1.Duration', '10': 'estimate'},
    const {'1': 'checked', '3': 8, '4': 1, '5': 11, '6': '.api.v1.RecurringChecked', '9': 0, '10': 'checked'},
    const {'1': 'every', '3': 9, '4': 1, '5': 11, '6': '.api.v1.RecurringEveryResponse', '9': 0, '10': 'every'},
    const {'1': 'can_update', '3': 10, '4': 1, '5': 8, '10': 'canUpdate'},
    const {'1': 'can_toggle', '3': 11, '4': 1, '5': 8, '10': 'canToggle'},
    const {'1': 'can_delete', '3': 12, '4': 1, '5': 8, '10': 'canDelete'},
  ],
  '8': const [
    const {'1': 'recurring'},
  ],
};

/// Descriptor for `CreateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskResponseDescriptor = $convert.base64Decode('ChJDcmVhdGVUYXNrUmVzcG9uc2USDgoCaWQYASABKAVSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIwCgpzdGFydF9kYXRlGAMgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIJc3RhcnREYXRlEiwKCGVuZF9kYXRlGAQgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIHZW5kRGF0ZRIuCgtyZXNwb25zaWJsZRgFIAEoCzIMLmFwaS52MS5Vc2VyUgtyZXNwb25zaWJsZRIjCgVncm91cBgGIAEoCzINLmFwaS52MS5Hcm91cFIFZ3JvdXASLAoIZXN0aW1hdGUYByABKAsyEC5hcGkudjEuRHVyYXRpb25SCGVzdGltYXRlEjQKB2NoZWNrZWQYCCABKAsyGC5hcGkudjEuUmVjdXJyaW5nQ2hlY2tlZEgAUgdjaGVja2VkEjYKBWV2ZXJ5GAkgASgLMh4uYXBpLnYxLlJlY3VycmluZ0V2ZXJ5UmVzcG9uc2VIAFIFZXZlcnkSHQoKY2FuX3VwZGF0ZRgKIAEoCFIJY2FuVXBkYXRlEh0KCmNhbl90b2dnbGUYCyABKAhSCWNhblRvZ2dsZRIdCgpjYW5fZGVsZXRlGAwgASgIUgljYW5EZWxldGVCCwoJcmVjdXJyaW5n');
@$core.Deprecated('Use updateTaskRequestDescriptor instead')
const UpdateTaskRequest$json = const {
  '1': 'UpdateTaskRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'start_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
    const {'1': 'responsible_id', '3': 5, '4': 1, '5': 5, '10': 'responsibleId'},
    const {'1': 'group_id', '3': 6, '4': 1, '5': 5, '10': 'groupId'},
    const {'1': 'estimate', '3': 7, '4': 1, '5': 11, '6': '.api.v1.Duration', '10': 'estimate'},
    const {'1': 'checked', '3': 8, '4': 1, '5': 11, '6': '.api.v1.RecurringChecked', '9': 0, '10': 'checked'},
    const {'1': 'every', '3': 9, '4': 1, '5': 11, '6': '.api.v1.RecurringEveryRequest', '9': 0, '10': 'every'},
  ],
  '8': const [
    const {'1': 'recurring'},
  ],
};

/// Descriptor for `UpdateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVUYXNrUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEjAKCnN0YXJ0X2RhdGUYAyABKAsyES5nb29nbGUudHlwZS5EYXRlUglzdGFydERhdGUSLAoIZW5kX2RhdGUYBCABKAsyES5nb29nbGUudHlwZS5EYXRlUgdlbmREYXRlEiUKDnJlc3BvbnNpYmxlX2lkGAUgASgFUg1yZXNwb25zaWJsZUlkEhkKCGdyb3VwX2lkGAYgASgFUgdncm91cElkEiwKCGVzdGltYXRlGAcgASgLMhAuYXBpLnYxLkR1cmF0aW9uUghlc3RpbWF0ZRI0CgdjaGVja2VkGAggASgLMhguYXBpLnYxLlJlY3VycmluZ0NoZWNrZWRIAFIHY2hlY2tlZBI1CgVldmVyeRgJIAEoCzIdLmFwaS52MS5SZWN1cnJpbmdFdmVyeVJlcXVlc3RIAFIFZXZlcnlCCwoJcmVjdXJyaW5n');
@$core.Deprecated('Use updateTaskResponseDescriptor instead')
const UpdateTaskResponse$json = const {
  '1': 'UpdateTaskResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'is_completed', '3': 3, '4': 1, '5': 8, '10': 'isCompleted'},
    const {'1': 'start_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    const {'1': 'end_date', '3': 5, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
    const {'1': 'responsible', '3': 6, '4': 1, '5': 11, '6': '.api.v1.User', '10': 'responsible'},
    const {'1': 'group', '3': 7, '4': 1, '5': 11, '6': '.api.v1.Group', '10': 'group'},
    const {'1': 'estimate', '3': 8, '4': 1, '5': 11, '6': '.api.v1.Duration', '10': 'estimate'},
    const {'1': 'checked', '3': 9, '4': 1, '5': 11, '6': '.api.v1.RecurringChecked', '9': 0, '10': 'checked'},
    const {'1': 'every', '3': 10, '4': 1, '5': 11, '6': '.api.v1.RecurringEveryResponse', '9': 0, '10': 'every'},
    const {'1': 'can_update', '3': 11, '4': 1, '5': 8, '10': 'canUpdate'},
    const {'1': 'can_toggle', '3': 12, '4': 1, '5': 8, '10': 'canToggle'},
    const {'1': 'can_delete', '3': 13, '4': 1, '5': 8, '10': 'canDelete'},
  ],
  '8': const [
    const {'1': 'recurring'},
  ],
};

/// Descriptor for `UpdateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskResponseDescriptor = $convert.base64Decode('ChJVcGRhdGVUYXNrUmVzcG9uc2USDgoCaWQYASABKAVSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIhCgxpc19jb21wbGV0ZWQYAyABKAhSC2lzQ29tcGxldGVkEjAKCnN0YXJ0X2RhdGUYBCABKAsyES5nb29nbGUudHlwZS5EYXRlUglzdGFydERhdGUSLAoIZW5kX2RhdGUYBSABKAsyES5nb29nbGUudHlwZS5EYXRlUgdlbmREYXRlEi4KC3Jlc3BvbnNpYmxlGAYgASgLMgwuYXBpLnYxLlVzZXJSC3Jlc3BvbnNpYmxlEiMKBWdyb3VwGAcgASgLMg0uYXBpLnYxLkdyb3VwUgVncm91cBIsCghlc3RpbWF0ZRgIIAEoCzIQLmFwaS52MS5EdXJhdGlvblIIZXN0aW1hdGUSNAoHY2hlY2tlZBgJIAEoCzIYLmFwaS52MS5SZWN1cnJpbmdDaGVja2VkSABSB2NoZWNrZWQSNgoFZXZlcnkYCiABKAsyHi5hcGkudjEuUmVjdXJyaW5nRXZlcnlSZXNwb25zZUgAUgVldmVyeRIdCgpjYW5fdXBkYXRlGAsgASgIUgljYW5VcGRhdGUSHQoKY2FuX3RvZ2dsZRgMIAEoCFIJY2FuVG9nZ2xlEh0KCmNhbl9kZWxldGUYDSABKAhSCWNhbkRlbGV0ZUILCglyZWN1cnJpbmc=');
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
    const {'1': 'task_created', '3': 3, '4': 1, '5': 11, '6': '.api.v1.CreateTaskResponse', '10': 'taskCreated'},
    const {'1': 'task_deleted', '3': 4, '4': 1, '5': 11, '6': '.api.v1.DeleteTaskResponse', '10': 'taskDeleted'},
    const {'1': 'task_updated', '3': 5, '4': 1, '5': 11, '6': '.api.v1.UpdateTaskResponse', '10': 'taskUpdated'},
    const {'1': 'can_update', '3': 6, '4': 1, '5': 8, '10': 'canUpdate'},
    const {'1': 'can_toggle', '3': 7, '4': 1, '5': 8, '10': 'canToggle'},
    const {'1': 'can_delete', '3': 8, '4': 1, '5': 8, '10': 'canDelete'},
  ],
};

/// Descriptor for `ToggleTaskCompletedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleTaskCompletedResponseDescriptor = $convert.base64Decode('ChtUb2dnbGVUYXNrQ29tcGxldGVkUmVzcG9uc2USDgoCaWQYASABKAVSAmlkEiEKDGlzX2NvbXBsZXRlZBgCIAEoCFILaXNDb21wbGV0ZWQSPQoMdGFza19jcmVhdGVkGAMgASgLMhouYXBpLnYxLkNyZWF0ZVRhc2tSZXNwb25zZVILdGFza0NyZWF0ZWQSPQoMdGFza19kZWxldGVkGAQgASgLMhouYXBpLnYxLkRlbGV0ZVRhc2tSZXNwb25zZVILdGFza0RlbGV0ZWQSPQoMdGFza191cGRhdGVkGAUgASgLMhouYXBpLnYxLlVwZGF0ZVRhc2tSZXNwb25zZVILdGFza1VwZGF0ZWQSHQoKY2FuX3VwZGF0ZRgGIAEoCFIJY2FuVXBkYXRlEh0KCmNhbl90b2dnbGUYByABKAhSCWNhblRvZ2dsZRIdCgpjYW5fZGVsZXRlGAggASgIUgljYW5EZWxldGU=');
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
    const {'1': 'responsible', '3': 6, '4': 1, '5': 11, '6': '.api.v1.User', '10': 'responsible'},
    const {'1': 'group', '3': 7, '4': 1, '5': 11, '6': '.api.v1.Group', '10': 'group'},
    const {'1': 'estimate', '3': 8, '4': 1, '5': 11, '6': '.api.v1.Duration', '10': 'estimate'},
    const {'1': 'checked', '3': 9, '4': 1, '5': 11, '6': '.api.v1.RecurringChecked', '9': 0, '10': 'checked'},
    const {'1': 'every', '3': 10, '4': 1, '5': 11, '6': '.api.v1.RecurringEveryResponse', '9': 0, '10': 'every'},
    const {'1': 'can_update', '3': 11, '4': 1, '5': 8, '10': 'canUpdate'},
    const {'1': 'can_toggle', '3': 12, '4': 1, '5': 8, '10': 'canToggle'},
    const {'1': 'can_delete', '3': 13, '4': 1, '5': 8, '10': 'canDelete'},
    const {'1': 'is_friend_task', '3': 14, '4': 1, '5': 8, '10': 'isFriendTask'},
  ],
  '8': const [
    const {'1': 'recurring'},
  ],
};

/// Descriptor for `GetTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTasksResponseDescriptor = $convert.base64Decode('ChBHZXRUYXNrc1Jlc3BvbnNlEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSIQoMaXNfY29tcGxldGVkGAMgASgIUgtpc0NvbXBsZXRlZBIwCgpzdGFydF9kYXRlGAQgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIJc3RhcnREYXRlEiwKCGVuZF9kYXRlGAUgASgLMhEuZ29vZ2xlLnR5cGUuRGF0ZVIHZW5kRGF0ZRIuCgtyZXNwb25zaWJsZRgGIAEoCzIMLmFwaS52MS5Vc2VyUgtyZXNwb25zaWJsZRIjCgVncm91cBgHIAEoCzINLmFwaS52MS5Hcm91cFIFZ3JvdXASLAoIZXN0aW1hdGUYCCABKAsyEC5hcGkudjEuRHVyYXRpb25SCGVzdGltYXRlEjQKB2NoZWNrZWQYCSABKAsyGC5hcGkudjEuUmVjdXJyaW5nQ2hlY2tlZEgAUgdjaGVja2VkEjYKBWV2ZXJ5GAogASgLMh4uYXBpLnYxLlJlY3VycmluZ0V2ZXJ5UmVzcG9uc2VIAFIFZXZlcnkSHQoKY2FuX3VwZGF0ZRgLIAEoCFIJY2FuVXBkYXRlEh0KCmNhbl90b2dnbGUYDCABKAhSCWNhblRvZ2dsZRIdCgpjYW5fZGVsZXRlGA0gASgIUgljYW5EZWxldGUSJAoOaXNfZnJpZW5kX3Rhc2sYDiABKAhSDGlzRnJpZW5kVGFza0ILCglyZWN1cnJpbmc=');
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
    const {'1': 'uid', '3': 3, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `CreateGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGroupResponseDescriptor = $convert.base64Decode('ChNDcmVhdGVHcm91cFJlc3BvbnNlEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSEAoDdWlkGAMgASgJUgN1aWQ=');
@$core.Deprecated('Use joinGroupRequestDescriptor instead')
const JoinGroupRequest$json = const {
  '1': 'JoinGroupRequest',
  '2': const [
    const {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `JoinGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinGroupRequestDescriptor = $convert.base64Decode('ChBKb2luR3JvdXBSZXF1ZXN0EhAKA3VpZBgBIAEoCVIDdWlk');
@$core.Deprecated('Use joinGroupResponseDescriptor instead')
const JoinGroupResponse$json = const {
  '1': 'JoinGroupResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'uid', '3': 3, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `JoinGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinGroupResponseDescriptor = $convert.base64Decode('ChFKb2luR3JvdXBSZXNwb25zZRIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhAKA3VpZBgDIAEoCVIDdWlk');
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
    const {'1': 'uid', '3': 3, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `UpdateGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGroupResponseDescriptor = $convert.base64Decode('ChNVcGRhdGVHcm91cFJlc3BvbnNlEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSEAoDdWlkGAMgASgJUgN1aWQ=');
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
    const {'1': 'uid', '3': 3, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `GetGroupsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupsResponseDescriptor = $convert.base64Decode('ChFHZXRHcm91cHNSZXNwb25zZRIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhAKA3VpZBgDIAEoCVIDdWlk');
@$core.Deprecated('Use getGroupParticipantsRequestDescriptor instead')
const GetGroupParticipantsRequest$json = const {
  '1': 'GetGroupParticipantsRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 5, '10': 'groupId'},
  ],
};

/// Descriptor for `GetGroupParticipantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupParticipantsRequestDescriptor = $convert.base64Decode('ChtHZXRHcm91cFBhcnRpY2lwYW50c1JlcXVlc3QSGQoIZ3JvdXBfaWQYASABKAVSB2dyb3VwSWQ=');
@$core.Deprecated('Use getGroupParticipantsResponseDescriptor instead')
const GetGroupParticipantsResponse$json = const {
  '1': 'GetGroupParticipantsResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.api.v1.User', '10': 'user'},
  ],
};

/// Descriptor for `GetGroupParticipantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupParticipantsResponseDescriptor = $convert.base64Decode('ChxHZXRHcm91cFBhcnRpY2lwYW50c1Jlc3BvbnNlEiAKBHVzZXIYASABKAsyDC5hcGkudjEuVXNlclIEdXNlcg==');
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'picture_url', '3': 3, '4': 1, '5': 9, '10': 'pictureUrl'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEg4KAmlkGAEgASgFUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh8KC3BpY3R1cmVfdXJsGAMgASgJUgpwaWN0dXJlVXJs');
@$core.Deprecated('Use groupDescriptor instead')
const Group$json = const {
  '1': 'Group',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'uid', '3': 3, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `Group`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupDescriptor = $convert.base64Decode('CgVHcm91cBIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhAKA3VpZBgDIAEoCVIDdWlk');
@$core.Deprecated('Use durationDescriptor instead')
const Duration$json = const {
  '1': 'Duration',
  '2': const [
    const {'1': 'days', '3': 1, '4': 1, '5': 5, '10': 'days'},
    const {'1': 'hours', '3': 2, '4': 1, '5': 5, '10': 'hours'},
    const {'1': 'minutes', '3': 3, '4': 1, '5': 5, '10': 'minutes'},
  ],
};

/// Descriptor for `Duration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List durationDescriptor = $convert.base64Decode('CghEdXJhdGlvbhISCgRkYXlzGAEgASgFUgRkYXlzEhQKBWhvdXJzGAIgASgFUgVob3VycxIYCgdtaW51dGVzGAMgASgFUgdtaW51dGVz');
@$core.Deprecated('Use recurringCheckedDescriptor instead')
const RecurringChecked$json = const {
  '1': 'RecurringChecked',
  '2': const [
    const {'1': 'days', '3': 1, '4': 1, '5': 5, '10': 'days'},
    const {'1': 'months', '3': 2, '4': 1, '5': 5, '10': 'months'},
  ],
};

/// Descriptor for `RecurringChecked`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recurringCheckedDescriptor = $convert.base64Decode('ChBSZWN1cnJpbmdDaGVja2VkEhIKBGRheXMYASABKAVSBGRheXMSFgoGbW9udGhzGAIgASgFUgZtb250aHM=');
@$core.Deprecated('Use recurringEveryRequestDescriptor instead')
const RecurringEveryRequest$json = const {
  '1': 'RecurringEveryRequest',
  '2': const [
    const {'1': 'days', '3': 1, '4': 1, '5': 5, '10': 'days'},
    const {'1': 'months', '3': 2, '4': 1, '5': 5, '10': 'months'},
  ],
};

/// Descriptor for `RecurringEveryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recurringEveryRequestDescriptor = $convert.base64Decode('ChVSZWN1cnJpbmdFdmVyeVJlcXVlc3QSEgoEZGF5cxgBIAEoBVIEZGF5cxIWCgZtb250aHMYAiABKAVSBm1vbnRocw==');
@$core.Deprecated('Use recurringEveryResponseDescriptor instead')
const RecurringEveryResponse$json = const {
  '1': 'RecurringEveryResponse',
  '2': const [
    const {'1': 'days', '3': 1, '4': 1, '5': 5, '10': 'days'},
    const {'1': 'months', '3': 2, '4': 1, '5': 5, '10': 'months'},
    const {'1': 'num_ready_to_start', '3': 3, '4': 1, '5': 5, '10': 'numReadyToStart'},
    const {'1': 'num_ready_to_start_is_lower_bound', '3': 4, '4': 1, '5': 8, '10': 'numReadyToStartIsLowerBound'},
    const {'1': 'num_reached_deadline', '3': 5, '4': 1, '5': 5, '10': 'numReachedDeadline'},
    const {'1': 'num_reached_deadline_is_lower_bound', '3': 6, '4': 1, '5': 8, '10': 'numReachedDeadlineIsLowerBound'},
  ],
};

/// Descriptor for `RecurringEveryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recurringEveryResponseDescriptor = $convert.base64Decode('ChZSZWN1cnJpbmdFdmVyeVJlc3BvbnNlEhIKBGRheXMYASABKAVSBGRheXMSFgoGbW9udGhzGAIgASgFUgZtb250aHMSKwoSbnVtX3JlYWR5X3RvX3N0YXJ0GAMgASgFUg9udW1SZWFkeVRvU3RhcnQSRgohbnVtX3JlYWR5X3RvX3N0YXJ0X2lzX2xvd2VyX2JvdW5kGAQgASgIUhtudW1SZWFkeVRvU3RhcnRJc0xvd2VyQm91bmQSMAoUbnVtX3JlYWNoZWRfZGVhZGxpbmUYBSABKAVSEm51bVJlYWNoZWREZWFkbGluZRJLCiNudW1fcmVhY2hlZF9kZWFkbGluZV9pc19sb3dlcl9ib3VuZBgGIAEoCFIebnVtUmVhY2hlZERlYWRsaW5lSXNMb3dlckJvdW5k');
const $core.Map<$core.String, $core.dynamic> APIServiceBase$json = const {
  '1': 'API',
  '2': const [
    const {'1': 'Login', '2': '.api.v1.LoginRequest', '3': '.api.v1.LoginResponse'},
    const {'1': 'CreateTask', '2': '.api.v1.CreateTaskRequest', '3': '.api.v1.CreateTaskResponse'},
    const {'1': 'UpdateTask', '2': '.api.v1.UpdateTaskRequest', '3': '.api.v1.UpdateTaskResponse'},
    const {'1': 'ToggleTaskCompleted', '2': '.api.v1.ToggleTaskCompletedRequest', '3': '.api.v1.ToggleTaskCompletedResponse'},
    const {'1': 'DeleteTask', '2': '.api.v1.DeleteTaskRequest', '3': '.api.v1.DeleteTaskResponse'},
    const {'1': 'GetTasks', '2': '.api.v1.GetTasksRequest', '3': '.api.v1.GetTasksResponse', '6': true},
    const {'1': 'CreateGroup', '2': '.api.v1.CreateGroupRequest', '3': '.api.v1.CreateGroupResponse'},
    const {'1': 'JoinGroup', '2': '.api.v1.JoinGroupRequest', '3': '.api.v1.JoinGroupResponse'},
    const {'1': 'UpdateGroup', '2': '.api.v1.UpdateGroupRequest', '3': '.api.v1.UpdateGroupResponse'},
    const {'1': 'LeaveGroup', '2': '.api.v1.LeaveGroupRequest', '3': '.api.v1.LeaveGroupResponse'},
    const {'1': 'GetGroups', '2': '.api.v1.GetGroupsRequest', '3': '.api.v1.GetGroupsResponse', '6': true},
    const {'1': 'GetGroupParticipants', '2': '.api.v1.GetGroupParticipantsRequest', '3': '.api.v1.GetGroupParticipantsResponse', '6': true},
  ],
};

@$core.Deprecated('Use aPIServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> APIServiceBase$messageJson = const {
  '.api.v1.LoginRequest': LoginRequest$json,
  '.api.v1.LoginResponse': LoginResponse$json,
  '.api.v1.User': User$json,
  '.api.v1.CreateTaskRequest': CreateTaskRequest$json,
  '.google.type.Date': $0.Date$json,
  '.api.v1.Duration': Duration$json,
  '.api.v1.RecurringChecked': RecurringChecked$json,
  '.api.v1.RecurringEveryRequest': RecurringEveryRequest$json,
  '.api.v1.CreateTaskResponse': CreateTaskResponse$json,
  '.api.v1.Group': Group$json,
  '.api.v1.RecurringEveryResponse': RecurringEveryResponse$json,
  '.api.v1.UpdateTaskRequest': UpdateTaskRequest$json,
  '.api.v1.UpdateTaskResponse': UpdateTaskResponse$json,
  '.api.v1.ToggleTaskCompletedRequest': ToggleTaskCompletedRequest$json,
  '.api.v1.ToggleTaskCompletedResponse': ToggleTaskCompletedResponse$json,
  '.api.v1.DeleteTaskResponse': DeleteTaskResponse$json,
  '.api.v1.DeleteTaskRequest': DeleteTaskRequest$json,
  '.api.v1.GetTasksRequest': GetTasksRequest$json,
  '.api.v1.GetTasksResponse': GetTasksResponse$json,
  '.api.v1.CreateGroupRequest': CreateGroupRequest$json,
  '.api.v1.CreateGroupResponse': CreateGroupResponse$json,
  '.api.v1.JoinGroupRequest': JoinGroupRequest$json,
  '.api.v1.JoinGroupResponse': JoinGroupResponse$json,
  '.api.v1.UpdateGroupRequest': UpdateGroupRequest$json,
  '.api.v1.UpdateGroupResponse': UpdateGroupResponse$json,
  '.api.v1.LeaveGroupRequest': LeaveGroupRequest$json,
  '.api.v1.LeaveGroupResponse': LeaveGroupResponse$json,
  '.api.v1.GetGroupsRequest': GetGroupsRequest$json,
  '.api.v1.GetGroupsResponse': GetGroupsResponse$json,
  '.api.v1.GetGroupParticipantsRequest': GetGroupParticipantsRequest$json,
  '.api.v1.GetGroupParticipantsResponse': GetGroupParticipantsResponse$json,
};

/// Descriptor for `API`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List aPIServiceDescriptor = $convert.base64Decode('CgNBUEkSNAoFTG9naW4SFC5hcGkudjEuTG9naW5SZXF1ZXN0GhUuYXBpLnYxLkxvZ2luUmVzcG9uc2USQwoKQ3JlYXRlVGFzaxIZLmFwaS52MS5DcmVhdGVUYXNrUmVxdWVzdBoaLmFwaS52MS5DcmVhdGVUYXNrUmVzcG9uc2USQwoKVXBkYXRlVGFzaxIZLmFwaS52MS5VcGRhdGVUYXNrUmVxdWVzdBoaLmFwaS52MS5VcGRhdGVUYXNrUmVzcG9uc2USXgoTVG9nZ2xlVGFza0NvbXBsZXRlZBIiLmFwaS52MS5Ub2dnbGVUYXNrQ29tcGxldGVkUmVxdWVzdBojLmFwaS52MS5Ub2dnbGVUYXNrQ29tcGxldGVkUmVzcG9uc2USQwoKRGVsZXRlVGFzaxIZLmFwaS52MS5EZWxldGVUYXNrUmVxdWVzdBoaLmFwaS52MS5EZWxldGVUYXNrUmVzcG9uc2USPwoIR2V0VGFza3MSFy5hcGkudjEuR2V0VGFza3NSZXF1ZXN0GhguYXBpLnYxLkdldFRhc2tzUmVzcG9uc2UwARJGCgtDcmVhdGVHcm91cBIaLmFwaS52MS5DcmVhdGVHcm91cFJlcXVlc3QaGy5hcGkudjEuQ3JlYXRlR3JvdXBSZXNwb25zZRJACglKb2luR3JvdXASGC5hcGkudjEuSm9pbkdyb3VwUmVxdWVzdBoZLmFwaS52MS5Kb2luR3JvdXBSZXNwb25zZRJGCgtVcGRhdGVHcm91cBIaLmFwaS52MS5VcGRhdGVHcm91cFJlcXVlc3QaGy5hcGkudjEuVXBkYXRlR3JvdXBSZXNwb25zZRJDCgpMZWF2ZUdyb3VwEhkuYXBpLnYxLkxlYXZlR3JvdXBSZXF1ZXN0GhouYXBpLnYxLkxlYXZlR3JvdXBSZXNwb25zZRJCCglHZXRHcm91cHMSGC5hcGkudjEuR2V0R3JvdXBzUmVxdWVzdBoZLmFwaS52MS5HZXRHcm91cHNSZXNwb25zZTABEmMKFEdldEdyb3VwUGFydGljaXBhbnRzEiMuYXBpLnYxLkdldEdyb3VwUGFydGljaXBhbnRzUmVxdWVzdBokLmFwaS52MS5HZXRHcm91cFBhcnRpY2lwYW50c1Jlc3BvbnNlMAE=');
