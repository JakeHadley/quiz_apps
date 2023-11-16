part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerReset extends TimerEvent {}

class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

class TimerChanged extends TimerEvent {
  const TimerChanged({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
