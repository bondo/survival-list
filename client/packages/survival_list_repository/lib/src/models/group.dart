import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Group extends Equatable {
  const Group({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  Group copyWith({
    int Function()? id,
    String Function()? title,
  }) {
    return Group(
      id: id != null ? id() : this.id,
      title: title != null ? title() : this.title,
    );
  }

  @override
  List<Object?> get props => [id, title];
}
