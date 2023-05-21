import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class SimpleDuration extends Equatable {
  const SimpleDuration({
    required this.days,
    required this.hours,
    required this.minutes,
  });

  final int days;
  final int hours;
  final int minutes;

  SimpleDuration copyWith({
    int Function()? days,
    int Function()? hours,
    int Function()? minutes,
  }) {
    return SimpleDuration(
      days: days != null ? days() : this.days,
      hours: hours != null ? hours() : this.hours,
      minutes: minutes != null ? minutes() : this.minutes,
    );
  }

  bool get isEmpty => days == 0 && hours == 0 && minutes == 0;

  @override
  List<Object?> get props => [days, hours, minutes];
}
