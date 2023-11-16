part of 'quiz_bloc.dart';

@immutable
abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  const QuizLoaded({
    required this.numberOfQuestions,
    required this.questions,
    required this.mode,
    required this.type,
    required this.prevEvent,
    this.numberOfPoints = 0,
    this.numberCorrect = 0,
    this.currentQuestionIndex = 0,
    this.currentQuestionAnswered = false,
    this.isCorrect = false,
    this.answerList = const [],
    this.selectedAnswer = const Answer.empty(),
    this.timer = 15,
  });

  QuizLoaded copyWith({
    int? numberOfQuestions,
    List<Question>? questions,
    Mode? mode,
    QuizType? type,
    QuizStart? prevEvent,
    int? numberOfPoints,
    int? numberCorrect,
    int? currentQuestionIndex,
    bool? currentQuestionAnswered,
    bool? isCorrect,
    List<Answer>? answerList,
    Answer? selectedAnswer,
    int? timer,
  }) {
    return QuizLoaded(
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      questions: questions ?? this.questions,
      mode: mode ?? this.mode,
      type: type ?? this.type,
      prevEvent: prevEvent ?? this.prevEvent,
      numberOfPoints: numberOfPoints ?? this.numberOfPoints,
      numberCorrect: numberCorrect ?? this.numberCorrect,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentQuestionAnswered:
          currentQuestionAnswered ?? this.currentQuestionAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      answerList: answerList ?? this.answerList,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      timer: timer ?? this.timer,
    );
  }

  final int numberOfQuestions;
  final List<Question> questions;
  final Mode mode;
  final QuizType type;
  final QuizStart prevEvent;
  final int numberOfPoints;
  final int numberCorrect;
  final int currentQuestionIndex;
  final bool currentQuestionAnswered;
  final bool isCorrect;
  final List<Answer> answerList;
  final Answer selectedAnswer;
  final int timer;

  @override
  List<Object?> get props => [
        numberOfQuestions,
        questions,
        mode,
        type,
        prevEvent,
        numberOfPoints,
        numberCorrect,
        currentQuestionIndex,
        currentQuestionAnswered,
        isCorrect,
        answerList,
        selectedAnswer,
        timer,
      ];
}

class QuizComplete extends QuizState {
  const QuizComplete({
    required this.numberOfQuestions,
    required this.numberCorrect,
    required this.numberOfPoints,
    required this.type,
    required this.prevEvent,
  });

  final int numberOfPoints;
  final int numberOfQuestions;
  final int numberCorrect;
  final QuizType type;
  final QuizStart prevEvent;
}
