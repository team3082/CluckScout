import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/model/enums.dart';
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
            SizedBox(
              width: 220,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  AutoGameActionsSidebar(
                    addGameAction: provider.addAutoAction,
                    removeGameAction: provider.removeAutoActionOfType,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  GameActionWindow(
                    getScoreString: (provider) =>
                        provider.getAutoActionString(),
                    deleteFunction: (provider) => provider.removeAutoAction(),
                    actionWindowWidth: double.infinity,
                    actionWindowHeight: 160,
                  ),
                  const SizedBox(height: 12),
                  const ShootButton(),
                  const SizedBox(height: 20),
                  const AutoPointsDisplay()
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ShootButton extends StatelessWidget {
  const ShootButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    return Selector<MatchScoutingProvider, bool>(
      selector: (_, p) => p.isShooting,
      builder: (_, isShooting, __) {
        return GestureDetector(
          onTapDown: (_) => provider.startAutoHub(),
          onTapUp: (_) => provider.stopAutoHub(),
          onTapCancel: () => provider.stopAutoHub(),
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isShooting
                  ? const Color.fromRGBO(50, 50, 124, 1)
                  : const Color.fromRGBO(233, 233, 233, 1),
              borderRadius: BorderRadius.circular(10),
            ), 
            child: Center(
              child: Text(
                'Shooting',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isShooting
                      ? const Color.fromRGBO(233, 233, 233, 1)
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

class L1HoldButton extends StatefulWidget {
  final void Function(ActionType) addGameAction;

  const L1HoldButton({super.key, required this.addGameAction});

  @override
  State<L1HoldButton> createState() => _L1HoldButtonState();
}

class _L1HoldButtonState extends State<L1HoldButton> {
  bool _isPressed = false;
  DateTime? _pressStart;

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _pressStart = DateTime.now();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    final start = _pressStart;
    _pressStart = null;
    if (start == null) return;
    final held = DateTime.now().difference(start).inMilliseconds;
    // require a short hold to confirm (500ms)
    if (held >= 500) {
      final provider = context.read<MatchScoutingProvider>();
      final hasL1 = provider.autoActions
          .where((a) => a == ActionType.L1)
          .isNotEmpty;
      if (!hasL1) {
        widget.addGameAction(ActionType.L1);
      }
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressStart = null;
  }

  @override
  Widget build(BuildContext context) {
    // Keep label and color consistent; still require hold to confirm.
    context.watch<MatchScoutingProvider>();
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(233, 233, 233, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'L1 Climb',
            style: TextStyle(
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

class AutoGameActionsSidebar extends StatelessWidget {
  final void Function(ActionType) addGameAction;
  final void Function(ActionType) removeGameAction;

  const AutoGameActionsSidebar({
    super.key,
    required this.addGameAction,
    required this.removeGameAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        L1HoldButton(addGameAction: addGameAction),
        const SizedBox(height: 15),
        GameActionButton(
          actionText: "Attempted Climb",
          actionType: ActionType.dropped,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
        const SizedBox(height: 15),
        GameActionButton(
          actionText: "Used Outpost",
          actionType: ActionType.usedOutpost,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
        const SizedBox(height: 15),
        GameActionButton(
          actionText: "Used Depot",
          actionType: ActionType.processorAlgae,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
        const SizedBox(height: 15),
        GameActionButton(
          actionText: "Bump",
          actionType: ActionType.usedBump,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
        const SizedBox(height: 15),
        GameActionButton(
          actionText: "Trench",
          actionType: ActionType.usedTrench,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
      ],
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

  