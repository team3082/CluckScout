import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/game_actions_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';

int autoCounter=0;

class GameActionWindow extends StatelessWidget {
  final String Function(MatchScoutingProvider) getScoreString;
  final void Function(MatchScoutingProvider) deleteFunction;
  final double actionWindowWidth;
  final double actionWindowHeight;

  const GameActionWindow({
    required this.getScoreString,
    required this.deleteFunction,
    required this.actionWindowWidth,
    required this.actionWindowHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Game Actions",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: actionWindowWidth,
            height: actionWindowHeight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(233, 233, 233, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Selector<MatchScoutingProvider, String>(
                selector: (context, provider) => getScoreString(provider),
                builder: (context, scoreString, child) {
                  return Text(
                    scoreString,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              overlayColor: const Color.fromRGBO(50, 50, 124, 1),
              backgroundColor: const Color.fromRGBO(233, 233, 233, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            //incomplete need to come back and fix
            onPressed: () =>
                deleteFunction(context.read<MatchScoutingProvider>()),
            child: Container(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(28, 27, 31, 1),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: GameActionButton(actionText: "Hub Shooting", addGameAction: () => (ActionType.Hub)),
        ),
      ],
    );
  }
}
