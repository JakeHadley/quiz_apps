part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  const TimerState(this.duration, {this.initialDuration});
  final int duration;
  final int? initialDuration;

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);
}

class TimerInProgress extends TimerState {
  const TimerInProgress(super.duration, {super.initialDuration});
}

class TimerComplete extends TimerState {
  const TimerComplete() : super(0);
}
