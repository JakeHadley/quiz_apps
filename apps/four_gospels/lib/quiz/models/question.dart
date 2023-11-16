import 'package:equatable/equatable.dart';
import 'package:four_gospels/quiz/models/mode.dart';

class Question extends Equatable {
  const Question({
    required this.id,
    required this.mode,
    required this.question,
    required this.correctAnswer,
    required this.wrongAnswer1,
    required this.wrongAnswer2,
    required this.wrongAnswer3,
    required this.reference,
  });

  Question.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as int,
          mode: Mode.fromJson(json['mode']! as String),
          question: json['question']! as String,
          correctAnswer: json['correctAnswer']! as String,
          wrongAnswer1: json['wrongAnswer1']! as String,
          wrongAnswer2: json['wrongAnswer2']! as String,
          wrongAnswer3: json['wrongAnswer3']! as String,
          reference: json['reference']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'mode': mode.toJson(),
      'question': question,
      'correctAnswer': correctAnswer,
      'wrongAnswer1': wrongAnswer1,
      'wrongAnswer2': wrongAnswer2,
      'wrongAnswer3': wrongAnswer3,
      'reference': reference,
    };
  }

  final int id;
  final Mode mode;
  final String question;
  final String correctAnswer;
  final String wrongAnswer1;
  final String wrongAnswer2;
  final String wrongAnswer3;
  final String reference;

  @override
  List<Object?> get props => [];
}
