part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizFinished extends QuizEvent {}

class QuizEnded extends QuizEvent {}

class QuizLoad extends QuizEvent {}

class QuizStart extends QuizEvent {
  const QuizStart.single({
    required this.numberOfQuestions,
    required this.mode,
    required this.language,
    this.type = QuizType.single,
    this.questions,
    this.timer,
  });

  const QuizStart.speed({
    required this.numberOfQuestions,
    required this.mode,
    required this.language,
    this.type = QuizType.speed,
    this.questions,
    this.timer,
  });

  const QuizStart.multi({
    required this.numberOfQuestions,
    required this.mode,
    required this.language,
    this.type = QuizType.multi,
    this.questions,
    this.timer,
  });

  final int numberOfQuestions;
  final Mode mode;
  final QuizType type;
  final List<Question>? questions;
  final String language;
  final int? timer;

  @override
  List<Object?> get props => [
        numberOfQuestions,
        mode,
        type,
        questions,
        language,
        timer,
      ];
}

class QuizNextQuestion extends QuizEvent {
  const QuizNextQuestion({
    required this.questionMode,
    this.indexToSet,
  });

  final Mode questionMode;
  final int? indexToSet;

  @override
  List<Object?> get props => [questionMode, indexToSet];
}

class QuizAnswerSubmitted extends QuizEvent {
  const QuizAnswerSubmitted({
    required this.isCorrect,
  });

  final bool isCorrect;

  @override
  List<Object?> get props => [isCorrect];
}

class QuizAnswerSelected extends QuizEvent {
  const QuizAnswerSelected({
    required this.answer,
  });

  final Answer answer;

  @override
  List<Object?> get props => [answer];
}
