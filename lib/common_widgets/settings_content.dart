import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:quiz_core/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:quiz_core/common_widgets/action_button.dart';
import 'package:quiz_core/models/models.dart';

///
class SettingsContent extends StatefulWidget {
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
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizLoaded) {
          if (state.type == QuizType.speed) {
            widget.onStateChange(timer: state.timer);
          } else {
            widget.onStateChange();
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              if (widget.type == QuizType.single ||
                  widget.type == QuizType.multi) ...[
                Text(
                  widget.numQuestionsText,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontSize: widget.isCompact == true ? 18 : 25),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          final newQuestions = widget.questions - 5;
                          widget.onChangeQuestions(newQuestions.clamp(10, 50));
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      NumberPicker(
                        axis: Axis.horizontal,
                        value: widget.questions,
                        minValue: 10,
                        maxValue: 50,
                        onChanged: widget.onChangeQuestions,
                        itemWidth: 60,
                        step: 5,
                      ),
                      IconButton(
                        onPressed: () {
                          final newQuestions = widget.questions + 5;
                          widget.onChangeQuestions(newQuestions.clamp(10, 50));
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
                  height: widget.isCompact == true ? 10 : 30,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                  color: theme.disabledColor,
                ),
              ] else if (widget.type == QuizType.speed) ...[
                Text(
                  widget.timerText,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          final newTimer = widget.timer - 15;
                          widget.onChangeTimer(newTimer.clamp(15, 60));
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      NumberPicker(
                        axis: Axis.horizontal,
                        value: widget.timer,
                        minValue: 15,
                        maxValue: 60,
                        onChanged: widget.onChangeTimer,
                        itemWidth: 60,
                        step: 15,
                      ),
                      IconButton(
                        onPressed: () {
                          final newTimer = widget.timer + 15;
                          widget.onChangeTimer(newTimer.clamp(15, 60));
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
                  height: 30,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                  color: theme.disabledColor,
                ),
              ],
              Text(
                widget.confirmText,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontSize: widget.isCompact == true ? 18 : 25),
              ),
              SizedBox(height: widget.isCompact == true ? 0 : 10),
              Wrap(children: widget.chips),
              Divider(
                height: widget.isCompact == true ? 10 : 30,
                thickness: 1,
                indent: 40,
                endIndent: 40,
                color: theme.disabledColor,
              ),
              Text(
                widget.languageText,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontSize: widget.isCompact == true ? 18 : 25),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _controller.previousPage,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    Flexible(
                      child: CarouselSlider(
                        items: flags,
                        carouselController: _controller,
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          viewportFraction:
                              widget.isCompact == true ? 0.25 : 0.3,
                          height: widget.isCompact == true ? 50 : 60,
                          initialPage: widget.initialLanguage,
                          onPageChanged: widget.onChangeLanguage,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _controller.nextPage,
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.type != QuizType.multi) ...[
                const Spacer(),
                ActionButton(
                  onPress: widget.onPress == null ? () {} : widget.onPress!,
                  isLoading: state is QuizLoading,
                  color: theme.colorScheme.primaryContainer,
                  text: widget.startButtonText,
                ),
              ],
              SizedBox(height: widget.isCompact == true ? 0 : 30),
            ],
          ),
        );
      },
    );
  }
}
