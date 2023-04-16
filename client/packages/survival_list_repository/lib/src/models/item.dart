import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

@immutable
class Item extends Equatable {
  const Item({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
    required this.responsible,
    required this.group,
  });

  final int id;
  final String title;
  final bool isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;
  final Person responsible;
  final Group? group;

  Item copyWith({
    int Function()? id,
    String Function()? title,
    bool Function()? isCompleted,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    Person Function()? responsible,
    Group? Function()? group,
  }) {
    return Item(
      id: id != null ? id() : this.id,
      title: title != null ? title() : this.title,
      isCompleted: isCompleted != null ? isCompleted() : this.isCompleted,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      responsible: responsible != null ? responsible() : this.responsible,
      group: group != null ? group() : this.group,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, isCompleted, startDate, endDate, responsible, group];
}
