import 'package:flutter/material.dart';
import 'package:quiz_core/models/score.dart';

///
class Scoresheet extends StatelessWidget {
  ///
  const Scoresheet({
    required this.theme,
    required this.widget,
    required this.scores,
    required this.endGameInfoText,
    super.key,
  });

  ///
  final ThemeData theme;

  ///
  final SizedBox widget;

  ///
  final List<Score> scores;

  ///
  final String endGameInfoText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: theme.primaryColor,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              context: context,
              builder: (BuildContext context) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          endGameInfoText,
                          style: theme.textTheme.headlineMedium?.merge(
                            TextStyle(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: theme.primaryColor,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    if (scores.isEmpty)
                      const SizedBox.shrink()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: scores.length,
                        itemBuilder: (BuildContext context, index) {
                          final score = scores[index];
                          return ListTile(
                            title: Text(score.toString()),
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.scoreboard),
        ),
      ],
    );
  }
}
