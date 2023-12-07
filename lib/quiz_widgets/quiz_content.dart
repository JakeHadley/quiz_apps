import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/blocs.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/quiz_widgets/quiz_widgets.dart';

///
class QuizContent extends StatefulWidget {
  ///
  const QuizContent({
    required this.onNextQuestionPress,
    required this.onAnswerPress,
    required this.onQuizEnded,
    required this.onSubmit,
    required this.advanceMultiPlayerQuestion,
    required this.onPointsChanged,
    required this.submitText,
    required this.finishQuizText,
    required this.nextQuestionText,
    required this.waitingForOwnerText,
    required this.quizSubtitleText,
    required this.quizSubtitleOfText,
    required this.endGameInfoText,
    required this.localeNameText,
    super.key,
  });

  ///
  final void Function({
    required QuizType quizType,
    required Mode questionMode,
    required bool allNotAnswered,
  }) onNextQuestionPress;

  ///
  final void Function({
    required Answer answer,
    required QuizType quizType,
    required Mode questionMode,
  }) onAnswerPress;

  ///
  final void Function({
    required int score,
    required QuizType quizType,
  }) onQuizEnded;

  ///
  final void Function({
    required bool isCorrect,
    required QuizType quizType,
  }) onSubmit;

  ///
  final void Function({required int indexToSet}) advanceMultiPlayerQuestion;

  ///
  final void Function({
    required String code,
    required int score,
  }) onPointsChanged;

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

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  int pointsTracker = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, quizState) {
        if (quizState is QuizComplete) {
          widget.onQuizEnded(
            score: quizState.numberOfPoints,
            quizType: quizState.type,
          );
        }
      },
      builder: (context, quizState) {
        return BlocConsumer<MultiPlayerBloc, MultiPlayerState>(
          listener: (context, multiState) {
            if (multiState is MultiPlayerActive && quizState is QuizLoaded) {
              if (quizState.currentQuestionIndex !=
                  multiState.room.currentQuestionIndex) {
                widget.advanceMultiPlayerQuestion(
                  indexToSet: multiState.room.currentQuestionIndex,
                );
              }
              if (quizState.numberOfPoints != pointsTracker) {
                widget.onPointsChanged(
                  code: multiState.room.code,
                  score: quizState.numberOfPoints,
                );
                setState(() {
                  pointsTracker = quizState.numberOfPoints;
                });
              }
            }
          },
          builder: (context, multiState) {
            final isMulti = multiState is MultiPlayerActive;
            final isMultiOwner =
                isMulti && multiState.name == multiState.room.owner;
            final allNotAnswered = isMulti &&
                multiState.room.usersAnswered.length !=
                    multiState.room.users.length;

            if (quizState is QuizLoaded) {
              final currentQuestion =
                  quizState.questions[quizState.currentQuestionIndex];

              final answers = quizState.answerList
                  .map(
                    (answer) => AnswerButton(
                      answer: answer,
                      currentQuestionAnswered:
                          quizState.currentQuestionAnswered,
                      onPress: widget.onAnswerPress,
                      selectedAnswer: quizState.selectedAnswer,
                      quizType: quizState.type,
                      questionMode: currentQuestion.mode,
                    ),
                  )
                  .toList();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    if (quizState.type == QuizType.speed)
                      TimerInfo(quizState: quizState)
                    else
                      ProgressInfo(
                        quizSubtitleText: widget.quizSubtitleText,
                        quizSubtitleOfText: widget.quizSubtitleOfText,
                        endGameInfoText: widget.endGameInfoText,
                      ),
                    RichText(
                      text: TextSpan(
                        text: currentQuestion.question
                            .replaceAll(r'\n', '\n')
                            .replaceAll(r'\t', '\t'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Spacer(),
                    Column(children: answers),
                    if (quizState.type != QuizType.speed) ...[
                      const SizedBox(height: 20),
                      Reference(
                        reference: currentQuestion.reference,
                        currentQuestionAnswered:
                            quizState.currentQuestionAnswered,
                        localeNameText: widget.localeNameText,
                      ),
                      const SizedBox(height: 10),
                      QuizButton(
                        currentQuestionAnswered:
                            quizState.currentQuestionAnswered,
                        onNextQuestionPress: widget.onNextQuestionPress,
                        selectedAnswer: quizState.selectedAnswer,
                        onSubmit: widget.onSubmit,
                        lastQuestion: quizState.numberOfQuestions -
                                quizState.currentQuestionIndex ==
                            1,
                        quizType: quizState.type,
                        isMulti: isMulti,
                        isMultiOwner: isMultiOwner,
                        questionMode: currentQuestion.mode,
                        allNotAnswered: allNotAnswered,
                        submitText: widget.submitText,
                        finishQuizText: widget.finishQuizText,
                        nextQuestionText: widget.nextQuestionText,
                        waitingForOwnerText: widget.waitingForOwnerText,
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
