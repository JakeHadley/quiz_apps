import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:four_gospels/models/score.dart';
import 'package:four_gospels/quiz/models/models.dart';

class Room {
  const Room({
    required this.users,
    required this.code,
    required this.lastInteraction,
    required this.owner,
    required this.numberOfQuestions,
    required this.mode,
    required this.questions,
    required this.language,
    required this.status,
    required this.usersAnswered,
    required this.currentQuestionIndex,
    required this.scores,
  });

  Room.fromJson(Map<String, Object?> json)
      : this(
          users: convertUsersToListOfStrings(
            json['users']! as Iterable<dynamic>,
          ),
          code: json['code']! as String,
          lastInteraction: (json['lastInteraction']! as Timestamp).toDate(),
          owner: json['owner']! as String,
          numberOfQuestions: json['numberOfQuestions']! as int,
          mode: Mode.fromJson(json['mode']! as String),
          questions: convertQuestionstoListOfQuestions(
            json['questions']! as Iterable<dynamic>,
          ),
          language: json['language']! as String,
          status: json['status']! as String,
          usersAnswered: convertUsersToListOfStrings(
            json['usersAnswered']! as Iterable<dynamic>,
          ),
          currentQuestionIndex: json['currentQuestionIndex']! as int,
          scores: convertScoresToListOfScores(
            json['scores']! as Iterable<dynamic>,
          ),
        );

  Map<String, Object?> toJson() {
    return {
      'users': users,
      'code': code,
      'lastInteraction': lastInteraction,
      'owner': owner,
      'numberOfQuestions': numberOfQuestions,
      'mode': mode.toJson(),
      'questions': questions.map((question) => question.toJson()).toList(),
      'language': language,
      'status': status,
      'usersAnswered': usersAnswered,
      'currentQuestionIndex': currentQuestionIndex,
      'scores': scores.map((score) => score.toJson()).toList(),
    };
  }

  static List<String> convertUsersToListOfStrings(Iterable<dynamic> users) {
    return List<String>.from(users.map((c) => c));
  }

  static List<Question> convertQuestionstoListOfQuestions(
    Iterable<dynamic> questions,
  ) {
    final questionMap = questions
        .map((question) => Question.fromJson(question as Map<String, dynamic>));
    return List<Question>.from(questionMap);
  }

  static List<Score> convertScoresToListOfScores(
    Iterable<dynamic> scores,
  ) {
    final scoresMap =
        scores.map((score) => Score.fromJson(score as Map<String, dynamic>));
    return List<Score>.from(scoresMap);
  }

  final List<String> users;
  final String code;
  final DateTime lastInteraction;
  final String owner;
  final int numberOfQuestions;
  final Mode mode;
  final List<Question> questions;
  final String language;
  final String status;
  final List<String> usersAnswered;
  final int currentQuestionIndex;
  final List<Score> scores;

  Room copyWith({
    List<String>? users,
    String? code,
    DateTime? lastInteraction,
    String? owner,
    int? numberOfQuestions,
    Mode? mode,
    List<Question>? questions,
    String? language,
    String? status,
    List<String>? usersAnswered,
    int? currentQuestionIndex,
    List<Score>? scores,
  }) {
    return Room(
      users: users ?? this.users,
      code: code ?? this.code,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      owner: owner ?? this.owner,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      mode: mode ?? this.mode,
      questions: questions ?? this.questions,
      language: language ?? this.language,
      status: status ?? this.status,
      usersAnswered: usersAnswered ?? this.usersAnswered,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      scores: scores ?? this.scores,
    );
  }
}

enum RoomExceptionErrorEnum {
  name,
  room,
}

class RoomException implements Exception {
  RoomException(this.error);

  final RoomExceptionErrorEnum error;
}
