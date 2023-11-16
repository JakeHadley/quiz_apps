import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/app/quiz_theme.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/multi_player_setup/multi_player_setup.dart';
import 'package:four_gospels/quiz/quiz.dart';
import 'package:four_gospels/services/services.dart';
import 'package:four_gospels/timer/timer.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    logEvent();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuizService>(
          create: (context) => QuizService(),
          lazy: false,
        ),
        RepositoryProvider<MultiPlayerService>(
          create: (context) => MultiPlayerService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => QuizBloc(
              quizService: RepositoryProvider.of<QuizService>(context),
            ),
          ),
          BlocProvider(
            create: (BuildContext context) => TimerBloc(ticker: const Ticker()),
          ),
          BlocProvider(
            create: (BuildContext context) => MultiPlayerBloc(
              multiPlayerService:
                  RepositoryProvider.of<MultiPlayerService>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: _appRouter.config(),
          theme: QuizTheme().theme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  Future<void> logEvent() async {
    final analytics = FirebaseAnalytics.instance;
    await analytics.logEvent(name: 'opened_app');
  }
}
