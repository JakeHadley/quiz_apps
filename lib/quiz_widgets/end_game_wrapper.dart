import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/blocs.dart';
import 'package:quiz_core/common_widgets/custom_appbar.dart';
import 'package:quiz_core/models/quiz_type.dart';
import 'package:quiz_core/quiz_widgets/end_game_content.dart';

///
class EndGameWrapper extends StatelessWidget {
  ///
  const EndGameWrapper({
    required this.quizType,
    required this.getTypeString,
    required this.navigateToHome,
    required this.navigateToLobby,
    required this.navigateToQuiz,
    required this.endGameInfoText,
    required this.endGamePageCorrectAnswersText,
    required this.endGamePageSubtitleText,
    required this.endGameButtonText,
    required this.playAgainButtonText,
    super.key,
  });

  ///
  final QuizType quizType;

  ///
  final String Function(QuizType) getTypeString;

  ///
  final VoidCallback navigateToHome;

  ///
  final VoidCallback navigateToLobby;

  ///
  final VoidCallback navigateToQuiz;

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

  @override
  Widget build(BuildContext context) {
    void onExit(BuildContext context) {
      navigateToHome();
      context.read<QuizBloc>().add(QuizFinished());
      context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    }

    void onPlayAgain(BuildContext context) {
      navigateToLobby();
      context.read<QuizBloc>().add(QuizFinished());
      context.read<MultiPlayerBloc>().add(MultiPlayerRestart());
    }

    void onSinglePlayAgain(BuildContext context, QuizStart prevEvent) {
      context.read<QuizBloc>().add(prevEvent);
    }

    void onStateChange(BuildContext context, QuizType type, int timer) {
      navigateToQuiz();
      if (type == QuizType.speed) {
        context.read<TimerBloc>().add(TimerStarted(duration: timer));
      }
    }

    return Scaffold(
      appBar: CustomAppBar(title: getTypeString(quizType)),
      body: EndGameContent(
        onExit: () => onExit(context),
        onPlayAgain: () => onPlayAgain(context),
        onSinglePlayAgain: (QuizStart prevEvent) =>
            onSinglePlayAgain(context, prevEvent),
        onStateChange: (QuizType type, int timer) =>
            onStateChange(context, type, timer),
        endGameInfoText: endGameInfoText,
        endGamePageCorrectAnswersText: endGamePageCorrectAnswersText,
        endGamePageSubtitleText: endGamePageSubtitleText,
        endGameButtonText: endGameButtonText,
        playAgainButtonText: playAgainButtonText,
      ),
    );
  }
}
