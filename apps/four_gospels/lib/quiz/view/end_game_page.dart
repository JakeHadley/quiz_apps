import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/quiz_type.dart';
import 'package:quiz_core/models/quiz_type.dart';
import 'package:quiz_core/quiz_widgets/end_game_wrapper.dart';

@RoutePage()
class EndGamePage extends StatelessWidget {
  const EndGamePage({required this.quizType, super.key});

  final QuizType quizType;

  void navigateToHome(BuildContext context) {
    context.router.replaceAll([const HomeRoute()]);
  }

  void navigateToLobby(BuildContext context) {
    context.router.replaceAll([const HomeRoute(), const LobbyRoute()]);
  }

  void navigateToQuiz(BuildContext context) {
    context.router.replaceAll([const QuizRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return EndGameWrapper(
      quizType: quizType,
      getTypeString: (QuizType type) => getTypeString(type, l10n),
      navigateToHome: () => navigateToHome(context),
      navigateToLobby: () => navigateToLobby(context),
      navigateToQuiz: () => navigateToQuiz(context),
      endGameInfoText: l10n.endGameInfoScore,
      endGamePageCorrectAnswersText: l10n.endGamePageCorrectAnswers,
      endGamePageSubtitleText: l10n.endGamePageSubtitle,
      endGameButtonText: l10n.endGameButton,
      playAgainButtonText: l10n.playAgainButton,
    );
  }
}
