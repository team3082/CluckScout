import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        GameActionButton(
          actionText: "L1 Climb",
          addGameAction: () => addGameAction(ActionType.L1climb),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "L2 Climb",
          addGameAction: () => addGameAction(ActionType.L2climb),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "L3 Climb",
          addGameAction: () => addGameAction(ActionType.L3climb),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Attempted Climb",
          addGameAction: () => addGameAction(ActionType.attemptedClimb),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Used Depot",
          addGameAction: () => addGameAction(ActionType.usedDepot),
        ),
        const SizedBox(height: 15),
        GameActionButton(
          actionText: "Used Outpost",
          addGameAction: () => addGameAction(ActionType.usedOutpost),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Bump",
          addGameAction: () => addGameAction(ActionType.bump),
        ),
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Trench",
          addGameAction: () => addGameAction(ActionType.trench),
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
        height: 51.6,
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
