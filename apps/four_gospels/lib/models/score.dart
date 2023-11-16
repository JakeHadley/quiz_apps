class Score {
  Score({
    required this.name,
    required this.score,
  });

  Score.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          score: json['score']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'score': score,
    };
  }

  @override
  String toString() {
    return '$name: $score';
  }

  final String name;
  final int score;
}
