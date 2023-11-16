import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizTheme {
  final Color accent1Dark = const Color(0xff266B6B);
  final Color accent1Light = const Color(0xff99C7C7);
  final Color accent2Dark = const Color(0xff2B78B2);
  final Color accent2Light = const Color(0xff9CCFF6);
  final Color bg = const Color(0xffE0E0DF);
  final Color blackIcon = const Color(0xff030303);
  final Color errorDefault = const Color(0xffD00000);
  final Color grayDefault = const Color(0xff979797);
  final Color primaryDark = const Color(0xff0F3953);
  final Color primaryDarker = const Color(0xff0A2637);
  final Color primaryDefault = const Color(0xff144C6E);
  final Color primaryLight = const Color(0xff89A6B7);
  final Color primaryLightest = const Color(0xffFFFFFF);
  final Color successDark = const Color(0xff205519);
  final Color successDefault = const Color(0xff2A7221);
  final Color whiteIcon = const Color(0xffFFFFFF);

  ThemeData get theme => ThemeData(
        // useMaterial3: true,
        primaryColor: primaryDefault,
        primaryColorDark: primaryDark,
        primaryColorLight: primaryLight,
        scaffoldBackgroundColor: bg,
        iconTheme: IconThemeData(color: whiteIcon),
        primaryIconTheme: IconThemeData(color: blackIcon),
        cardColor: primaryLightest,
        dividerColor: primaryDarker,
        disabledColor: grayDefault,

        colorScheme: ColorScheme(
          primary: successDefault,
          primaryContainer: successDark,
          secondary: accent1Dark,
          secondaryContainer: accent1Light,
          tertiary: accent2Dark,
          tertiaryContainer: accent2Light,
          error: errorDefault,
          //
          onPrimary: Colors.white,
          onSecondary: const Color(0xff413D3D),
          brightness: Brightness.light,
          onError: const Color(0xffC8C8C8),
          background: const Color(0xffE0E0DF),
          onBackground: const Color(0xff616161),
          surface: Colors.white,
          onSurface: const Color(0xff616161),
        ),
        appBarTheme: AppBarTheme(
          color: primaryDefault,
          titleTextStyle: GoogleFonts.getFont('KoHo').merge(
            TextStyle(
              fontSize: 34,
              color: primaryLightest,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
        ),
        textTheme: GoogleFonts.getTextTheme(
          'KoHo',
          TextTheme(
            //subtitle
            titleMedium: const TextStyle(
              fontSize: 22,
              color: Color(0xff585858),
              fontWeight: FontWeight.bold,
            ),
            //question subtitle
            titleSmall: const TextStyle(
              fontSize: 22,
              color: Color(0xff2E2E2E),
            ),
            //start button
            displayLarge: TextStyle(
              fontSize: 64,
              color: primaryLightest,
              fontWeight: FontWeight.w600,
            ),
            //num questions labels
            displayMedium: TextStyle(
              fontSize: 58,
              color: primaryDefault,
              fontWeight: FontWeight.w700,
            ),
            //option labels, submit
            headlineMedium: TextStyle(
              fontSize: 30,
              color: primaryLightest,
              fontWeight: FontWeight.w600,
            ),
            //question
            headlineSmall: TextStyle(
              fontSize: 24,
              color: blackIcon,
              fontWeight: FontWeight.bold,
            ),
            //answers
            bodyLarge: TextStyle(
              fontSize: 20,
              color: blackIcon,
              fontWeight: FontWeight.w500,
            ),
            //reference
            bodySmall: TextStyle(
              color: Colors.blue[700],
              decoration: TextDecoration.underline,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}
