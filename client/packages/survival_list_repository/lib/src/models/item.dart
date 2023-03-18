import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Item extends Equatable {
  const Item({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final bool isCompleted;

  Item copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}
