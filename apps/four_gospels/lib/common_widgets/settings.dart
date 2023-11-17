import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/common_widgets/settings_content.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/mode.dart';
import 'package:quiz_core/models/models.dart';

class Settings extends StatefulWidget {
  const Settings({
    required this.type,
    required this.onStateChange,
    required this.isCompact,
    this.onPress,
    this.onChangeSettings,
    super.key,
  });

  final QuizType type;
  final void Function({int? timer}) onStateChange;
  final bool isCompact;
  final void Function({
    required Mode mode,
    required String language,
    int? questions,
    int? timer,
  })? onPress;
  final void Function(
    SettingsOptions option,
    dynamic value,
  )? onChangeSettings;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _questions = 10;
  Mode _mode = Mode.easy;
  String _language = Languages.en.name;
  int _timer = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getInitialLanguage();
    });
  }

  void _getInitialLanguage() {
    final languageTag = Localizations.localeOf(context).toLanguageTag();

    final languageTagToEnum = {
      'en': Languages.en,
      'pt': Languages.pt,
      'es': Languages.es,
    };
    setState(() {
      _language = languageTagToEnum[languageTag]?.name ?? Languages.en.name;
    });
  }

  void _onChangeQuestions(int value) {
    setState(() => _questions = value);
    widget.onChangeSettings?.call(SettingsOptions.questions, value);
  }

  void _onTimerChanged(int value) {
    setState(() => _timer = value);
  }

  Widget _choiceChipGenerator(
    int index,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final mode = Mode.values[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        selectedColor: theme.primaryColorLight,
        label: Text(
          mode.toStringIntl(l10n),
          style: theme.textTheme.bodyLarge
              ?.copyWith(fontSize: widget.isCompact ? 16 : 20),
        ),
        selected: _mode == mode,
        onSelected: (bool selected) {
          setState(() => _mode = mode);
          widget.onChangeSettings?.call(SettingsOptions.difficulty, mode);
        },
      ),
    );
  }

  int getFlagFromLanguage() {
    return Languages.values
        .byName(Localizations.localeOf(context).toLanguageTag())
        .index;
  }

  void getLanguageFromFlag(int index, CarouselPageChangedReason _) {
    setState(() {
      _language = Languages.values[index].name;
    });
    widget.onChangeSettings?.call(
      SettingsOptions.language,
      Languages.values[index].name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final chips = List.generate(
      Mode.values.length,
      (int index) => _choiceChipGenerator(index, theme, l10n),
    );

    return SettingsContent(
      type: widget.type,
      chips: chips,
      onStateChange: widget.onStateChange,
      onChangeQuestions: _onChangeQuestions,
      questions: _questions,
      initialLanguage: Languages.values
          .byName(Localizations.localeOf(context).toLanguageTag())
          .index,
      onChangeLanguage: getLanguageFromFlag,
      timer: _timer,
      onChangeTimer: _onTimerChanged,
      onPress: () => widget.onPress?.call(
        mode: _mode,
        language: _language,
        questions: _questions,
        timer: _timer,
      ),
      isCompact: widget.isCompact,
    );
  }
}
