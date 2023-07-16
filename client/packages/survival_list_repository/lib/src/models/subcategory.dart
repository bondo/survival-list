import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Subcategory extends Equatable {
  const Subcategory({
    required this.id,
    required this.title,
    required this.color,
  });

  final int id;
  final String title;
  final String color;

  Subcategory copyWith({
    int Function()? id,
    String Function()? title,
    String Function()? color,
  }) {
    return Subcategory(
      id: id != null ? id() : this.id,
      title: title != null ? title() : this.title,
      color: color != null ? color() : this.color,
    );
  }

  @override
  List<Object?> get props => [id, title, color];
}
