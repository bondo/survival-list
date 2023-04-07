import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:survival_list_repository/src/models/user.dart';

@immutable
class Item extends Equatable {
  const Item({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
    required this.responsible,
  });

  final int id;
  final String title;
  final bool isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;
  final User? responsible;

  Item copyWith({
    int Function()? id,
    String Function()? title,
    bool Function()? isCompleted,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    User? Function()? responsible,
  }) {
    return Item(
      id: id != null ? id() : this.id,
      title: title != null ? title() : this.title,
      isCompleted: isCompleted != null ? isCompleted() : this.isCompleted,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      responsible: responsible != null ? responsible() : this.responsible,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, isCompleted, startDate, endDate, responsible];
}
