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
                        provider.getTeleopActionWithHubString(),
                    deleteFunction: (provider) => provider.removeLastTeleopItem(),
                    undoFunction: (provider) => provider.undoLastTeleopDelete(),
                    hasUndoItems: (provider) => provider.hasTeleopDeletedItems,
                    actionWindowWidth: double.infinity,
                    actionWindowHeight: 309,
                  ),
                  const SizedBox(height: 15),
                  TeleopHubShootingButton(),
                  const SizedBox(height: 10),
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
      selector: (_, provider) => provider.endNone == EndStatus.none
          ? EndStatus.none
          : provider.endClimb == EndStatus.climb
              ? EndStatus.climb
              : provider.endShooting == EndStatus.shooting
                  ? EndStatus.shooting
                  : EndStatus.none,
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
              .setEndNone(endStatus == status ? EndStatus.none : status),
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

class TeleopHubShootingButton extends StatelessWidget {
  const TeleopHubShootingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MatchScoutingProvider, bool>(
      selector: (_, provider) => provider.teleopHubShooting,
      builder: (context, isRunning, __) {
        final provider = Provider.of<MatchScoutingProvider>(context, listen: false);
        return Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isRunning
                  ? const Color.fromRGBO(50, 50, 124, 1)
                  : const Color.fromARGB(255, 220, 220, 223),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              provider.toggleTeleopHubShooting();
            },
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: Center(
                child: Text(
                  isRunning ? "Hub Shooting" : "Hub Shooting",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isRunning
                        ? const Color.fromRGBO(233, 233, 233, 1)
                        : const Color.fromRGBO(28, 27, 31, 1),
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

class TeleopTimeShooting extends StatelessWidget {
  const TeleopTimeShooting({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MatchScoutingProvider, double>(
      selector: (_, provider) => provider.teleopDisplayedTime,
      builder: (context, displayedTime, __) {
        return Center(
          child: Text(
            "Current Time: ${displayedTime.toStringAsFixed(1)}s",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(28, 27, 31, 1),
            ),
          ),
        );
      },
    );
  }
}
