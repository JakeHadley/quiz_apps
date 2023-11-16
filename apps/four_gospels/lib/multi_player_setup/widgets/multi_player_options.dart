import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/common_widgets/action_button.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/models/models.dart';
import 'package:four_gospels/multi_player_setup/bloc/multi_player_bloc.dart';
import 'package:four_gospels/multi_player_setup/widgets/input.dart';

class MultiPlayerOptions extends StatelessWidget {
  const MultiPlayerOptions({
    required this.nameController,
    required this.codeController,
    required this.isNameValid,
    required this.isCodeValid,
    required this.onCreate,
    required this.onStateChange,
    required this.onError,
    required this.onJoin,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController codeController;
  final bool isNameValid;
  final bool isCodeValid;
  final VoidCallback onCreate;
  final VoidCallback onStateChange;
  final void Function(RoomExceptionErrorEnum error) onError;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final createButtonColor = !isNameValid ? theme.disabledColor : null;
    final joinButtonColor =
        !isNameValid || !isCodeValid ? theme.disabledColor : null;

    return BlocConsumer<MultiPlayerBloc, MultiPlayerState>(
      listener: (context, state) {
        if (state is MultiPlayerActive) {
          onStateChange();
        } else if (state is MultiPlayerError) {
          onError(state.error);
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Input(
                    controller: nameController,
                    label: l10n.enterNameField,
                  ),
                  const SizedBox(height: 30),
                  ActionButton(
                    onPress: onCreate,
                    color: createButtonColor,
                    isLoading: state is MultiPlayerLoading,
                    text: l10n.createGameButton,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 20),
                          child: const Divider(
                            color: Colors.black,
                            height: 36,
                          ),
                        ),
                      ),
                      Text(l10n.or),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 10),
                          child: const Divider(
                            color: Colors.black,
                            height: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Input(
                    controller: codeController,
                    label: l10n.enterCodeField,
                  ),
                  const SizedBox(height: 30),
                  ActionButton(
                    onPress: onJoin,
                    color: joinButtonColor,
                    isLoading: isNameValid &&
                        isCodeValid &&
                        state is MultiPlayerLoading,
                    text: l10n.joinGameButton,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
