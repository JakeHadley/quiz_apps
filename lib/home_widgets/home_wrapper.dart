import 'package:advanced_in_app_review/advanced_in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:quiz_core/common_widgets/custom_appbar.dart';
import 'package:quiz_core/home_widgets/game_options.dart';

///
class HomeWrapper extends StatefulWidget {
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
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    AdvancedInAppReview()
        .setMinDaysBeforeRemind(7)
        .setMinDaysAfterInstall(2)
        .setMinLaunchTimes(2)
        .setMinSecondsBeforeShowDialog(4)
        .monitor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: GameOptions(
        navigateToSingle: widget.navigateToSingle,
        navigateToMulti: widget.navigateToMulti,
        navigateToSpeed: widget.navigateToSpeed,
        onNoConnection: widget.onNoConnection,
        subtitleText: widget.subtitleText,
        singleText: widget.singleText,
        multiText: widget.multiText,
        speedText: widget.speedText,
      ),
    );
  }
}
