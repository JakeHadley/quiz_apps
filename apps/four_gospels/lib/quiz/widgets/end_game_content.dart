import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/multi_player_setup/bloc/multi_player_bloc.dart';
import 'package:four_gospels/quiz/bloc/quiz_bloc.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:four_gospels/quiz/widgets/widgets.dart';

class EndGameContent extends StatelessWidget {
  const EndGameContent({
    required this.onExit,
    required this.onPlayAgain,
    required this.onSinglePlayAgain,
    required this.onStateChange,
    super.key,
  });

  final VoidCallback onExit;
  final VoidCallback onPlayAgain;
  final void Function(QuizStart prevEvent) onSinglePlayAgain;
  final void Function(QuizType type, int timer) onStateChange;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget singleContent(QuizComplete state) {
      final text1 = '${l10n.endGameInfoScore}: ${state.numberOfPoints}';
      final text2 = state.type == QuizType.single
          ? '${l10n.endGamePageCorrectAnswers}: '
              '${state.numberCorrect}/${state.numberOfQuestions}'
          : '${l10n.endGamePageCorrectAnswers}: '
              '${state.numberCorrect}';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.endGamePageSubtitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 54),
            InfoBox(text1: text1, text2: text2),
            const Spacer(),
            ActionButton(
              onPress: onExit,
              isLoading: false,
              text: l10n.endGameButton,
            ),
            const SizedBox(height: 20),
            ActionButton(
              onPress: () => onSinglePlayAgain(state.prevEvent),
              isLoading: false,
              text: l10n.playAgainButton,
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    Widget multiContent(MultiPlayerActive state) {
      final scores = state.room.scores
        ..sort((a, b) => b.score.compareTo(a.score));

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.endGamePageSubtitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    final text =
                        Text('${scores[index].name}: ${scores[index].score}');

                    return ListTile(title: text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ActionButton(
              onPress: onExit,
              isLoading: false,
              text: l10n.endGameButton,
            ),
            const SizedBox(height: 20),
            ActionButton(
              onPress: onPlayAgain,
              isLoading: false,
              text: l10n.playAgainButton,
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    return BlocBuilder<MultiPlayerBloc, MultiPlayerState>(
      buildWhen: (prevState, state) {
        if (state is MultiPlayerInitial || state is MultiPlayerRoomDeleted) {
          return false;
        } else {
          return true;
        }
      },
      builder: (context, multiState) {
        return BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizLoaded) {
              onStateChange(state.type, state.timer);
            }
          },
          builder: (context, quizState) {
            if (quizState is QuizComplete) {
              if (multiState is MultiPlayerActive) {
                return multiContent(multiState);
              } else {
                return singleContent(quizState);
              }
            }
            return const Text('Error end game content');
          },
        );
      },
    );
  }
}
