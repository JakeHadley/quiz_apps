import 'package:flutter/material.dart';
import 'package:quiz_core/common_widgets/custom_appbar.dart';
import 'package:quiz_core/home_widgets/game_options.dart';

///
class HomeWrapper extends StatelessWidget {
  ///
  const HomeWrapper({
    required this.title,
    required this.navigateToSingle,
    required this.navigateToMulti,
    required this.navigateToSpeed,
    required this.onNoConnection,
    required this.subtitleText,
    required this.singleText,
    required this.multiText,
    required this.speedText,
    super.key,
  });

  ///
  final String title;

  ///
  final VoidCallback navigateToSingle;

  ///
  final VoidCallback navigateToMulti;

  ///
  final VoidCallback navigateToSpeed;

  ///
  final VoidCallback onNoConnection;

  ///
  final String subtitleText;

  ///
  final String singleText;

  ///
  final String multiText;

  ///
  final String speedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: GameOptions(
        navigateToSingle: navigateToSingle,
        navigateToMulti: navigateToMulti,
        navigateToSpeed: navigateToSpeed,
        onNoConnection: onNoConnection,
        subtitleText: subtitleText,
        singleText: singleText,
        multiText: multiText,
        speedText: speedText,
      ),
    );
  }
}
