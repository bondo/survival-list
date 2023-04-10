import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Person extends Equatable {
  const Person({
    required this.id,
    required this.name,
    required this.pictureUrl,
  });

  final int id;
  final String name;
  final String? pictureUrl;

  Person copyWith({
    int Function()? id,
    String Function()? name,
    String? Function()? pictureUrl,
  }) {
    return Person(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      pictureUrl: pictureUrl != null ? pictureUrl() : this.pictureUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, pictureUrl];
}
