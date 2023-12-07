import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:quiz_core/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:quiz_core/common_widgets/action_button.dart';
import 'package:quiz_core/models/models.dart';

///
class SettingsContent extends StatelessWidget {
  ///
  const SettingsContent({
    required this.type,
    required this.onStateChange,
    required this.chips,
    required this.onChangeQuestions,
    required this.questions,
    required this.initialLanguage,
    required this.onChangeLanguage,
    required this.timer,
    required this.onChangeTimer,
    required this.isCompact,
    required this.numQuestionsText,
    required this.timerText,
    required this.confirmText,
    required this.languageText,
    required this.startButtonText,
    this.onPress,
    super.key,
  });

  ///
  final QuizType type;

  ///
  final void Function({int? timer}) onStateChange;

  ///
  final List<Widget> chips;

  ///
  final void Function(int value) onChangeQuestions;

  ///
  final int questions;

  ///
  final int initialLanguage;

  ///
  final void Function(int, CarouselPageChangedReason) onChangeLanguage;

  ///
  final int timer;

  ///
  final void Function(int value) onChangeTimer;

  ///
  final bool isCompact;

  ///
  final String numQuestionsText;

  ///
  final String timerText;

  ///
  final String confirmText;

  ///
  final String languageText;

  ///
  final String startButtonText;

  ///
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizLoaded) {
          if (state.type == QuizType.speed) {
            onStateChange(timer: state.timer);
          } else {
            onStateChange();
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              if (type == QuizType.single || type == QuizType.multi) ...[
                Text(
                  numQuestionsText,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontSize: isCompact == true ? 18 : 25),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          final newQuestions = questions - 5;
                          onChangeQuestions(newQuestions.clamp(10, 50));
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      NumberPicker(
                        axis: Axis.horizontal,
                        value: questions,
                        minValue: 10,
                        maxValue: 50,
                        onChanged: onChangeQuestions,
                        itemWidth: 60,
                        step: 5,
                      ),
                      IconButton(
                        onPressed: () {
                          final newQuestions = questions + 5;
                          onChangeQuestions(newQuestions.clamp(10, 50));
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: isCompact == true ? 10 : 30,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                  color: theme.disabledColor,
                ),
              ] else if (type == QuizType.speed) ...[
                Text(
                  timerText,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        final newTimer = timer - 15;
                        onChangeTimer(newTimer.clamp(15, 60));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    NumberPicker(
                      axis: Axis.horizontal,
                      value: timer,
                      minValue: 15,
                      maxValue: 60,
                      onChanged: onChangeTimer,
                      itemWidth: 60,
                      step: 15,
                    ),
                    IconButton(
                      onPressed: () {
                        final newTimer = timer + 15;
                        onChangeTimer(newTimer.clamp(15, 60));
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 30,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                  color: theme.disabledColor,
                ),
              ],
              Text(
                confirmText,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontSize: isCompact == true ? 18 : 25),
              ),
              SizedBox(height: isCompact == true ? 0 : 10),
              Wrap(
                alignment: WrapAlignment.center,
                children: chips,
              ),
              Divider(
                height: isCompact == true ? 10 : 30,
                thickness: 1,
                indent: 40,
                endIndent: 40,
                color: theme.disabledColor,
              ),
              Text(
                languageText,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontSize: isCompact == true ? 18 : 25),
              ),
              const SizedBox(height: 10),
              CarouselSlider(
                items: flags,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: isCompact == true ? 0.25 : 0.3,
                  height: isCompact == true ? 50 : 60,
                  initialPage: initialLanguage,
                  onPageChanged: onChangeLanguage,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.5,
                ),
              ),
              if (type != QuizType.multi) ...[
                const Spacer(),
                ActionButton(
                  onPress: onPress == null ? () {} : onPress!,
                  isLoading: state is QuizLoading,
                  color: theme.colorScheme.primaryContainer,
                  text: startButtonText,
                ),
              ],
              SizedBox(height: isCompact == true ? 0 : 30),
            ],
          ),
        );
      },
    );
  }
}
