import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cluck_scout/model/enums.dart';

class GameActionsSidebar extends StatelessWidget {
  final void Function(ActionType) addGameAction;
  final void Function(ActionType) removeGameAction;

  const GameActionsSidebar({
    super.key,
    required this.addGameAction,
    required this.removeGameAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HoldableGameActionButton(
          actionText: "L1 Climb",
          actionType: ActionType.coralL1,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
        const SizedBox(height: 15),
        HoldableGameActionButton(
          actionText: "L2 Climb",
          actionType: ActionType.coralL2,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
        const SizedBox(height: 15),
        HoldableGameActionButton(
          actionText: "L3 Climb",
          actionType: ActionType.coralL3,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
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
        const SizedBox(
          height: 15,
        ),
        GameActionButton(
          actionText: "Used Depot",
          actionType: ActionType.processorAlgae,
          addGameAction: addGameAction,
          removeGameAction: removeGameAction,
        ),
      ],
    );
  }
}

class GameActionButton extends StatefulWidget {
  final void Function(ActionType) addGameAction;
  final void Function(ActionType) removeGameAction;
  final String actionText;
  final ActionType actionType;

  const GameActionButton({
    super.key,
    required this.actionText,
    required this.actionType,
    required this.addGameAction,
    required this.removeGameAction,
  });

  @override
  State<GameActionButton> createState() => _GameActionButtonState();
}

class _GameActionButtonState extends State<GameActionButton> {
  bool _selected = false;

  void _toggle() {
    setState(() => _selected = !_selected);
    if (_selected) {
      widget.addGameAction(widget.actionType);
    } else {
      widget.removeGameAction(widget.actionType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _selected
        ? const Color.fromRGBO(50, 50, 124, 1)
        : const Color.fromRGBO(233, 233, 233, 1);
    final fg = _selected
        ? const Color.fromRGBO(233, 233, 233, 1)
        : const Color.fromRGBO(28, 27, 31, 1);
    return ElevatedButton(
      onPressed: _toggle,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: SizedBox(
        height: 51.6,
        width: 160,
        child: Center(
          child: Text(
            widget.actionText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}

class HoldableGameActionButton extends StatefulWidget {
  final void Function(ActionType) addGameAction;
  final void Function(ActionType) removeGameAction;
  final String actionText;
  final ActionType actionType;

  const HoldableGameActionButton({
    super.key,
    required this.actionText,
    required this.actionType,
    required this.addGameAction,
    required this.removeGameAction,
  });

  @override
  State<HoldableGameActionButton> createState() => _HoldableGameActionButtonState();
}

class _HoldableGameActionButtonState extends State<HoldableGameActionButton> {
  Timer? _timer;
  bool _selected = false;

  void _startRepeated() {
    widget.addGameAction(widget.actionType);
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      widget.addGameAction(widget.actionType);
    });
  }

  void _stopRepeated() {
    _timer?.cancel();
    _timer = null;
  }

  void _toggle() {
    setState(() => _selected = !_selected);
    if (_selected) {
      widget.addGameAction(widget.actionType);
    } else {
      widget.removeGameAction(widget.actionType);
    }
  }

  @override
  void dispose() {
    _stopRepeated();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _selected
        ? const Color.fromRGBO(50, 50, 124, 1)
        : const Color.fromRGBO(233, 233, 233, 1);
    final fg = _selected
        ? const Color.fromRGBO(233, 233, 233, 1)
        : const Color.fromRGBO(28, 27, 31, 1);
    return GestureDetector(
      onTapDown: (_) => _startRepeated(),
      onTapUp: (_) => _stopRepeated(),
      onTapCancel: () => _stopRepeated(),
      onTap: _toggle,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: SizedBox(
          height: 51.6,
          width: 160,
          child: Center(
            child: Text(
              widget.actionText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
