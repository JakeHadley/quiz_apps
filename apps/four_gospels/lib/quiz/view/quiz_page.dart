import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/multi_player_setup/multi_player_setup.dart';
import 'package:four_gospels/quiz/bloc/quiz_bloc.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:four_gospels/quiz/widgets/back_button_dialog.dart';
import 'package:four_gospels/quiz/widgets/widgets.dart';
import 'package:four_gospels/timer/bloc/timer_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

@RoutePage()
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  void _onAnswerPress({
    required Answer answer,
    required QuizType quizType,
    required Mode questionMode,
  }) {
    switch (quizType) {
      case QuizType.single:
        context.read<QuizBloc>().add(QuizAnswerSelected(answer: answer));
        break;
      case QuizType.speed:
        context.read<QuizBloc>().add(QuizAnswerSelected(answer: answer));
        context
            .read<QuizBloc>()
            .add(QuizAnswerSubmitted(isCorrect: answer.isCorrect));

        if (answer.isCorrect) {
          context.read<TimerBloc>().add(const TimerChanged(duration: 5));
        } else {
          context.read<TimerBloc>().add(const TimerChanged(duration: -1));
        }

        if (mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            context
                .read<QuizBloc>()
                .add(QuizNextQuestion(questionMode: questionMode));
          });
        }
        break;
      case QuizType.multi:
        context.read<QuizBloc>().add(QuizAnswerSelected(answer: answer));
        break;
    }
  }

  void _onSubmit({
    required bool isCorrect,
    required QuizType quizType,
  }) {
    context.read<QuizBloc>().add(QuizAnswerSubmitted(isCorrect: isCorrect));

    if (quizType == QuizType.multi) {
      context.read<MultiPlayerBloc>().add(MultiPlayerSubmitAnswer());
    }
  }

  void _advanceMultiPlayerQuestion({required int indexToSet}) {
    context.read<QuizBloc>().add(
          QuizNextQuestion(
            indexToSet: indexToSet,
            questionMode: Mode.easy,
          ),
        );
  }

  void _showNextQuestionDialog({
    required Mode questionMode,
  }) {
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Text(l10n.nextQuestionPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.quitDialogCancel),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<QuizBloc>()
                  .add(QuizNextQuestion(questionMode: questionMode));
              context.read<MultiPlayerBloc>().add(MultiPlayerNextQuestion());
              Navigator.of(context).pop();
            },
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
  }

  void _onNextQuestionPress({
    required QuizType quizType,
    required Mode questionMode,
    required bool allNotAnswered,
  }) {
    if (quizType == QuizType.multi) {
      if (allNotAnswered == true) {
        _showNextQuestionDialog(questionMode: questionMode);
      } else {
        context
            .read<QuizBloc>()
            .add(QuizNextQuestion(questionMode: questionMode));
        context.read<MultiPlayerBloc>().add(MultiPlayerNextQuestion());
      }
    } else {
      context
          .read<QuizBloc>()
          .add(QuizNextQuestion(questionMode: questionMode));
    }
  }

  void _onQuizEnded({
    required int score,
    required QuizType quizType,
  }) {
    context.router.replaceAll([EndGameRoute(quizType: quizType)]);

    if (quizType == QuizType.multi) {
      context.read<MultiPlayerBloc>().add(MultiPlayerComplete(score: score));
    }
  }

  void _exitAction() {
    context.read<QuizBloc>().add(QuizFinished());
    context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    context.read<TimerBloc>().add(TimerReset());
    context.router.replaceAll([const HomeRoute()]);
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => BackButtonDialog(
            exitAction: _exitAction,
          ),
        ) ??
        false;
  }

  void _onPointsChanged({required String code, required int score}) {
    context.read<MultiPlayerBloc>().add(
          MultiPlayerUpdatePoints(
            code: code,
            score: score,
          ),
        );
  }

  Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return 'Device: ${androidInfo.model}, '
          'OS-A: ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return 'Device: ${iosInfo.utsname.machine}, '
          'OS-I: ${iosInfo.systemVersion}';
    }
    return 'Unknown device';
  }

  Future<String> captureScreenshot() async {
    final screenshot = await screenshotController.capture();
    if (screenshot == null) {
      throw Exception('Screenshot error');
    }

    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final directory = appDocsDirectory.path;
    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final fullPath = '$directory/$fileName.png';
    final imageFile = File(fullPath);
    await imageFile.writeAsBytes(screenshot);
    return fullPath;
  }

  Future<void> sendFeedbackEmail(
    String deviceInfo,
    String screenshotPath,
    String info,
  ) async {
    final l10n = context.l10n;

    final email = Email(
      body: '${l10n.deviceInfo}: $deviceInfo\n\n${l10n.feedback}: ',
      subject: '${l10n.feedback} ($info)',
      recipients: ['exigentdev@gmail.com'],
      attachmentPaths: [screenshotPath],
    );

    await FlutterEmailSender.send(email);
  }

  void showFeedbackDialog(String info, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Text(l10n.feedbackPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.quitDialogCancel),
          ),
          ElevatedButton(
            onPressed: () => feedbackAction(info),
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
  }

  Future<void> feedbackAction(String info) async {
    final deviceInfo = await getDeviceInfo();
    final screenshotPath = await captureScreenshot();
    await sendFeedbackEmail(deviceInfo, screenshotPath, info);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Screenshot(
      controller: screenshotController,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizLoaded) {
              return Scaffold(
                appBar: CustomAppBar(
                  title: state.type.toStringIntl(l10n),
                  backButton: QuizBackButton(exitAction: _exitAction),
                  feedbackAction: () => showFeedbackDialog(
                    '${state.type.toStringIntl(l10n)}, '
                    '${state.mode.toStringIntl(l10n)}, '
                    'id: ${state.questions[state.currentQuestionIndex].id}',
                    l10n,
                  ),
                  type: state.type,
                ),
                body: QuizContent(
                  onNextQuestionPress: _onNextQuestionPress,
                  onAnswerPress: _onAnswerPress,
                  onQuizEnded: _onQuizEnded,
                  onSubmit: _onSubmit,
                  advanceMultiPlayerQuestion: _advanceMultiPlayerQuestion,
                  onPointsChanged: _onPointsChanged,
                ),
              );
            }
            return const Scaffold();
          },
        ),
      ),
    );
  }
}
