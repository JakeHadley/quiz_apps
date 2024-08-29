import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/multi_player_bloc/multi_player_bloc.dart';
import 'package:quiz_core/common_widgets/custom_appbar.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/multi_widgets/multi_player_options.dart';
import 'package:random_string/random_string.dart';

///
class MultiPlayerSetupWrapper extends StatefulWidget {
  ///
  const MultiPlayerSetupWrapper({
    required this.title,
    required this.navigateToLobby,
    required this.nameTakenText,
    required this.noRoomText,
    required this.enterNameText,
    required this.createGameText,
    required this.orText,
    required this.enterCodeText,
    required this.joinGameText,
    super.key,
  });

  ///
  final String title;

  ///
  final VoidCallback navigateToLobby;

  ///
  final String nameTakenText;

  ///
  final String noRoomText;

  ///
  final String enterNameText;

  ///
  final String createGameText;

  ///
  final String orText;

  ///
  final String enterCodeText;

  ///
  final String joinGameText;

  @override
  State<MultiPlayerSetupWrapper> createState() =>
      _MultiPlayerSetupWrapperState();
}

class _MultiPlayerSetupWrapperState extends State<MultiPlayerSetupWrapper> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  bool _nameEntered = false;
  bool _codeEntered = false;

  @override
  void initState() {
    _codeController.addListener(() {
      setState(() {
        _codeEntered = _codeController.text.isNotEmpty;
      });
    });
    _nameController.addListener(() {
      setState(() {
        _nameEntered = _nameController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool isNameValid() => _nameEntered;
  bool isCodeValid() => _codeEntered;

  void onCreate() {
    if (!isNameValid()) {
      return;
    }

    final language = Localizations.localeOf(context).toLanguageTag();

    final createRoomEvent = MultiPlayerCreateRoom(
      code: randomAlphaNumeric(6),
      numQuestions: 10,
      name: _nameController.text,
      mode: Mode.easy,
      language: language,
    );

    context.read<MultiPlayerBloc>().add(createRoomEvent);
  }

  void onJoin() {
    if (!isNameValid() || !isCodeValid()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final language = Localizations.localeOf(context);

    final joinRoomEvent = MultiPlayerJoinRoom(
      name: _nameController.text,
      code: _codeController.text,
      language: language.toLanguageTag(),
    );

    context.read<MultiPlayerBloc>().add(joinRoomEvent);
  }

  void onStateChange() {
    _codeController.clear();
    _nameController.clear();

    setState(() {
      _codeEntered = false;
      _nameEntered = false;
    });
    widget.navigateToLobby();
  }

  void onError(RoomExceptionErrorEnum error) {
    String errorStr;
    switch (error) {
      case RoomExceptionErrorEnum.name:
        errorStr = widget.nameTakenText;
      case RoomExceptionErrorEnum.room:
        errorStr = widget.noRoomText;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(errorStr),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        )
        .closed
        .then((reason) {
      if (!mounted) return;
      context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        type: QuizType.multi,
        backButton: BackButton(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      body: MultiPlayerOptions(
        nameController: _nameController,
        codeController: _codeController,
        onCreate: onCreate,
        isNameValid: isNameValid(),
        isCodeValid: isCodeValid(),
        onStateChange: onStateChange,
        onError: onError,
        onJoin: onJoin,
        enterNameText: widget.enterNameText,
        createGameText: widget.createGameText,
        orText: widget.orText,
        enterCodeText: widget.enterCodeText,
        joinGameText: widget.joinGameText,
      ),
    );
  }
}
