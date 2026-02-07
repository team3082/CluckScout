import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/game_action_window.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/game_actions_sidebar.dart';

class TeleopScreen extends StatelessWidget {
  const TeleopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                GameActionsSidebar(
                  addGameAction: provider.addTeleopAction,
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameActionWindow(
                    getScoreString: (provider) =>
                        provider.getTeleopActionString(),
                    deleteFunction: (provider) => provider.removeTeleopAction(),
                    actionWindowWidth: double.infinity,
                    actionWindowHeight: 215,
                  ),
                  const SizedBox(height: 15),
                  EndStatusButton(
                    status: EndStatus.L1,
                    text: "Lvl. 1 Climb",
                  ),
                  const SizedBox(height: 15),
                  EndStatusButton(
                    status: EndStatus.L2,
                    text: "Lvl. 2 Climb",
                  ),
                  const SizedBox(height: 15),
                  EndStatusButton(
                    status: EndStatus.L3,
                    text: "Lvl. 3 Climb",
                  ),
                  /*const SizedBox(height: 15),
                  EndStatusButton(
                    status: EndStatus.L3,
                    text: "Used Depot",
                  ),*/
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class EndStatusButton extends StatelessWidget {
  final EndStatus status;
  final String text;
  const EndStatusButton({super.key, required this.status, required this.text});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    return Selector<MatchScoutingProvider, EndStatus>(
      selector: (_, provider) => provider.endStatus,
      builder: (_, endStatus, __) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: endStatus == status
                ? const Color.fromRGBO(50, 50, 124, 1)
                : const Color.fromARGB(255, 220, 220, 223),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => provider
              .setEndStatus(endStatus == status ? EndStatus.none : status),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: endStatus == status
                      ? const Color.fromRGBO(247, 247, 247, 1)
                      : const Color.fromRGBO(28, 27, 31, 1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
