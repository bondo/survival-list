import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LongDuration extends Equatable {
  const LongDuration({
    required this.months,
    required this.days,
  });

  final int months;
  final int days;

  LongDuration copyWith({
    int Function()? months,
    int Function()? days,
  }) {
    return LongDuration(
      months: months != null ? months() : this.months,
      days: days != null ? days() : this.days,
    );
  }

  bool get isEmpty => months == 0 && days == 0;

  @override
  List<Object?> get props => [months, days];
}
