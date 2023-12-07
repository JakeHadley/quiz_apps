/// Model for an [Answer] object
class Answer {
  /// Creates an [Answer] object
  const Answer({
    required this.isCorrect,
    required this.key,
    required this.text,
  });

  /// Empty [Answer] object, used instead of null checks
  const Answer.empty({
    this.isCorrect = false,
    this.text = '',
    this.key = '',
  });

  /// checks if key is empty
  bool isEmpty() => key == '';

  /// checks if key is populated
  bool isNotEmpty() => key != '';

  /// Determines if answer is correct
  final bool isCorrect;

  /// Unique key
  final String key;

  /// Answer text
  final String text;
}
