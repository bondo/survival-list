///
//  Generated code. Do not modify.
//  source: api/v1/api.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/type/date.pb.dart' as $0;

class LoginRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pictureUrl')
    ..hasRequiredFields = false
  ;

  LoginRequest._() : super();
  factory LoginRequest({
    $core.String? name,
    $core.String? pictureUrl,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (pictureUrl != null) {
      _result.pictureUrl = pictureUrl;
    }
    return _result;
  }
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pictureUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set pictureUrl($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPictureUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearPictureUrl() => clearField(2);
}

class LoginResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..aOM<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  LoginResponse._() : super();
  factory LoginResponse({
    User? user,
  }) {
    final _result = create();
    if (user != null) {
      _result.user = user;
    }
    return _result;
  }
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() => $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

enum CreateTaskRequest_Recurring {
  checked, 
  every, 
  notSet
}

class CreateTaskRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, CreateTaskRequest_Recurring> _CreateTaskRequest_RecurringByTag = {
    7 : CreateTaskRequest_Recurring.checked,
    8 : CreateTaskRequest_Recurring.every,
    0 : CreateTaskRequest_Recurring.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateTaskRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..oo(0, [7, 8])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOM<$0.Date>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startDate', subBuilder: $0.Date.create)
    ..aOM<$0.Date>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endDate', subBuilder: $0.Date.create)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'responsibleId', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId', $pb.PbFieldType.O3)
    ..aOM<Duration>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'estimate', subBuilder: Duration.create)
    ..aOM<RecurringChecked>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'checked', subBuilder: RecurringChecked.create)
    ..aOM<RecurringEveryRequest>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'every', subBuilder: RecurringEveryRequest.create)
    ..hasRequiredFields = false
  ;

  CreateTaskRequest._() : super();
  factory CreateTaskRequest({
    $core.String? title,
    $0.Date? startDate,
    $0.Date? endDate,
    $core.int? responsibleId,
    $core.int? groupId,
    Duration? estimate,
    RecurringChecked? checked,
    RecurringEveryRequest? every,
  }) {
    final _result = create();
    if (title != null) {
      _result.title = title;
    }
    if (startDate != null) {
      _result.startDate = startDate;
    }
    if (endDate != null) {
      _result.endDate = endDate;
    }
    if (responsibleId != null) {
      _result.responsibleId = responsibleId;
    }
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (estimate != null) {
      _result.estimate = estimate;
    }
    if (checked != null) {
      _result.checked = checked;
    }
    if (every != null) {
      _result.every = every;
    }
    return _result;
  }
  factory CreateTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateTaskRequest clone() => CreateTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateTaskRequest copyWith(void Function(CreateTaskRequest) updates) => super.copyWith((message) => updates(message as CreateTaskRequest)) as CreateTaskRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateTaskRequest create() => CreateTaskRequest._();
  CreateTaskRequest createEmptyInstance() => create();
  static $pb.PbList<CreateTaskRequest> createRepeated() => $pb.PbList<CreateTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateTaskRequest>(create);
  static CreateTaskRequest? _defaultInstance;

  CreateTaskRequest_Recurring whichRecurring() => _CreateTaskRequest_RecurringByTag[$_whichOneof(0)]!;
  void clearRecurring() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $0.Date get startDate => $_getN(1);
  @$pb.TagNumber(2)
  set startDate($0.Date v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartDate() => clearField(2);
  @$pb.TagNumber(2)
  $0.Date ensureStartDate() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Date get endDate => $_getN(2);
  @$pb.TagNumber(3)
  set endDate($0.Date v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEndDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndDate() => clearField(3);
  @$pb.TagNumber(3)
  $0.Date ensureEndDate() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get responsibleId => $_getIZ(3);
  @$pb.TagNumber(4)
  set responsibleId($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasResponsibleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearResponsibleId() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get groupId => $_getIZ(4);
  @$pb.TagNumber(5)
  set groupId($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGroupId() => $_has(4);
  @$pb.TagNumber(5)
  void clearGroupId() => clearField(5);

  @$pb.TagNumber(6)
  Duration get estimate => $_getN(5);
  @$pb.TagNumber(6)
  set estimate(Duration v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasEstimate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimate() => clearField(6);
  @$pb.TagNumber(6)
  Duration ensureEstimate() => $_ensure(5);

  @$pb.TagNumber(7)
  RecurringChecked get checked => $_getN(6);
  @$pb.TagNumber(7)
  set checked(RecurringChecked v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasChecked() => $_has(6);
  @$pb.TagNumber(7)
  void clearChecked() => clearField(7);
  @$pb.TagNumber(7)
  RecurringChecked ensureChecked() => $_ensure(6);

  @$pb.TagNumber(8)
  RecurringEveryRequest get every => $_getN(7);
  @$pb.TagNumber(8)
  set every(RecurringEveryRequest v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasEvery() => $_has(7);
  @$pb.TagNumber(8)
  void clearEvery() => clearField(8);
  @$pb.TagNumber(8)
  RecurringEveryRequest ensureEvery() => $_ensure(7);
}

enum CreateTaskResponse_Recurring {
  checked, 
  every, 
  notSet
}

class CreateTaskResponse extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, CreateTaskResponse_Recurring> _CreateTaskResponse_RecurringByTag = {
    8 : CreateTaskResponse_Recurring.checked,
    9 : CreateTaskResponse_Recurring.every,
    0 : CreateTaskResponse_Recurring.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateTaskResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..oo(0, [8, 9])
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOM<$0.Date>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startDate', subBuilder: $0.Date.create)
    ..aOM<$0.Date>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endDate', subBuilder: $0.Date.create)
    ..aOM<User>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'responsible', subBuilder: User.create)
    ..aOM<Group>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'group', subBuilder: Group.create)
    ..aOM<Duration>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'estimate', subBuilder: Duration.create)
    ..aOM<RecurringChecked>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'checked', subBuilder: RecurringChecked.create)
    ..aOM<RecurringEveryResponse>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'every', subBuilder: RecurringEveryResponse.create)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canUpdate')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canToggle')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canDelete')
    ..hasRequiredFields = false
  ;

  CreateTaskResponse._() : super();
  factory CreateTaskResponse({
    $core.int? id,
    $core.String? title,
    $0.Date? startDate,
    $0.Date? endDate,
    User? responsible,
    Group? group,
    Duration? estimate,
    RecurringChecked? checked,
    RecurringEveryResponse? every,
    $core.bool? canUpdate,
    $core.bool? canToggle,
    $core.bool? canDelete,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (startDate != null) {
      _result.startDate = startDate;
    }
    if (endDate != null) {
      _result.endDate = endDate;
    }
    if (responsible != null) {
      _result.responsible = responsible;
    }
    if (group != null) {
      _result.group = group;
    }
    if (estimate != null) {
      _result.estimate = estimate;
    }
    if (checked != null) {
      _result.checked = checked;
    }
    if (every != null) {
      _result.every = every;
    }
    if (canUpdate != null) {
      _result.canUpdate = canUpdate;
    }
    if (canToggle != null) {
      _result.canToggle = canToggle;
    }
    if (canDelete != null) {
      _result.canDelete = canDelete;
    }
    return _result;
  }
  factory CreateTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateTaskResponse clone() => CreateTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateTaskResponse copyWith(void Function(CreateTaskResponse) updates) => super.copyWith((message) => updates(message as CreateTaskResponse)) as CreateTaskResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateTaskResponse create() => CreateTaskResponse._();
  CreateTaskResponse createEmptyInstance() => create();
  static $pb.PbList<CreateTaskResponse> createRepeated() => $pb.PbList<CreateTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateTaskResponse>(create);
  static CreateTaskResponse? _defaultInstance;

  CreateTaskResponse_Recurring whichRecurring() => _CreateTaskResponse_RecurringByTag[$_whichOneof(0)]!;
  void clearRecurring() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $0.Date get startDate => $_getN(2);
  @$pb.TagNumber(3)
  set startDate($0.Date v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartDate() => clearField(3);
  @$pb.TagNumber(3)
  $0.Date ensureStartDate() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Date get endDate => $_getN(3);
  @$pb.TagNumber(4)
  set endDate($0.Date v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEndDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndDate() => clearField(4);
  @$pb.TagNumber(4)
  $0.Date ensureEndDate() => $_ensure(3);

  @$pb.TagNumber(5)
  User get responsible => $_getN(4);
  @$pb.TagNumber(5)
  set responsible(User v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasResponsible() => $_has(4);
  @$pb.TagNumber(5)
  void clearResponsible() => clearField(5);
  @$pb.TagNumber(5)
  User ensureResponsible() => $_ensure(4);

  @$pb.TagNumber(6)
  Group get group => $_getN(5);
  @$pb.TagNumber(6)
  set group(Group v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasGroup() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroup() => clearField(6);
  @$pb.TagNumber(6)
  Group ensureGroup() => $_ensure(5);

  @$pb.TagNumber(7)
  Duration get estimate => $_getN(6);
  @$pb.TagNumber(7)
  set estimate(Duration v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEstimate() => $_has(6);
  @$pb.TagNumber(7)
  void clearEstimate() => clearField(7);
  @$pb.TagNumber(7)
  Duration ensureEstimate() => $_ensure(6);

  @$pb.TagNumber(8)
  RecurringChecked get checked => $_getN(7);
  @$pb.TagNumber(8)
  set checked(RecurringChecked v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasChecked() => $_has(7);
  @$pb.TagNumber(8)
  void clearChecked() => clearField(8);
  @$pb.TagNumber(8)
  RecurringChecked ensureChecked() => $_ensure(7);

  @$pb.TagNumber(9)
  RecurringEveryResponse get every => $_getN(8);
  @$pb.TagNumber(9)
  set every(RecurringEveryResponse v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasEvery() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvery() => clearField(9);
  @$pb.TagNumber(9)
  RecurringEveryResponse ensureEvery() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.bool get canUpdate => $_getBF(9);
  @$pb.TagNumber(10)
  set canUpdate($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasCanUpdate() => $_has(9);
  @$pb.TagNumber(10)
  void clearCanUpdate() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get canToggle => $_getBF(10);
  @$pb.TagNumber(11)
  set canToggle($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCanToggle() => $_has(10);
  @$pb.TagNumber(11)
  void clearCanToggle() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get canDelete => $_getBF(11);
  @$pb.TagNumber(12)
  set canDelete($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasCanDelete() => $_has(11);
  @$pb.TagNumber(12)
  void clearCanDelete() => clearField(12);
}

enum UpdateTaskRequest_Recurring {
  checked, 
  every, 
  notSet
}

class UpdateTaskRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, UpdateTaskRequest_Recurring> _UpdateTaskRequest_RecurringByTag = {
    8 : UpdateTaskRequest_Recurring.checked,
    9 : UpdateTaskRequest_Recurring.every,
    0 : UpdateTaskRequest_Recurring.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateTaskRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..oo(0, [8, 9])
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOM<$0.Date>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startDate', subBuilder: $0.Date.create)
    ..aOM<$0.Date>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endDate', subBuilder: $0.Date.create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'responsibleId', $pb.PbFieldType.O3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId', $pb.PbFieldType.O3)
    ..aOM<Duration>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'estimate', subBuilder: Duration.create)
    ..aOM<RecurringChecked>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'checked', subBuilder: RecurringChecked.create)
    ..aOM<RecurringEveryRequest>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'every', subBuilder: RecurringEveryRequest.create)
    ..hasRequiredFields = false
  ;

  UpdateTaskRequest._() : super();
  factory UpdateTaskRequest({
    $core.int? id,
    $core.String? title,
    $0.Date? startDate,
    $0.Date? endDate,
    $core.int? responsibleId,
    $core.int? groupId,
    Duration? estimate,
    RecurringChecked? checked,
    RecurringEveryRequest? every,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (startDate != null) {
      _result.startDate = startDate;
    }
    if (endDate != null) {
      _result.endDate = endDate;
    }
    if (responsibleId != null) {
      _result.responsibleId = responsibleId;
    }
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (estimate != null) {
      _result.estimate = estimate;
    }
    if (checked != null) {
      _result.checked = checked;
    }
    if (every != null) {
      _result.every = every;
    }
    return _result;
  }
  factory UpdateTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateTaskRequest clone() => UpdateTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateTaskRequest copyWith(void Function(UpdateTaskRequest) updates) => super.copyWith((message) => updates(message as UpdateTaskRequest)) as UpdateTaskRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateTaskRequest create() => UpdateTaskRequest._();
  UpdateTaskRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateTaskRequest> createRepeated() => $pb.PbList<UpdateTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateTaskRequest>(create);
  static UpdateTaskRequest? _defaultInstance;

  UpdateTaskRequest_Recurring whichRecurring() => _UpdateTaskRequest_RecurringByTag[$_whichOneof(0)]!;
  void clearRecurring() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $0.Date get startDate => $_getN(2);
  @$pb.TagNumber(3)
  set startDate($0.Date v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartDate() => clearField(3);
  @$pb.TagNumber(3)
  $0.Date ensureStartDate() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Date get endDate => $_getN(3);
  @$pb.TagNumber(4)
  set endDate($0.Date v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEndDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndDate() => clearField(4);
  @$pb.TagNumber(4)
  $0.Date ensureEndDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get responsibleId => $_getIZ(4);
  @$pb.TagNumber(5)
  set responsibleId($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasResponsibleId() => $_has(4);
  @$pb.TagNumber(5)
  void clearResponsibleId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get groupId => $_getIZ(5);
  @$pb.TagNumber(6)
  set groupId($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGroupId() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroupId() => clearField(6);

  @$pb.TagNumber(7)
  Duration get estimate => $_getN(6);
  @$pb.TagNumber(7)
  set estimate(Duration v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEstimate() => $_has(6);
  @$pb.TagNumber(7)
  void clearEstimate() => clearField(7);
  @$pb.TagNumber(7)
  Duration ensureEstimate() => $_ensure(6);

  @$pb.TagNumber(8)
  RecurringChecked get checked => $_getN(7);
  @$pb.TagNumber(8)
  set checked(RecurringChecked v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasChecked() => $_has(7);
  @$pb.TagNumber(8)
  void clearChecked() => clearField(8);
  @$pb.TagNumber(8)
  RecurringChecked ensureChecked() => $_ensure(7);

  @$pb.TagNumber(9)
  RecurringEveryRequest get every => $_getN(8);
  @$pb.TagNumber(9)
  set every(RecurringEveryRequest v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasEvery() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvery() => clearField(9);
  @$pb.TagNumber(9)
  RecurringEveryRequest ensureEvery() => $_ensure(8);
}

enum UpdateTaskResponse_Recurring {
  checked, 
  every, 
  notSet
}

class UpdateTaskResponse extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, UpdateTaskResponse_Recurring> _UpdateTaskResponse_RecurringByTag = {
    9 : UpdateTaskResponse_Recurring.checked,
    10 : UpdateTaskResponse_Recurring.every,
    0 : UpdateTaskResponse_Recurring.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateTaskResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..oo(0, [9, 10])
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCompleted')
    ..aOM<$0.Date>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startDate', subBuilder: $0.Date.create)
    ..aOM<$0.Date>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endDate', subBuilder: $0.Date.create)
    ..aOM<User>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'responsible', subBuilder: User.create)
    ..aOM<Group>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'group', subBuilder: Group.create)
    ..aOM<Duration>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'estimate', subBuilder: Duration.create)
    ..aOM<RecurringChecked>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'checked', subBuilder: RecurringChecked.create)
    ..aOM<RecurringEveryResponse>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'every', subBuilder: RecurringEveryResponse.create)
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canUpdate')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canToggle')
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canDelete')
    ..hasRequiredFields = false
  ;

  UpdateTaskResponse._() : super();
  factory UpdateTaskResponse({
    $core.int? id,
    $core.String? title,
    $core.bool? isCompleted,
    $0.Date? startDate,
    $0.Date? endDate,
    User? responsible,
    Group? group,
    Duration? estimate,
    RecurringChecked? checked,
    RecurringEveryResponse? every,
    $core.bool? canUpdate,
    $core.bool? canToggle,
    $core.bool? canDelete,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (isCompleted != null) {
      _result.isCompleted = isCompleted;
    }
    if (startDate != null) {
      _result.startDate = startDate;
    }
    if (endDate != null) {
      _result.endDate = endDate;
    }
    if (responsible != null) {
      _result.responsible = responsible;
    }
    if (group != null) {
      _result.group = group;
    }
    if (estimate != null) {
      _result.estimate = estimate;
    }
    if (checked != null) {
      _result.checked = checked;
    }
    if (every != null) {
      _result.every = every;
    }
    if (canUpdate != null) {
      _result.canUpdate = canUpdate;
    }
    if (canToggle != null) {
      _result.canToggle = canToggle;
    }
    if (canDelete != null) {
      _result.canDelete = canDelete;
    }
    return _result;
  }
  factory UpdateTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateTaskResponse clone() => UpdateTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateTaskResponse copyWith(void Function(UpdateTaskResponse) updates) => super.copyWith((message) => updates(message as UpdateTaskResponse)) as UpdateTaskResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateTaskResponse create() => UpdateTaskResponse._();
  UpdateTaskResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateTaskResponse> createRepeated() => $pb.PbList<UpdateTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateTaskResponse>(create);
  static UpdateTaskResponse? _defaultInstance;

  UpdateTaskResponse_Recurring whichRecurring() => _UpdateTaskResponse_RecurringByTag[$_whichOneof(0)]!;
  void clearRecurring() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isCompleted => $_getBF(2);
  @$pb.TagNumber(3)
  set isCompleted($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsCompleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsCompleted() => clearField(3);

  @$pb.TagNumber(4)
  $0.Date get startDate => $_getN(3);
  @$pb.TagNumber(4)
  set startDate($0.Date v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStartDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartDate() => clearField(4);
  @$pb.TagNumber(4)
  $0.Date ensureStartDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Date get endDate => $_getN(4);
  @$pb.TagNumber(5)
  set endDate($0.Date v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasEndDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndDate() => clearField(5);
  @$pb.TagNumber(5)
  $0.Date ensureEndDate() => $_ensure(4);

  @$pb.TagNumber(6)
  User get responsible => $_getN(5);
  @$pb.TagNumber(6)
  set responsible(User v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasResponsible() => $_has(5);
  @$pb.TagNumber(6)
  void clearResponsible() => clearField(6);
  @$pb.TagNumber(6)
  User ensureResponsible() => $_ensure(5);

  @$pb.TagNumber(7)
  Group get group => $_getN(6);
  @$pb.TagNumber(7)
  set group(Group v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroup() => clearField(7);
  @$pb.TagNumber(7)
  Group ensureGroup() => $_ensure(6);

  @$pb.TagNumber(8)
  Duration get estimate => $_getN(7);
  @$pb.TagNumber(8)
  set estimate(Duration v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasEstimate() => $_has(7);
  @$pb.TagNumber(8)
  void clearEstimate() => clearField(8);
  @$pb.TagNumber(8)
  Duration ensureEstimate() => $_ensure(7);

  @$pb.TagNumber(9)
  RecurringChecked get checked => $_getN(8);
  @$pb.TagNumber(9)
  set checked(RecurringChecked v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasChecked() => $_has(8);
  @$pb.TagNumber(9)
  void clearChecked() => clearField(9);
  @$pb.TagNumber(9)
  RecurringChecked ensureChecked() => $_ensure(8);

  @$pb.TagNumber(10)
  RecurringEveryResponse get every => $_getN(9);
  @$pb.TagNumber(10)
  set every(RecurringEveryResponse v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEvery() => $_has(9);
  @$pb.TagNumber(10)
  void clearEvery() => clearField(10);
  @$pb.TagNumber(10)
  RecurringEveryResponse ensureEvery() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get canUpdate => $_getBF(10);
  @$pb.TagNumber(11)
  set canUpdate($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCanUpdate() => $_has(10);
  @$pb.TagNumber(11)
  void clearCanUpdate() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get canToggle => $_getBF(11);
  @$pb.TagNumber(12)
  set canToggle($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasCanToggle() => $_has(11);
  @$pb.TagNumber(12)
  void clearCanToggle() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get canDelete => $_getBF(12);
  @$pb.TagNumber(13)
  set canDelete($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasCanDelete() => $_has(12);
  @$pb.TagNumber(13)
  void clearCanDelete() => clearField(13);
}

class ToggleTaskCompletedRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ToggleTaskCompletedRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCompleted')
    ..hasRequiredFields = false
  ;

  ToggleTaskCompletedRequest._() : super();
  factory ToggleTaskCompletedRequest({
    $core.int? id,
    $core.bool? isCompleted,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (isCompleted != null) {
      _result.isCompleted = isCompleted;
    }
    return _result;
  }
  factory ToggleTaskCompletedRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToggleTaskCompletedRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToggleTaskCompletedRequest clone() => ToggleTaskCompletedRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToggleTaskCompletedRequest copyWith(void Function(ToggleTaskCompletedRequest) updates) => super.copyWith((message) => updates(message as ToggleTaskCompletedRequest)) as ToggleTaskCompletedRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ToggleTaskCompletedRequest create() => ToggleTaskCompletedRequest._();
  ToggleTaskCompletedRequest createEmptyInstance() => create();
  static $pb.PbList<ToggleTaskCompletedRequest> createRepeated() => $pb.PbList<ToggleTaskCompletedRequest>();
  @$core.pragma('dart2js:noInline')
  static ToggleTaskCompletedRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToggleTaskCompletedRequest>(create);
  static ToggleTaskCompletedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isCompleted => $_getBF(1);
  @$pb.TagNumber(2)
  set isCompleted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsCompleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsCompleted() => clearField(2);
}

class ToggleTaskCompletedResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ToggleTaskCompletedResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCompleted')
    ..aOM<CreateTaskResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'taskCreated', subBuilder: CreateTaskResponse.create)
    ..aOM<DeleteTaskResponse>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'taskDeleted', subBuilder: DeleteTaskResponse.create)
    ..aOM<UpdateTaskResponse>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'taskUpdated', subBuilder: UpdateTaskResponse.create)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canUpdate')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canToggle')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canDelete')
    ..hasRequiredFields = false
  ;

  ToggleTaskCompletedResponse._() : super();
  factory ToggleTaskCompletedResponse({
    $core.int? id,
    $core.bool? isCompleted,
    CreateTaskResponse? taskCreated,
    DeleteTaskResponse? taskDeleted,
    UpdateTaskResponse? taskUpdated,
    $core.bool? canUpdate,
    $core.bool? canToggle,
    $core.bool? canDelete,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (isCompleted != null) {
      _result.isCompleted = isCompleted;
    }
    if (taskCreated != null) {
      _result.taskCreated = taskCreated;
    }
    if (taskDeleted != null) {
      _result.taskDeleted = taskDeleted;
    }
    if (taskUpdated != null) {
      _result.taskUpdated = taskUpdated;
    }
    if (canUpdate != null) {
      _result.canUpdate = canUpdate;
    }
    if (canToggle != null) {
      _result.canToggle = canToggle;
    }
    if (canDelete != null) {
      _result.canDelete = canDelete;
    }
    return _result;
  }
  factory ToggleTaskCompletedResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToggleTaskCompletedResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToggleTaskCompletedResponse clone() => ToggleTaskCompletedResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToggleTaskCompletedResponse copyWith(void Function(ToggleTaskCompletedResponse) updates) => super.copyWith((message) => updates(message as ToggleTaskCompletedResponse)) as ToggleTaskCompletedResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ToggleTaskCompletedResponse create() => ToggleTaskCompletedResponse._();
  ToggleTaskCompletedResponse createEmptyInstance() => create();
  static $pb.PbList<ToggleTaskCompletedResponse> createRepeated() => $pb.PbList<ToggleTaskCompletedResponse>();
  @$core.pragma('dart2js:noInline')
  static ToggleTaskCompletedResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToggleTaskCompletedResponse>(create);
  static ToggleTaskCompletedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isCompleted => $_getBF(1);
  @$pb.TagNumber(2)
  set isCompleted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsCompleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsCompleted() => clearField(2);

  @$pb.TagNumber(3)
  CreateTaskResponse get taskCreated => $_getN(2);
  @$pb.TagNumber(3)
  set taskCreated(CreateTaskResponse v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTaskCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskCreated() => clearField(3);
  @$pb.TagNumber(3)
  CreateTaskResponse ensureTaskCreated() => $_ensure(2);

  @$pb.TagNumber(4)
  DeleteTaskResponse get taskDeleted => $_getN(3);
  @$pb.TagNumber(4)
  set taskDeleted(DeleteTaskResponse v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTaskDeleted() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaskDeleted() => clearField(4);
  @$pb.TagNumber(4)
  DeleteTaskResponse ensureTaskDeleted() => $_ensure(3);

  @$pb.TagNumber(5)
  UpdateTaskResponse get taskUpdated => $_getN(4);
  @$pb.TagNumber(5)
  set taskUpdated(UpdateTaskResponse v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTaskUpdated() => $_has(4);
  @$pb.TagNumber(5)
  void clearTaskUpdated() => clearField(5);
  @$pb.TagNumber(5)
  UpdateTaskResponse ensureTaskUpdated() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get canUpdate => $_getBF(5);
  @$pb.TagNumber(6)
  set canUpdate($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCanUpdate() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanUpdate() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get canToggle => $_getBF(6);
  @$pb.TagNumber(7)
  set canToggle($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCanToggle() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanToggle() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get canDelete => $_getBF(7);
  @$pb.TagNumber(8)
  set canDelete($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCanDelete() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanDelete() => clearField(8);
}

class DeleteTaskRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteTaskRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DeleteTaskRequest._() : super();
  factory DeleteTaskRequest({
    $core.int? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteTaskRequest clone() => DeleteTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteTaskRequest copyWith(void Function(DeleteTaskRequest) updates) => super.copyWith((message) => updates(message as DeleteTaskRequest)) as DeleteTaskRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteTaskRequest create() => DeleteTaskRequest._();
  DeleteTaskRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteTaskRequest> createRepeated() => $pb.PbList<DeleteTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteTaskRequest>(create);
  static DeleteTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteTaskResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteTaskResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DeleteTaskResponse._() : super();
  factory DeleteTaskResponse({
    $core.int? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteTaskResponse clone() => DeleteTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteTaskResponse copyWith(void Function(DeleteTaskResponse) updates) => super.copyWith((message) => updates(message as DeleteTaskResponse)) as DeleteTaskResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteTaskResponse create() => DeleteTaskResponse._();
  DeleteTaskResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteTaskResponse> createRepeated() => $pb.PbList<DeleteTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteTaskResponse>(create);
  static DeleteTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class GetTasksRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetTasksRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  GetTasksRequest._() : super();
  factory GetTasksRequest() => create();
  factory GetTasksRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTasksRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTasksRequest clone() => GetTasksRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTasksRequest copyWith(void Function(GetTasksRequest) updates) => super.copyWith((message) => updates(message as GetTasksRequest)) as GetTasksRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetTasksRequest create() => GetTasksRequest._();
  GetTasksRequest createEmptyInstance() => create();
  static $pb.PbList<GetTasksRequest> createRepeated() => $pb.PbList<GetTasksRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTasksRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTasksRequest>(create);
  static GetTasksRequest? _defaultInstance;
}

enum GetTasksResponse_Recurring {
  checked, 
  every, 
  notSet
}

class GetTasksResponse extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, GetTasksResponse_Recurring> _GetTasksResponse_RecurringByTag = {
    9 : GetTasksResponse_Recurring.checked,
    10 : GetTasksResponse_Recurring.every,
    0 : GetTasksResponse_Recurring.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetTasksResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..oo(0, [9, 10])
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCompleted')
    ..aOM<$0.Date>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startDate', subBuilder: $0.Date.create)
    ..aOM<$0.Date>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endDate', subBuilder: $0.Date.create)
    ..aOM<User>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'responsible', subBuilder: User.create)
    ..aOM<Group>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'group', subBuilder: Group.create)
    ..aOM<Duration>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'estimate', subBuilder: Duration.create)
    ..aOM<RecurringChecked>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'checked', subBuilder: RecurringChecked.create)
    ..aOM<RecurringEveryResponse>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'every', subBuilder: RecurringEveryResponse.create)
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canUpdate')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canToggle')
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canDelete')
    ..aOB(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isFriendTask')
    ..hasRequiredFields = false
  ;

  GetTasksResponse._() : super();
  factory GetTasksResponse({
    $core.int? id,
    $core.String? title,
    $core.bool? isCompleted,
    $0.Date? startDate,
    $0.Date? endDate,
    User? responsible,
    Group? group,
    Duration? estimate,
    RecurringChecked? checked,
    RecurringEveryResponse? every,
    $core.bool? canUpdate,
    $core.bool? canToggle,
    $core.bool? canDelete,
    $core.bool? isFriendTask,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (isCompleted != null) {
      _result.isCompleted = isCompleted;
    }
    if (startDate != null) {
      _result.startDate = startDate;
    }
    if (endDate != null) {
      _result.endDate = endDate;
    }
    if (responsible != null) {
      _result.responsible = responsible;
    }
    if (group != null) {
      _result.group = group;
    }
    if (estimate != null) {
      _result.estimate = estimate;
    }
    if (checked != null) {
      _result.checked = checked;
    }
    if (every != null) {
      _result.every = every;
    }
    if (canUpdate != null) {
      _result.canUpdate = canUpdate;
    }
    if (canToggle != null) {
      _result.canToggle = canToggle;
    }
    if (canDelete != null) {
      _result.canDelete = canDelete;
    }
    if (isFriendTask != null) {
      _result.isFriendTask = isFriendTask;
    }
    return _result;
  }
  factory GetTasksResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTasksResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTasksResponse clone() => GetTasksResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTasksResponse copyWith(void Function(GetTasksResponse) updates) => super.copyWith((message) => updates(message as GetTasksResponse)) as GetTasksResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetTasksResponse create() => GetTasksResponse._();
  GetTasksResponse createEmptyInstance() => create();
  static $pb.PbList<GetTasksResponse> createRepeated() => $pb.PbList<GetTasksResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTasksResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTasksResponse>(create);
  static GetTasksResponse? _defaultInstance;

  GetTasksResponse_Recurring whichRecurring() => _GetTasksResponse_RecurringByTag[$_whichOneof(0)]!;
  void clearRecurring() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isCompleted => $_getBF(2);
  @$pb.TagNumber(3)
  set isCompleted($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsCompleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsCompleted() => clearField(3);

  @$pb.TagNumber(4)
  $0.Date get startDate => $_getN(3);
  @$pb.TagNumber(4)
  set startDate($0.Date v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStartDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartDate() => clearField(4);
  @$pb.TagNumber(4)
  $0.Date ensureStartDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Date get endDate => $_getN(4);
  @$pb.TagNumber(5)
  set endDate($0.Date v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasEndDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndDate() => clearField(5);
  @$pb.TagNumber(5)
  $0.Date ensureEndDate() => $_ensure(4);

  @$pb.TagNumber(6)
  User get responsible => $_getN(5);
  @$pb.TagNumber(6)
  set responsible(User v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasResponsible() => $_has(5);
  @$pb.TagNumber(6)
  void clearResponsible() => clearField(6);
  @$pb.TagNumber(6)
  User ensureResponsible() => $_ensure(5);

  @$pb.TagNumber(7)
  Group get group => $_getN(6);
  @$pb.TagNumber(7)
  set group(Group v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroup() => clearField(7);
  @$pb.TagNumber(7)
  Group ensureGroup() => $_ensure(6);

  @$pb.TagNumber(8)
  Duration get estimate => $_getN(7);
  @$pb.TagNumber(8)
  set estimate(Duration v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasEstimate() => $_has(7);
  @$pb.TagNumber(8)
  void clearEstimate() => clearField(8);
  @$pb.TagNumber(8)
  Duration ensureEstimate() => $_ensure(7);

  @$pb.TagNumber(9)
  RecurringChecked get checked => $_getN(8);
  @$pb.TagNumber(9)
  set checked(RecurringChecked v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasChecked() => $_has(8);
  @$pb.TagNumber(9)
  void clearChecked() => clearField(9);
  @$pb.TagNumber(9)
  RecurringChecked ensureChecked() => $_ensure(8);

  @$pb.TagNumber(10)
  RecurringEveryResponse get every => $_getN(9);
  @$pb.TagNumber(10)
  set every(RecurringEveryResponse v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEvery() => $_has(9);
  @$pb.TagNumber(10)
  void clearEvery() => clearField(10);
  @$pb.TagNumber(10)
  RecurringEveryResponse ensureEvery() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get canUpdate => $_getBF(10);
  @$pb.TagNumber(11)
  set canUpdate($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCanUpdate() => $_has(10);
  @$pb.TagNumber(11)
  void clearCanUpdate() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get canToggle => $_getBF(11);
  @$pb.TagNumber(12)
  set canToggle($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasCanToggle() => $_has(11);
  @$pb.TagNumber(12)
  void clearCanToggle() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get canDelete => $_getBF(12);
  @$pb.TagNumber(13)
  set canDelete($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasCanDelete() => $_has(12);
  @$pb.TagNumber(13)
  void clearCanDelete() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isFriendTask => $_getBF(13);
  @$pb.TagNumber(14)
  set isFriendTask($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasIsFriendTask() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsFriendTask() => clearField(14);
}

class CreateGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..hasRequiredFields = false
  ;

  CreateGroupRequest._() : super();
  factory CreateGroupRequest({
    $core.String? title,
  }) {
    final _result = create();
    if (title != null) {
      _result.title = title;
    }
    return _result;
  }
  factory CreateGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateGroupRequest clone() => CreateGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateGroupRequest copyWith(void Function(CreateGroupRequest) updates) => super.copyWith((message) => updates(message as CreateGroupRequest)) as CreateGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateGroupRequest create() => CreateGroupRequest._();
  CreateGroupRequest createEmptyInstance() => create();
  static $pb.PbList<CreateGroupRequest> createRepeated() => $pb.PbList<CreateGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateGroupRequest>(create);
  static CreateGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);
}

class CreateGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  CreateGroupResponse._() : super();
  factory CreateGroupResponse({
    $core.int? id,
    $core.String? title,
    $core.String? uid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    return _result;
  }
  factory CreateGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateGroupResponse clone() => CreateGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateGroupResponse copyWith(void Function(CreateGroupResponse) updates) => super.copyWith((message) => updates(message as CreateGroupResponse)) as CreateGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateGroupResponse create() => CreateGroupResponse._();
  CreateGroupResponse createEmptyInstance() => create();
  static $pb.PbList<CreateGroupResponse> createRepeated() => $pb.PbList<CreateGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateGroupResponse>(create);
  static CreateGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => clearField(3);
}

class JoinGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  JoinGroupRequest._() : super();
  factory JoinGroupRequest({
    $core.String? uid,
  }) {
    final _result = create();
    if (uid != null) {
      _result.uid = uid;
    }
    return _result;
  }
  factory JoinGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinGroupRequest clone() => JoinGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinGroupRequest copyWith(void Function(JoinGroupRequest) updates) => super.copyWith((message) => updates(message as JoinGroupRequest)) as JoinGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinGroupRequest create() => JoinGroupRequest._();
  JoinGroupRequest createEmptyInstance() => create();
  static $pb.PbList<JoinGroupRequest> createRepeated() => $pb.PbList<JoinGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinGroupRequest>(create);
  static JoinGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);
}

class JoinGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  JoinGroupResponse._() : super();
  factory JoinGroupResponse({
    $core.int? id,
    $core.String? title,
    $core.String? uid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    return _result;
  }
  factory JoinGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinGroupResponse clone() => JoinGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinGroupResponse copyWith(void Function(JoinGroupResponse) updates) => super.copyWith((message) => updates(message as JoinGroupResponse)) as JoinGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinGroupResponse create() => JoinGroupResponse._();
  JoinGroupResponse createEmptyInstance() => create();
  static $pb.PbList<JoinGroupResponse> createRepeated() => $pb.PbList<JoinGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinGroupResponse>(create);
  static JoinGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => clearField(3);
}

class UpdateGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..hasRequiredFields = false
  ;

  UpdateGroupRequest._() : super();
  factory UpdateGroupRequest({
    $core.int? id,
    $core.String? title,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    return _result;
  }
  factory UpdateGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateGroupRequest clone() => UpdateGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateGroupRequest copyWith(void Function(UpdateGroupRequest) updates) => super.copyWith((message) => updates(message as UpdateGroupRequest)) as UpdateGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateGroupRequest create() => UpdateGroupRequest._();
  UpdateGroupRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateGroupRequest> createRepeated() => $pb.PbList<UpdateGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateGroupRequest>(create);
  static UpdateGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);
}

class UpdateGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  UpdateGroupResponse._() : super();
  factory UpdateGroupResponse({
    $core.int? id,
    $core.String? title,
    $core.String? uid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    return _result;
  }
  factory UpdateGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateGroupResponse clone() => UpdateGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateGroupResponse copyWith(void Function(UpdateGroupResponse) updates) => super.copyWith((message) => updates(message as UpdateGroupResponse)) as UpdateGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateGroupResponse create() => UpdateGroupResponse._();
  UpdateGroupResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateGroupResponse> createRepeated() => $pb.PbList<UpdateGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateGroupResponse>(create);
  static UpdateGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => clearField(3);
}

class LeaveGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LeaveGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  LeaveGroupRequest._() : super();
  factory LeaveGroupRequest({
    $core.int? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory LeaveGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveGroupRequest clone() => LeaveGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveGroupRequest copyWith(void Function(LeaveGroupRequest) updates) => super.copyWith((message) => updates(message as LeaveGroupRequest)) as LeaveGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LeaveGroupRequest create() => LeaveGroupRequest._();
  LeaveGroupRequest createEmptyInstance() => create();
  static $pb.PbList<LeaveGroupRequest> createRepeated() => $pb.PbList<LeaveGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static LeaveGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveGroupRequest>(create);
  static LeaveGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class LeaveGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LeaveGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  LeaveGroupResponse._() : super();
  factory LeaveGroupResponse({
    $core.int? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory LeaveGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveGroupResponse clone() => LeaveGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveGroupResponse copyWith(void Function(LeaveGroupResponse) updates) => super.copyWith((message) => updates(message as LeaveGroupResponse)) as LeaveGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LeaveGroupResponse create() => LeaveGroupResponse._();
  LeaveGroupResponse createEmptyInstance() => create();
  static $pb.PbList<LeaveGroupResponse> createRepeated() => $pb.PbList<LeaveGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static LeaveGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveGroupResponse>(create);
  static LeaveGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class GetGroupsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetGroupsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  GetGroupsRequest._() : super();
  factory GetGroupsRequest() => create();
  factory GetGroupsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetGroupsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetGroupsRequest clone() => GetGroupsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetGroupsRequest copyWith(void Function(GetGroupsRequest) updates) => super.copyWith((message) => updates(message as GetGroupsRequest)) as GetGroupsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetGroupsRequest create() => GetGroupsRequest._();
  GetGroupsRequest createEmptyInstance() => create();
  static $pb.PbList<GetGroupsRequest> createRepeated() => $pb.PbList<GetGroupsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetGroupsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetGroupsRequest>(create);
  static GetGroupsRequest? _defaultInstance;
}

class GetGroupsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetGroupsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  GetGroupsResponse._() : super();
  factory GetGroupsResponse({
    $core.int? id,
    $core.String? title,
    $core.String? uid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    return _result;
  }
  factory GetGroupsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetGroupsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetGroupsResponse clone() => GetGroupsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetGroupsResponse copyWith(void Function(GetGroupsResponse) updates) => super.copyWith((message) => updates(message as GetGroupsResponse)) as GetGroupsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetGroupsResponse create() => GetGroupsResponse._();
  GetGroupsResponse createEmptyInstance() => create();
  static $pb.PbList<GetGroupsResponse> createRepeated() => $pb.PbList<GetGroupsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetGroupsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetGroupsResponse>(create);
  static GetGroupsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => clearField(3);
}

class GetGroupParticipantsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetGroupParticipantsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  GetGroupParticipantsRequest._() : super();
  factory GetGroupParticipantsRequest({
    $core.int? groupId,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
    }
    return _result;
  }
  factory GetGroupParticipantsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetGroupParticipantsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetGroupParticipantsRequest clone() => GetGroupParticipantsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetGroupParticipantsRequest copyWith(void Function(GetGroupParticipantsRequest) updates) => super.copyWith((message) => updates(message as GetGroupParticipantsRequest)) as GetGroupParticipantsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetGroupParticipantsRequest create() => GetGroupParticipantsRequest._();
  GetGroupParticipantsRequest createEmptyInstance() => create();
  static $pb.PbList<GetGroupParticipantsRequest> createRepeated() => $pb.PbList<GetGroupParticipantsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetGroupParticipantsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetGroupParticipantsRequest>(create);
  static GetGroupParticipantsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get groupId => $_getIZ(0);
  @$pb.TagNumber(1)
  set groupId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);
}

class GetGroupParticipantsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetGroupParticipantsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..aOM<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  GetGroupParticipantsResponse._() : super();
  factory GetGroupParticipantsResponse({
    User? user,
  }) {
    final _result = create();
    if (user != null) {
      _result.user = user;
    }
    return _result;
  }
  factory GetGroupParticipantsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetGroupParticipantsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetGroupParticipantsResponse clone() => GetGroupParticipantsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetGroupParticipantsResponse copyWith(void Function(GetGroupParticipantsResponse) updates) => super.copyWith((message) => updates(message as GetGroupParticipantsResponse)) as GetGroupParticipantsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetGroupParticipantsResponse create() => GetGroupParticipantsResponse._();
  GetGroupParticipantsResponse createEmptyInstance() => create();
  static $pb.PbList<GetGroupParticipantsResponse> createRepeated() => $pb.PbList<GetGroupParticipantsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetGroupParticipantsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetGroupParticipantsResponse>(create);
  static GetGroupParticipantsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class User extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'User', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pictureUrl')
    ..hasRequiredFields = false
  ;

  User._() : super();
  factory User({
    $core.int? id,
    $core.String? name,
    $core.String? pictureUrl,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (pictureUrl != null) {
      _result.pictureUrl = pictureUrl;
    }
    return _result;
  }
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get pictureUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set pictureUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPictureUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearPictureUrl() => clearField(3);
}

class Group extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Group', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  Group._() : super();
  factory Group({
    $core.int? id,
    $core.String? title,
    $core.String? uid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    return _result;
  }
  factory Group.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Group.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Group clone() => Group()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Group copyWith(void Function(Group) updates) => super.copyWith((message) => updates(message as Group)) as Group; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Group create() => Group._();
  Group createEmptyInstance() => create();
  static $pb.PbList<Group> createRepeated() => $pb.PbList<Group>();
  @$core.pragma('dart2js:noInline')
  static Group getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Group>(create);
  static Group? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => clearField(3);
}

class Duration extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Duration', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'days', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hours', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minutes', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Duration._() : super();
  factory Duration({
    $core.int? days,
    $core.int? hours,
    $core.int? minutes,
  }) {
    final _result = create();
    if (days != null) {
      _result.days = days;
    }
    if (hours != null) {
      _result.hours = hours;
    }
    if (minutes != null) {
      _result.minutes = minutes;
    }
    return _result;
  }
  factory Duration.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Duration.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Duration clone() => Duration()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Duration copyWith(void Function(Duration) updates) => super.copyWith((message) => updates(message as Duration)) as Duration; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Duration create() => Duration._();
  Duration createEmptyInstance() => create();
  static $pb.PbList<Duration> createRepeated() => $pb.PbList<Duration>();
  @$core.pragma('dart2js:noInline')
  static Duration getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Duration>(create);
  static Duration? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get days => $_getIZ(0);
  @$pb.TagNumber(1)
  set days($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearDays() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get hours => $_getIZ(1);
  @$pb.TagNumber(2)
  set hours($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHours() => $_has(1);
  @$pb.TagNumber(2)
  void clearHours() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get minutes => $_getIZ(2);
  @$pb.TagNumber(3)
  set minutes($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMinutes() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinutes() => clearField(3);
}

class RecurringChecked extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecurringChecked', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'days', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'months', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  RecurringChecked._() : super();
  factory RecurringChecked({
    $core.int? days,
    $core.int? months,
  }) {
    final _result = create();
    if (days != null) {
      _result.days = days;
    }
    if (months != null) {
      _result.months = months;
    }
    return _result;
  }
  factory RecurringChecked.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecurringChecked.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecurringChecked clone() => RecurringChecked()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecurringChecked copyWith(void Function(RecurringChecked) updates) => super.copyWith((message) => updates(message as RecurringChecked)) as RecurringChecked; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecurringChecked create() => RecurringChecked._();
  RecurringChecked createEmptyInstance() => create();
  static $pb.PbList<RecurringChecked> createRepeated() => $pb.PbList<RecurringChecked>();
  @$core.pragma('dart2js:noInline')
  static RecurringChecked getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecurringChecked>(create);
  static RecurringChecked? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get days => $_getIZ(0);
  @$pb.TagNumber(1)
  set days($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearDays() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get months => $_getIZ(1);
  @$pb.TagNumber(2)
  set months($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMonths() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonths() => clearField(2);
}

class RecurringEveryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecurringEveryRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'days', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'months', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  RecurringEveryRequest._() : super();
  factory RecurringEveryRequest({
    $core.int? days,
    $core.int? months,
  }) {
    final _result = create();
    if (days != null) {
      _result.days = days;
    }
    if (months != null) {
      _result.months = months;
    }
    return _result;
  }
  factory RecurringEveryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecurringEveryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecurringEveryRequest clone() => RecurringEveryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecurringEveryRequest copyWith(void Function(RecurringEveryRequest) updates) => super.copyWith((message) => updates(message as RecurringEveryRequest)) as RecurringEveryRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecurringEveryRequest create() => RecurringEveryRequest._();
  RecurringEveryRequest createEmptyInstance() => create();
  static $pb.PbList<RecurringEveryRequest> createRepeated() => $pb.PbList<RecurringEveryRequest>();
  @$core.pragma('dart2js:noInline')
  static RecurringEveryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecurringEveryRequest>(create);
  static RecurringEveryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get days => $_getIZ(0);
  @$pb.TagNumber(1)
  set days($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearDays() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get months => $_getIZ(1);
  @$pb.TagNumber(2)
  set months($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMonths() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonths() => clearField(2);
}

class RecurringEveryResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecurringEveryResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'api.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'days', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'months', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numReadyToStart', $pb.PbFieldType.O3)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numReadyToStartIsLowerBound')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numReachedDeadline', $pb.PbFieldType.O3)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numReachedDeadlineIsLowerBound')
    ..hasRequiredFields = false
  ;

  RecurringEveryResponse._() : super();
  factory RecurringEveryResponse({
    $core.int? days,
    $core.int? months,
    $core.int? numReadyToStart,
    $core.bool? numReadyToStartIsLowerBound,
    $core.int? numReachedDeadline,
    $core.bool? numReachedDeadlineIsLowerBound,
  }) {
    final _result = create();
    if (days != null) {
      _result.days = days;
    }
    if (months != null) {
      _result.months = months;
    }
    if (numReadyToStart != null) {
      _result.numReadyToStart = numReadyToStart;
    }
    if (numReadyToStartIsLowerBound != null) {
      _result.numReadyToStartIsLowerBound = numReadyToStartIsLowerBound;
    }
    if (numReachedDeadline != null) {
      _result.numReachedDeadline = numReachedDeadline;
    }
    if (numReachedDeadlineIsLowerBound != null) {
      _result.numReachedDeadlineIsLowerBound = numReachedDeadlineIsLowerBound;
    }
    return _result;
  }
  factory RecurringEveryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecurringEveryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecurringEveryResponse clone() => RecurringEveryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecurringEveryResponse copyWith(void Function(RecurringEveryResponse) updates) => super.copyWith((message) => updates(message as RecurringEveryResponse)) as RecurringEveryResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecurringEveryResponse create() => RecurringEveryResponse._();
  RecurringEveryResponse createEmptyInstance() => create();
  static $pb.PbList<RecurringEveryResponse> createRepeated() => $pb.PbList<RecurringEveryResponse>();
  @$core.pragma('dart2js:noInline')
  static RecurringEveryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecurringEveryResponse>(create);
  static RecurringEveryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get days => $_getIZ(0);
  @$pb.TagNumber(1)
  set days($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearDays() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get months => $_getIZ(1);
  @$pb.TagNumber(2)
  set months($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMonths() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonths() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get numReadyToStart => $_getIZ(2);
  @$pb.TagNumber(3)
  set numReadyToStart($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNumReadyToStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumReadyToStart() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get numReadyToStartIsLowerBound => $_getBF(3);
  @$pb.TagNumber(4)
  set numReadyToStartIsLowerBound($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNumReadyToStartIsLowerBound() => $_has(3);
  @$pb.TagNumber(4)
  void clearNumReadyToStartIsLowerBound() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get numReachedDeadline => $_getIZ(4);
  @$pb.TagNumber(5)
  set numReachedDeadline($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNumReachedDeadline() => $_has(4);
  @$pb.TagNumber(5)
  void clearNumReachedDeadline() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get numReachedDeadlineIsLowerBound => $_getBF(5);
  @$pb.TagNumber(6)
  set numReachedDeadlineIsLowerBound($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasNumReachedDeadlineIsLowerBound() => $_has(5);
  @$pb.TagNumber(6)
  void clearNumReachedDeadlineIsLowerBound() => clearField(6);
}

class APIApi {
  $pb.RpcClient _client;
  APIApi(this._client);

  $async.Future<LoginResponse> login($pb.ClientContext? ctx, LoginRequest request) {
    var emptyResponse = LoginResponse();
    return _client.invoke<LoginResponse>(ctx, 'API', 'Login', request, emptyResponse);
  }
  $async.Future<CreateTaskResponse> createTask($pb.ClientContext? ctx, CreateTaskRequest request) {
    var emptyResponse = CreateTaskResponse();
    return _client.invoke<CreateTaskResponse>(ctx, 'API', 'CreateTask', request, emptyResponse);
  }
  $async.Future<UpdateTaskResponse> updateTask($pb.ClientContext? ctx, UpdateTaskRequest request) {
    var emptyResponse = UpdateTaskResponse();
    return _client.invoke<UpdateTaskResponse>(ctx, 'API', 'UpdateTask', request, emptyResponse);
  }
  $async.Future<ToggleTaskCompletedResponse> toggleTaskCompleted($pb.ClientContext? ctx, ToggleTaskCompletedRequest request) {
    var emptyResponse = ToggleTaskCompletedResponse();
    return _client.invoke<ToggleTaskCompletedResponse>(ctx, 'API', 'ToggleTaskCompleted', request, emptyResponse);
  }
  $async.Future<DeleteTaskResponse> deleteTask($pb.ClientContext? ctx, DeleteTaskRequest request) {
    var emptyResponse = DeleteTaskResponse();
    return _client.invoke<DeleteTaskResponse>(ctx, 'API', 'DeleteTask', request, emptyResponse);
  }
  $async.Future<GetTasksResponse> getTasks($pb.ClientContext? ctx, GetTasksRequest request) {
    var emptyResponse = GetTasksResponse();
    return _client.invoke<GetTasksResponse>(ctx, 'API', 'GetTasks', request, emptyResponse);
  }
  $async.Future<CreateGroupResponse> createGroup($pb.ClientContext? ctx, CreateGroupRequest request) {
    var emptyResponse = CreateGroupResponse();
    return _client.invoke<CreateGroupResponse>(ctx, 'API', 'CreateGroup', request, emptyResponse);
  }
  $async.Future<JoinGroupResponse> joinGroup($pb.ClientContext? ctx, JoinGroupRequest request) {
    var emptyResponse = JoinGroupResponse();
    return _client.invoke<JoinGroupResponse>(ctx, 'API', 'JoinGroup', request, emptyResponse);
  }
  $async.Future<UpdateGroupResponse> updateGroup($pb.ClientContext? ctx, UpdateGroupRequest request) {
    var emptyResponse = UpdateGroupResponse();
    return _client.invoke<UpdateGroupResponse>(ctx, 'API', 'UpdateGroup', request, emptyResponse);
  }
  $async.Future<LeaveGroupResponse> leaveGroup($pb.ClientContext? ctx, LeaveGroupRequest request) {
    var emptyResponse = LeaveGroupResponse();
    return _client.invoke<LeaveGroupResponse>(ctx, 'API', 'LeaveGroup', request, emptyResponse);
  }
  $async.Future<GetGroupsResponse> getGroups($pb.ClientContext? ctx, GetGroupsRequest request) {
    var emptyResponse = GetGroupsResponse();
    return _client.invoke<GetGroupsResponse>(ctx, 'API', 'GetGroups', request, emptyResponse);
  }
  $async.Future<GetGroupParticipantsResponse> getGroupParticipants($pb.ClientContext? ctx, GetGroupParticipantsRequest request) {
    var emptyResponse = GetGroupParticipantsResponse();
    return _client.invoke<GetGroupParticipantsResponse>(ctx, 'API', 'GetGroupParticipants', request, emptyResponse);
  }
}

