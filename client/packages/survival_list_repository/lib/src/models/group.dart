import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Group extends Equatable {
  const Group({
    required this.id,
    required this.uid,
    required this.title,
  });

  final int id;
  final String uid;
  final String title;

  Group copyWith({
    int Function()? id,
    String Function()? uid,
    String Function()? title,
  }) {
    return Group(
      id: id != null ? id() : this.id,
      uid: uid != null ? uid() : this.uid,
      title: title != null ? title() : this.title,
    );
  }

  @override
  List<Object?> get props => [id, uid, title];
}
