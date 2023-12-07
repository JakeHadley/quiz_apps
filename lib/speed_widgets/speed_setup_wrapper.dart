import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:quiz_core/common_widgets/common_widgets.dart';
import 'package:quiz_core/models/models.dart';

///
class SpeedSetupWrapper extends StatelessWidget {
  ///
  const SpeedSetupWrapper({
    required this.title,
    required this.getModeString,
    required this.numQuestionsText,
    required this.timerText,
    required this.confirmText,
    required this.languageText,
    required this.startButtonText,
    required this.onStateChange,
    super.key,
  });

  ///
  final String title;

  ///
  final String Function(Mode mode) getModeString;

  ///
  final String numQuestionsText;

  ///
  final String timerText;

  ///
  final String confirmText;

  ///
  final String languageText;

  ///
  final String startButtonText;

  ///
  final void Function({int? timer}) onStateChange;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title, type: QuizType.speed),
      body: Settings(
        type: QuizType.speed,
        onStateChange: onStateChange,
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
        getModeString: getModeString,
        numQuestionsText: numQuestionsText,
        timerText: timerText,
        confirmText: confirmText,
        languageText: languageText,
        startButtonText: startButtonText,
      ),
    );
  }
}
