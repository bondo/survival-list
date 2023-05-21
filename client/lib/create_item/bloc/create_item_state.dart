part of 'create_item_bloc.dart';

enum CreateItemStatus { initial, loading, success, failure }

extension CreateItemStatusX on CreateItemStatus {
  bool get isLoadingOrSuccess => [
        CreateItemStatus.loading,
        CreateItemStatus.success,
      ].contains(this);
}

class CreateItemState extends Equatable {
  const CreateItemState({
    this.status = CreateItemStatus.initial,
    this.group,
    this.groups = const [],
    this.groupsStatus = CreateItemStatus.initial,
    this.responsible,
    this.groupParticipants = const [],
    this.groupParticipantsStatus = CreateItemStatus.initial,
    this.title = '',
    this.startDate,
    this.endDate,
    this.estimate,
    this.viewerPerson,
  });

  final CreateItemStatus status;
  final Group? group;
  final List<Group> groups;
  final CreateItemStatus groupsStatus;
  final Person? responsible;
  final List<Person> groupParticipants;
  final CreateItemStatus groupParticipantsStatus;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final Duration? estimate;
  final Person? viewerPerson;

  CreateItemState copyWith({
    CreateItemStatus Function()? status,
    Group? Function()? group,
    List<Group> Function()? groups,
    CreateItemStatus Function()? groupsStatus,
    Person? Function()? responsible,
    List<Person> Function()? groupParticipants,
    CreateItemStatus Function()? groupParticipantsStatus,
    String Function()? title,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    Duration? Function()? estimate,
    Person? Function()? viewerPerson,
  }) {
    return CreateItemState(
      status: status != null ? status() : this.status,
      group: group != null ? group() : this.group,
      groups: groups != null ? groups() : this.groups,
      groupsStatus: groupsStatus != null ? groupsStatus() : this.groupsStatus,
      responsible: responsible != null ? responsible() : this.responsible,
      groupParticipants: groupParticipants != null
          ? groupParticipants()
          : this.groupParticipants,
      groupParticipantsStatus: groupParticipantsStatus != null
          ? groupParticipantsStatus()
          : this.groupParticipantsStatus,
      title: title != null ? title() : this.title,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      estimate: estimate != null ? estimate() : this.estimate,
      viewerPerson: viewerPerson != null ? viewerPerson() : this.viewerPerson,
    );
  }

  @override
  List<Object?> get props => [
        status,
        group,
        groups,
        groupsStatus,
        responsible,
        groupParticipants,
        groupParticipantsStatus,
        title,
        startDate,
        endDate,
        estimate,
        viewerPerson,
      ];
}
