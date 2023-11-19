import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/mode.dart';
import 'package:quiz_core/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:quiz_core/blocs/timer_bloc/timer_bloc.dart';
import 'package:quiz_core/common_widgets/custom_appbar.dart';
import 'package:quiz_core/common_widgets/settings.dart';
import 'package:quiz_core/models/models.dart';

@RoutePage()
class SpeedSetupPage extends StatelessWidget {
  const SpeedSetupPage({super.key});

  void _onPress({
    required BuildContext context,
    required Mode mode,
    required String language,
    required int timer,
  }) {
    final quizStartEvent = QuizStart.speed(
      numberOfQuestions: 0,
      mode: mode,
      language: language,
      timer: timer,
    );

    context.read<QuizBloc>().add(quizStartEvent);
  }

  void _onStateChange({
    required BuildContext context,
    required int timer,
  }) {
    context.router.replaceAll([const QuizRoute()]);
    context.read<TimerBloc>().add(TimerStarted(duration: timer));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.speedRound, type: QuizType.speed),
      body: Settings(
        type: QuizType.speed,
        onStateChange: ({int? timer}) {
          _onStateChange(context: context, timer: timer!);
        },
        onPress: ({
          required Mode mode,
          required String language,
          int? questions,
          int? timer,
        }) {
          _onPress(
            context: context,
            mode: mode,
            language: language,
            timer: timer!,
          );
        },
        isCompact: false,
        getModeString: (Mode mode) => getModeString(mode, l10n),
        numQuestionsText: l10n.numQuestions,
        timerText: l10n.timer,
        confirmText: l10n.confirmSettingsDifficulty,
        languageText: l10n.quizLanguage,
        startButtonText: l10n.startButton,
      ),
    );
  }
}
