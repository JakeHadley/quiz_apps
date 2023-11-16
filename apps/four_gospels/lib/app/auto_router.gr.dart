// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'auto_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    EndGameRoute.name: (routeData) {
      final args = routeData.argsAs<EndGameRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EndGamePage(
          quizType: args.quizType,
          key: args.key,
        ),
      );
    },
    QuizRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const QuizPage(),
      );
    },
    SpeedSetupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SpeedSetupPage(),
      );
    },
    MultiPlayerSetupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MultiPlayerSetupPage(),
      );
    },
    LobbyRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LobbyPage(),
      );
    },
    SinglePlayerSetupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SinglePlayerSetupPage(),
      );
    },
  };
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EndGamePage]
class EndGameRoute extends PageRouteInfo<EndGameRouteArgs> {
  EndGameRoute({
    required QuizType quizType,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          EndGameRoute.name,
          args: EndGameRouteArgs(
            quizType: quizType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EndGameRoute';

  static const PageInfo<EndGameRouteArgs> page =
      PageInfo<EndGameRouteArgs>(name);
}

class EndGameRouteArgs {
  const EndGameRouteArgs({
    required this.quizType,
    this.key,
  });

  final QuizType quizType;

  final Key? key;

  @override
  String toString() {
    return 'EndGameRouteArgs{quizType: $quizType, key: $key}';
  }
}

/// generated route for
/// [QuizPage]
class QuizRoute extends PageRouteInfo<void> {
  const QuizRoute({List<PageRouteInfo>? children})
      : super(
          QuizRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SpeedSetupPage]
class SpeedSetupRoute extends PageRouteInfo<void> {
  const SpeedSetupRoute({List<PageRouteInfo>? children})
      : super(
          SpeedSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SpeedSetupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MultiPlayerSetupPage]
class MultiPlayerSetupRoute extends PageRouteInfo<void> {
  const MultiPlayerSetupRoute({List<PageRouteInfo>? children})
      : super(
          MultiPlayerSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'MultiPlayerSetupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LobbyPage]
class LobbyRoute extends PageRouteInfo<void> {
  const LobbyRoute({List<PageRouteInfo>? children})
      : super(
          LobbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'LobbyRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SinglePlayerSetupPage]
class SinglePlayerSetupRoute extends PageRouteInfo<void> {
  const SinglePlayerSetupRoute({List<PageRouteInfo>? children})
      : super(
          SinglePlayerSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SinglePlayerSetupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
