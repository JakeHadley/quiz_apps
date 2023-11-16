import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/multi_player_setup/bloc/multi_player_bloc.dart';
import 'package:four_gospels/quiz/bloc/quiz_bloc.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:four_gospels/quiz/widgets/scoresheet.dart';

Map<Mode, Widget> gaugeMap = {
  Mode.easy: Image.asset('assets/easy.png'),
  Mode.moderate: Image.asset('assets/moderate.png'),
  Mode.difficult: Image.asset('assets/difficult.png'),
};

// ignore: must_be_immutable
class ProgressInfo extends StatelessWidget {
  ProgressInfo({super.key});

  double prevValue = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, quizState) {
        if (quizState is QuizLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: SizedBox(
                      key: ValueKey<Mode>(
                        quizState
                            .questions[quizState.currentQuestionIndex].mode,
                      ),
                      width: 40,
                      height: 25,
                      child: gaugeMap[quizState
                          .questions[quizState.currentQuestionIndex].mode],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${l10n.quizSubtitleQuestion} '
                    '${quizState.currentQuestionIndex + 1} '
                    '${l10n.quizSubtitleOf} ${quizState.numberOfQuestions}',
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              if (quizState.type == QuizType.multi)
                BlocBuilder<MultiPlayerBloc, MultiPlayerState>(
                  builder: (context, multiState) {
                    if (multiState is MultiPlayerActive) {
                      final newValue = multiState.room.usersAnswered.length /
                          multiState.room.users.length;
                      final widget = SizedBox(
                        height: 40,
                        width: 40,
                        child: Stack(
                          children: [
                            Center(
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: prevValue,
                                  end: newValue,
                                ),
                                duration: const Duration(seconds: 1),
                                builder: (context, value, _) =>
                                    CircularProgressIndicator(
                                  value: value,
                                  color: multiState.room.usersAnswered.length ==
                                          multiState.room.users.length
                                      ? theme.colorScheme.primary
                                      : theme.primaryColorDark,
                                  backgroundColor: theme.primaryColorLight,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${multiState.room.usersAnswered.length}'
                                '/${multiState.room.users.length}',
                              ),
                            ),
                          ],
                        ),
                      );
                      prevValue = newValue;
                      return Scoresheet(
                        l10n: l10n,
                        theme: theme,
                        widget: widget,
                        scores: multiState.room.scores
                          ..sort((a, b) => b.score.compareTo(a.score)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
