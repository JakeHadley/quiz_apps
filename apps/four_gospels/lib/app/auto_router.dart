import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/home/home.dart';
import 'package:four_gospels/multi_player_setup/multi_player_setup.dart';
import 'package:four_gospels/quiz/quiz.dart';
import 'package:four_gospels/single_player_setup/single_player_setup.dart';
import 'package:four_gospels/speed_setup/speed_setup.dart';
import 'package:quiz_core/models/quiz_type.dart';

part 'auto_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: SinglePlayerSetupRoute.page),
        AutoRoute(page: QuizRoute.page),
        AutoRoute(page: EndGameRoute.page),
        AutoRoute(page: SpeedSetupRoute.page),
        AutoRoute(page: MultiPlayerSetupRoute.page),
        AutoRoute(page: LobbyRoute.page),
      ];
}
