import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_core/blocs/blocs.dart';
import 'package:quiz_core/common_widgets/common_widgets.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/quiz_widgets/quiz_widgets.dart';
import 'package:screenshot/screenshot.dart';

///
class QuizWrapper extends StatefulWidget {
  ///
  const QuizWrapper({
    required this.getTypeString,
    required this.getModeString,
    required this.captionText,
    required this.quitText,
    required this.cancelText,
    required this.feedbackPromptText,
    required this.continueText,
    required this.deviceInfoText,
    required this.feedbackText,
    required this.nextQuestionPromptText,
    required this.submitText,
    required this.finishQuizText,
    required this.nextQuestionText,
    required this.waitingForOwnerText,
    required this.quizSubtitleText,
    required this.quizSubtitleOfText,
    required this.endGameInfoText,
    required this.localeNameText,
    required this.exitAction,
    required this.navigateToEndGame,
    super.key,
  });

  ///
  final String Function(QuizType) getTypeString;

  ///
  final String Function(Mode mode) getModeString;

  ///
  final String captionText;

  ///
  final String quitText;

  ///
  final String cancelText;

  ///
  final String feedbackPromptText;

  ///
  final String continueText;

  ///
  final String deviceInfoText;

  ///
  final String feedbackText;

  ///
  final String nextQuestionPromptText;

  ///
  final String submitText;

  ///
  final String finishQuizText;

  ///
  final String nextQuestionText;

  ///
  final String waitingForOwnerText;

  ///
  final String quizSubtitleText;

  ///
  final String quizSubtitleOfText;

  ///
  final String endGameInfoText;

  ///
  final String localeNameText;

  ///
  final VoidCallback exitAction;

  ///
  final void Function(QuizType) navigateToEndGame;

  @override
  State<QuizWrapper> createState() => _QuizWrapperState();
}

class _QuizWrapperState extends State<QuizWrapper> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => BackButtonDialog(
            exitAction: widget.exitAction,
            captionText: widget.captionText,
            quitText: widget.quitText,
            cancelText: widget.cancelText,
          ),
        ) ??
        false;
  }

  void _showFeedbackDialog(String info) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Text(widget.feedbackPromptText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.cancelText),
          ),
          ElevatedButton(
            onPressed: () => feedbackAction(info),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(widget.continueText),
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
    final email = Email(
      body: '${widget.deviceInfoText}: $deviceInfo\n\n${widget.feedbackText}: ',
      subject: '${widget.feedbackText} ($info)',
      recipients: ['exigentdev@gmail.com'],
      attachmentPaths: [screenshotPath],
    );

    await FlutterEmailSender.send(email);
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

  void _showNextQuestionDialog({
    required Mode questionMode,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Text(widget.nextQuestionPromptText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<QuizBloc>()
                  .add(QuizNextQuestion(questionMode: questionMode));
              context.read<MultiPlayerBloc>().add(MultiPlayerNextQuestion());
              Navigator.of(context).pop();
            },
            child: Text(widget.continueText),
          ),
        ],
      ),
    );
  }

  void _onAnswerPress({
    required Answer answer,
    required QuizType quizType,
    required Mode questionMode,
  }) {
    switch (quizType) {
      case QuizType.single:
        context.read<QuizBloc>().add(QuizAnswerSelected(answer: answer));
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
            if (!mounted) return;
            context
                .read<QuizBloc>()
                .add(QuizNextQuestion(questionMode: questionMode));
          });
        }
      case QuizType.multi:
        context.read<QuizBloc>().add(QuizAnswerSelected(answer: answer));
    }
  }

  void _onQuizEnded({
    required int score,
    required QuizType quizType,
  }) {
    widget.navigateToEndGame(quizType);

    if (quizType == QuizType.multi) {
      context.read<MultiPlayerBloc>().add(MultiPlayerComplete(score: score));
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

  void _onPointsChanged({required String code, required int score}) {
    context.read<MultiPlayerBloc>().add(
          MultiPlayerUpdatePoints(
            code: code,
            score: score,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizLoaded) {
              return Scaffold(
                appBar: CustomAppBar(
                  title: widget.getTypeString(state.type),
                  backButton: QuizBackButton(
                    exitAction: widget.exitAction,
                    captionText: widget.captionText,
                    quitText: widget.quitText,
                    cancelText: widget.cancelText,
                  ),
                  feedbackAction: () => _showFeedbackDialog(
                    '${widget.getTypeString(state.type)}, '
                    '${widget.getModeString(state.mode)}, '
                    'id: ${state.questions[state.currentQuestionIndex].id}',
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
                  submitText: widget.submitText,
                  finishQuizText: widget.finishQuizText,
                  nextQuestionText: widget.nextQuestionText,
                  waitingForOwnerText: widget.waitingForOwnerText,
                  quizSubtitleText: widget.quizSubtitleText,
                  quizSubtitleOfText: widget.quizSubtitleOfText,
                  endGameInfoText: widget.endGameInfoText,
                  localeNameText: widget.localeNameText,
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
