import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/blocs.dart';
import 'package:quiz_core/common_widgets/action_button.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/quiz_widgets/info_box.dart';

///
class EndGameContent extends StatelessWidget {
  ///
  const EndGameContent({
    required this.onExit,
    required this.onPlayAgain,
    required this.onSinglePlayAgain,
    required this.onStateChange,
    required this.endGameInfoText,
    required this.endGamePageCorrectAnswersText,
    required this.endGamePageSubtitleText,
    required this.endGameButtonText,
    required this.playAgainButtonText,
    required this.modeText,
    required this.getModeString,
    super.key,
  });

  ///
  final VoidCallback onExit;

  ///
  final VoidCallback onPlayAgain;

  ///
  final void Function(QuizStart prevEvent) onSinglePlayAgain;

  ///
  final void Function(QuizType type, int timer) onStateChange;

  ///
  final String endGameInfoText;

  ///
  final String endGamePageCorrectAnswersText;

  ///
  final String endGamePageSubtitleText;

  ///
  final String endGameButtonText;

  ///
  final String playAgainButtonText;

  ///
  final String modeText;

  ///
  final String Function(Mode mode) getModeString;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget singleContent(QuizComplete state) {
      final text1 = state.type != QuizType.speed
          ? '$endGameInfoText: ${state.numberOfPoints}/${state.possiblePoints}'
          : '$endGameInfoText: ${state.numberOfPoints}';
      final text2 = state.type == QuizType.single
          ? '$endGamePageCorrectAnswersText: '
              '${state.numberCorrect}/${state.numberOfQuestions}'
          : '$endGamePageCorrectAnswersText: '
              '${state.numberCorrect}';
      final text3 = '$modeText: ${getModeString(state.mode)}';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  endGamePageSubtitleText,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 54),
            InfoBox(text1: text1, text2: text2, text3: text3),
            const Spacer(),
            ActionButton(
              onPress: onExit,
              isLoading: false,
              text: endGameButtonText,
            ),
            const SizedBox(height: 20),
            ActionButton(
              onPress: () => onSinglePlayAgain(state.prevEvent),
              isLoading: false,
              text: playAgainButtonText,
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
                  endGamePageSubtitleText,
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
              text: endGameButtonText,
            ),
            const SizedBox(height: 20),
            ActionButton(
              onPress: onPlayAgain,
              isLoading: false,
              text: playAgainButtonText,
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
