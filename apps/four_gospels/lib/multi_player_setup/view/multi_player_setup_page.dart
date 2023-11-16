import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/models/models.dart';
import 'package:four_gospels/multi_player_setup/bloc/multi_player_bloc.dart';
import 'package:four_gospels/multi_player_setup/widgets/widgets.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:random_string/random_string.dart';

@RoutePage()
class MultiPlayerSetupPage extends StatefulWidget {
  const MultiPlayerSetupPage({super.key});

  @override
  State<MultiPlayerSetupPage> createState() => _MultiPlayerSetupPageState();
}

class _MultiPlayerSetupPageState extends State<MultiPlayerSetupPage> {
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

    context.router.navigate(const LobbyRoute());
  }

  void onError(RoomExceptionErrorEnum error) {
    String errorStr;
    switch (error) {
      case RoomExceptionErrorEnum.name:
        errorStr = context.l10n.nameTaken;
        break;
      case RoomExceptionErrorEnum.room:
        errorStr = context.l10n.noRoom;
        break;
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
      context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.multiPlayerAppBar, type: QuizType.multi),
      body: MultiPlayerOptions(
        nameController: _nameController,
        codeController: _codeController,
        onCreate: onCreate,
        isNameValid: isNameValid(),
        isCodeValid: isCodeValid(),
        onStateChange: onStateChange,
        onError: onError,
        onJoin: onJoin,
      ),
    );
  }
}
