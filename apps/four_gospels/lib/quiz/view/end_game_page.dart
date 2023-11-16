import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/multi_player_setup/multi_player_setup.dart';
import 'package:four_gospels/quiz/bloc/quiz_bloc.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:four_gospels/quiz/widgets/widgets.dart';
import 'package:four_gospels/timer/timer.dart';

@RoutePage()
class EndGamePage extends StatelessWidget {
  const EndGamePage({required this.quizType, super.key});

  final QuizType quizType;

  void onExit(BuildContext context) {
    context.router.replaceAll([const HomeRoute()]);
    context.read<QuizBloc>().add(QuizFinished());
    context.read<MultiPlayerBloc>().add(MultiPlayerReset());
  }

  void onPlayAgain(BuildContext context) {
    context.router.replaceAll([const HomeRoute(), const LobbyRoute()]);
    context.read<QuizBloc>().add(QuizFinished());
    context.read<MultiPlayerBloc>().add(MultiPlayerRestart());
  }

  void onSinglePlayAgain(BuildContext context, QuizStart prevEvent) {
    context.read<QuizBloc>().add(prevEvent);
  }

  void onStateChange(BuildContext context, QuizType type, int timer) {
    context.router.replaceAll([const QuizRoute()]);
    if (type == QuizType.speed) {
      context.read<TimerBloc>().add(TimerStarted(duration: timer));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: quizType.toStringIntl(l10n)),
      body: EndGameContent(
        onExit: () => onExit(context),
        onPlayAgain: () => onPlayAgain(context),
        onSinglePlayAgain: (QuizStart prevEvent) =>
            onSinglePlayAgain(context, prevEvent),
        onStateChange: (QuizType type, int timer) =>
            onStateChange(context, type, timer),
      ),
    );
  }
}
