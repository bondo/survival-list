import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

enum RecurrenceKind { none, every, checked }

@immutable
class Recurrence extends Equatable {
  const Recurrence({
    required this.kind,
    required this.frequency,
  });

  final RecurrenceKind kind;
  final LongDuration frequency;

  Recurrence copyWith({
    RecurrenceKind Function()? kind,
    LongDuration Function()? frequency,
  }) {
    return Recurrence(
      kind: kind != null ? kind() : this.kind,
      frequency: frequency != null ? frequency() : this.frequency,
    );
  }

  @override
  List<Object?> get props => [kind, frequency];
}
