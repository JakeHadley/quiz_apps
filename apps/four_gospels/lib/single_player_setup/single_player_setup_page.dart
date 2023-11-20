import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/mode.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/single_widgets/single_widgets.dart';

@RoutePage()
class SinglePlayerSetupPage extends StatelessWidget {
  const SinglePlayerSetupPage({super.key});

  void _onStateChange(BuildContext context) {
    context.router.replaceAll([const QuizRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SinglePlayerSetupWrapper(
      title: l10n.singlePlayerAppBar,
      getModeString: (Mode mode) => getModeString(mode, l10n),
      numQuestionsText: l10n.numQuestions,
      timerText: l10n.timer,
      confirmText: l10n.confirmSettingsDifficulty,
      languageText: l10n.quizLanguage,
      startButtonText: l10n.startButton,
      onStateChange: ({int? timer}) {
        _onStateChange(context);
      },
    );
  }
}
