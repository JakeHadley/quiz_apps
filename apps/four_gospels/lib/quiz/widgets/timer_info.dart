import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:quiz_core/blocs/timer_bloc/timer_bloc.dart';

class TimerInfo extends StatelessWidget {
  const TimerInfo({
    required this.quizState,
    super.key,
  });

  final QuizState quizState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerComplete) {
          context.read<QuizBloc>().add(QuizEnded());
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            LinearProgressIndicator(
              value: state.duration.toDouble() / state.initialDuration!,
              minHeight: 20,
              color: state.duration < 5
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
            Align(
              child: Text(state.duration.toString()),
            ),
          ],
        );
      },
    );
  }
}
