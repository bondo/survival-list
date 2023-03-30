import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Item extends Equatable {
  const Item({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String title;
  final bool isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;

  Item copyWith({
    int Function()? id,
    String Function()? title,
    bool Function()? isCompleted,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
  }) {
    return Item(
      id: id != null ? id() : this.id,
      title: title != null ? title() : this.title,
      isCompleted: isCompleted != null ? isCompleted() : this.isCompleted,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, startDate, endDate];
}
