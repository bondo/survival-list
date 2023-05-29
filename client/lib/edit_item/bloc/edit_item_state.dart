part of 'edit_item_bloc.dart';

enum EditItemStatus { initial, loading, success, failure }

extension EditItemStatusX on EditItemStatus {
  bool get isLoadingOrSuccess => [
        EditItemStatus.loading,
        EditItemStatus.success,
      ].contains(this);
}

class EditItemState extends Equatable {
  const EditItemState({
    required this.group,
    required this.item,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.estimate,
    required this.recurrenceKind,
    required this.recurrenceFrequency,
    required this.responsible,
    this.status = EditItemStatus.initial,
    this.groups = const [],
    this.groupsStatus = EditItemStatus.initial,
    this.groupParticipants = const [],
    this.groupParticipantsStatus = EditItemStatus.initial,
    this.viewerPerson,
  });

  final EditItemStatus status;
  final Group? group;
  final List<Group> groups;
  final EditItemStatus groupsStatus;
  final Person? responsible;
  final List<Person> groupParticipants;
  final EditItemStatus groupParticipantsStatus;
  final Item item;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final ShortDuration estimate;
  final RecurrenceKind recurrenceKind;
  final LongDuration recurrenceFrequency;
  final Person? viewerPerson;

  EditItemState copyWith({
    EditItemStatus Function()? status,
    Group? Function()? group,
    List<Group> Function()? groups,
    EditItemStatus Function()? groupsStatus,
    Person? Function()? responsible,
    List<Person> Function()? groupParticipants,
    EditItemStatus Function()? groupParticipantsStatus,
    Item Function()? item,
    String Function()? title,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    ShortDuration Function()? estimate,
    RecurrenceKind Function()? recurrenceKind,
    LongDuration Function()? recurrenceFrequency,
    Person? Function()? viewerPerson,
  }) {
    return EditItemState(
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
      item: item != null ? item() : this.item,
      title: title != null ? title() : this.title,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      estimate: estimate != null ? estimate() : this.estimate,
      recurrenceKind:
          recurrenceKind != null ? recurrenceKind() : this.recurrenceKind,
      recurrenceFrequency: recurrenceFrequency != null
          ? recurrenceFrequency()
          : this.recurrenceFrequency,
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
        item,
        title,
        startDate,
        endDate,
        estimate,
        recurrenceKind,
        recurrenceFrequency,
        viewerPerson,
      ];
}
