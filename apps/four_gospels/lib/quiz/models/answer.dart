class Answer {
  const Answer({
    required this.isCorrect,
    required this.key,
    required this.text,
  });

  const Answer.empty({
    this.isCorrect = false,
    this.text = '',
    this.key = '',
  });

  bool isEmpty() => key == '';
  bool isNotEmpty() => key != '';

  final bool isCorrect;
  final String key;
  final String text;
}
