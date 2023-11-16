import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(15)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerReset>(_onReset);
    on<TimerChanged>(_onTimerChanged);
  }
  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();

    emit(TimerInProgress(event.duration, initialDuration: event.duration));

    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    final prevState = state;
    emit(
      event.duration > 0
          ? TimerInProgress(
              event.duration,
              initialDuration: prevState.initialDuration,
            )
          : const TimerComplete(),
    );
  }

  void _onTimerChanged(TimerChanged event, Emitter<TimerState> emit) {
    final prevState = state as TimerInProgress;
    var newDuration = prevState.duration + event.duration;

    if (newDuration > prevState.initialDuration!) {
      newDuration = prevState.initialDuration!;
    }

    _tickerSubscription?.cancel();

    emit(
      TimerInProgress(newDuration, initialDuration: prevState.initialDuration),
    );

    _tickerSubscription = _ticker
        .tick(ticks: newDuration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(15));
  }
}
