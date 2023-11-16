import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/quiz.dart';

@RoutePage()
class SinglePlayerSetupPage extends StatelessWidget {
  const SinglePlayerSetupPage({super.key});

  void _onStateChange(BuildContext context) {
    context.router.replaceAll([const QuizRoute()]);
  }

  void _onPress({
    required BuildContext context,
    required Mode mode,
    required String language,
    required int questions,
  }) {
    final quizStartEvent = QuizStart.single(
      numberOfQuestions: questions,
      mode: mode,
      language: language,
    );

    context.read<QuizBloc>().add(quizStartEvent);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.singlePlayerAppBar),
      body: Settings(
        type: QuizType.single,
        onStateChange: ({int? timer}) {
          _onStateChange(context);
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
            questions: questions!,
          );
        },
        isCompact: false,
      ),
    );
  }
}
