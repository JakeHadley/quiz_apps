import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:four_gospels/quiz/helpers/points_helper.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:four_gospels/services/services.dart';
import 'package:meta/meta.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({required this.quizService}) : super(QuizInitial()) {
    on<QuizStart>(_onQuizStart);
    on<QuizNextQuestion>(_onQuizNextQuestion);
    on<QuizAnswerSubmitted>(_onQuizAnswerSubmitted);
    on<QuizAnswerSelected>(_onQuizAnswerSelected);
    on<QuizFinished>(_onQuizFinished);
    on<QuizEnded>(_onQuizEnded);
    on<QuizLoad>(_onQuizLoad);
  }

  final QuizService quizService;

  Future<void> _onQuizStart(QuizStart event, Emitter<QuizState> emit) async {
    emit(QuizLoading());

    var questions = List<Question>.empty();

    if (event.type != QuizType.multi) {
      questions = await quizService.getQuestions(
        event.numberOfQuestions,
        event.mode,
        event.type,
        event.language,
      );
    } else {
      questions = event.questions!;
    }

    emit(
      QuizLoaded(
        numberOfQuestions: event.numberOfQuestions,
        questions: questions,
        mode: event.mode,
        answerList: _buildAnswerList(questions[0]),
        type: event.type,
        timer: event.timer ?? 15,
        prevEvent: event,
      ),
    );
  }

  void _onQuizNextQuestion(QuizNextQuestion event, Emitter<QuizState> emit) {
    final prevState = state as QuizLoaded;
    final numberOfPoints = prevState.isCorrect
        ? prevState.numberOfPoints +
            getPoints(event.questionMode, prevState.type)
        : prevState.numberOfPoints - 1;
    final numberCorrect = prevState.isCorrect
        ? prevState.numberCorrect + 1
        : prevState.numberCorrect;

    var nextQuestionIndex = prevState.currentQuestionIndex + 1;
    if (event.indexToSet != null) {
      nextQuestionIndex = event.indexToSet!;
    }

    if (nextQuestionIndex == prevState.numberOfQuestions) {
      emit(
        QuizComplete(
          numberOfPoints: numberOfPoints,
          numberOfQuestions: prevState.numberOfQuestions,
          numberCorrect: numberCorrect,
          type: prevState.type,
          prevEvent: prevState.prevEvent,
        ),
      );
    } else {
      emit(
        prevState.copyWith(
          numberOfPoints: numberOfPoints,
          numberCorrect: numberCorrect,
          currentQuestionIndex: nextQuestionIndex,
          currentQuestionAnswered: false,
          selectedAnswer: const Answer.empty(),
          isCorrect: false,
          answerList: _buildAnswerList(prevState.questions[nextQuestionIndex]),
        ),
      );
    }
  }

  void _onQuizAnswerSubmitted(
    QuizAnswerSubmitted event,
    Emitter<QuizState> emit,
  ) {
    final prevState = state as QuizLoaded;

    emit(
      prevState.copyWith(
        currentQuestionAnswered: true,
        isCorrect: event.isCorrect,
      ),
    );
  }

  void _onQuizAnswerSelected(
    QuizAnswerSelected event,
    Emitter<QuizState> emit,
  ) {
    final prevState = state as QuizLoaded;

    emit(
      prevState.copyWith(
        selectedAnswer: event.answer,
      ),
    );
  }

  void _onQuizFinished(QuizFinished event, Emitter<QuizState> emit) {
    emit(QuizInitial());
  }

  void _onQuizEnded(QuizEnded event, Emitter<QuizState> emit) {
    final prevState = state as QuizLoaded;

    emit(
      QuizComplete(
        numberOfQuestions: prevState.numberOfQuestions,
        numberCorrect: prevState.numberCorrect,
        numberOfPoints: prevState.numberOfPoints,
        type: prevState.type,
        prevEvent: prevState.prevEvent,
      ),
    );
  }

  void _onQuizLoad(QuizLoad event, Emitter<QuizState> emit) {
    emit(QuizLoading());
  }

  List<Answer> _buildAnswerList(Question question) => List<Answer>.from([
        Answer(isCorrect: true, key: 'A', text: question.correctAnswer),
        Answer(isCorrect: false, key: 'B', text: question.wrongAnswer1),
        Answer(isCorrect: false, key: 'C', text: question.wrongAnswer2),
        Answer(isCorrect: false, key: 'D', text: question.wrongAnswer3),
      ])
        ..shuffle();
}
