import 'package:four_gospels/quiz/models/models.dart';

int getPoints(Mode questionMode, QuizType type) {
  if (type == QuizType.speed) {
    return 5;
  } else if (questionMode == Mode.easy) {
    return 2;
  } else if (questionMode == Mode.moderate) {
    return 4;
  } else if (questionMode == Mode.difficult) {
    return 6;
  } else {
    return 0;
  }
}
