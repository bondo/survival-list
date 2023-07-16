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
    required this.category,
    required this.subcategory,
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
    this.categories = const [],
    this.categoriesStatus = EditItemStatus.initial,
    this.groups = const [],
    this.groupsStatus = EditItemStatus.initial,
    this.groupParticipants = const [],
    this.groupParticipantsStatus = EditItemStatus.initial,
    this.viewerPerson,
  });

  final EditItemStatus status;
  final Category? category;
  final Subcategory? subcategory;
  final List<(Category, List<Subcategory>)> categories;
  final EditItemStatus categoriesStatus;
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
    Category? Function()? category,
    Subcategory? Function()? subcategory,
    List<(Category, List<Subcategory>)> Function()? categories,
    EditItemStatus Function()? categoriesStatus,
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
      category: category != null ? category() : this.category,
      subcategory: subcategory != null ? subcategory() : this.subcategory,
      categories: categories != null ? categories() : this.categories,
      categoriesStatus:
          categoriesStatus != null ? categoriesStatus() : this.categoriesStatus,
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
        category,
        subcategory,
        categories,
        categoriesStatus,
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
