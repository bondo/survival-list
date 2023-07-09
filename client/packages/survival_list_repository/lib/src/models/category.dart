import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Category extends Equatable {
  const Category({
    required this.id,
    required this.rawTitle,
    required this.color,
    required this.isEnabled,
  });

  final int id;
  final String rawTitle;
  final String color;
  final bool isEnabled;

  Category copyWith({
    int Function()? id,
    String Function()? rawTitle,
    String Function()? color,
    bool Function()? isEnabled,
  }) {
    return Category(
      id: id != null ? id() : this.id,
      rawTitle: rawTitle != null ? rawTitle() : this.rawTitle,
      color: color != null ? color() : this.color,
      isEnabled: isEnabled != null ? isEnabled() : this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [id, rawTitle, color, isEnabled];
}
