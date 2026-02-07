import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/game_action_window.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/game_actions_sidebar.dart';

class AutoScreen extends StatelessWidget {
  const AutoScreen({super.key});

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
                  addGameAction: provider.addAutoAction,
                ),
                // const SizedBox(height: 55),
                // const AutoPointsDisplay(),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameActionWindow(
                    getScoreString: (provider) =>
                        provider.getAutoActionString(),
                    deleteFunction: (provider) => provider.removeAutoAction(),
                    actionWindowWidth: double.infinity,
                    actionWindowHeight: 224,
                  ),
                  //const SizedBox(height: 16),
                  //const AutoLeaveButton(),
                  const SizedBox(height: 15),
                  AutoStatusButton(
                    status: AutoStatus.L1,
                    text: "Lvl. 1 Climb",
                  ),
                  const SizedBox(height: 15),
                  AutoStatusButton(
                    status: AutoStatus.L2,
                    text: "Lvl. 2 Climb",
                  ),
                  const SizedBox(height: 15),
                  AutoStatusButton(
                    status: AutoStatus.L3,
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

class AutoStatusButton extends StatelessWidget {
  final AutoStatus status;
  final String text;
  const AutoStatusButton({super.key, required this.status, required this.text});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    return Selector<MatchScoutingProvider, AutoStatus>(
      selector: (_, provider) => provider.autoStatus,
      builder: (_, autoStatus, __) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: autoStatus == status
                ? const Color.fromRGBO(50, 50, 124, 1)
                : const Color.fromARGB(255, 220, 220, 223),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => provider.setAutoStatus(autoStatus == status ? AutoStatus.none : status),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: autoStatus == status
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

class AutoPointsDisplay extends StatelessWidget {
  const AutoPointsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MatchScoutingProvider, int>(
      selector: (_, provider) => provider.autoScore,
      builder: (_, points, __) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Auto: ",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(28, 27, 31, 1)),
            ),
            Text(
              "$points pts",
              style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(104, 140, 219, 1)),
            ),
          ],
        );
      },
    );
  }
}
/*
class AutoLeaveButton extends StatelessWidget {
  const AutoLeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    return Selector<MatchScoutingProvider, bool>(
      selector: (_, provider) => provider.autoLeave,
      builder: (_, autoLeave, __) {
        return Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: autoLeave
                  ? const Color.fromRGBO(50, 50, 124, 1)
                  : const Color.fromARGB(255, 220, 220, 223),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              provider.setAutoLeave(!autoLeave);
            },
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Left Starting Zone",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: autoLeave
                        ? Color.fromRGBO(233, 233, 233, 1)
                        : Color.fromRGBO(28, 27, 31, 1),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
