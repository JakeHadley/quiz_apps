import 'package:four_gospels/quiz/models/mode.dart';

class Stat {
  const Stat({required this.count, required this.ids});

  Stat.fromJson(Map<String, dynamic> json)
      : this(
          count: json['count'] as int,
          ids: List<String>.from(json['ids'] as List),
        );

  final int count;
  final List<String> ids;
}

class Stats {
  const Stats({
    required this.easy,
    required this.moderate,
    required this.difficult,
    required this.random,
  });

  Stats.fromJson(Map<String, dynamic> json)
      : this(
          easy: Stat.fromJson(json['easy'] as Map<String, dynamic>),
          moderate: Stat.fromJson(json['moderate'] as Map<String, dynamic>),
          difficult: Stat.fromJson(json['difficult'] as Map<String, dynamic>),
          random: Stat.fromJson(json['random'] as Map<String, dynamic>),
        );

  final Stat easy;
  final Stat moderate;
  final Stat difficult;
  final Stat random;

  Stat operator [](Mode mode) {
    switch (mode) {
      case Mode.easy:
        return easy;
      case Mode.moderate:
        return moderate;
      case Mode.difficult:
        return difficult;
      case Mode.random:
        return random;
    }
  }
}
