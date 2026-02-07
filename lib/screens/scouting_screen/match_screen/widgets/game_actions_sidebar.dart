import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:cluck_scout/model/enums.dart';

class GameActionsSidebar extends StatelessWidget {
  final void Function(ActionType) addGameAction;

  const GameActionsSidebar({
    super.key,
    required this.addGameAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*GameActionButton(
          actionText: "Lvl. 1 Climb",
          addGameAction: () => addGameAction(ActionType.L1),
        ),
        const SizedBox(
          height: 15,
        ),*/
        GameActionButton(
          actionText: "Trench",
          addGameAction: () => addGameAction(ActionType.Trench),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Bump",
          addGameAction: () => addGameAction(ActionType.Bump),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Hub Shooting",
          addGameAction: () => addGameAction(ActionType.Hub),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class GameActionButton extends StatelessWidget {
  final void Function() addGameAction;
  final String actionText;

  const GameActionButton({
    super.key,
    required this.actionText,
    required this.addGameAction,
  });

  static final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color.fromRGBO(233, 233, 233, 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        addGameAction();
      },
      style: _buttonStyle,
      child: SizedBox(
        //height: 51.6,
        height: 80,
        width: 160,
        child: Center(
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(28, 27, 31, 1),
            ),
          ),
        ),
      ),
    );
  }
}

