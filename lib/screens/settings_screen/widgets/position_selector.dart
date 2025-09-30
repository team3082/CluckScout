import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';

class PositionSelector extends StatelessWidget {
  static const blue = Color.fromARGB(255, 55, 96, 177);
  static const red = Color.fromRGBO(191, 54, 54, 1);

  const PositionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PositionButton(
            position: Position.redTop,
            highlightColor: red,
            displayText: "Red Top",
          ),
          PositionButton(
            position: Position.redMiddle,
            highlightColor: red,
            displayText: "Red Middle",
          ),
          PositionButton(
            position: Position.redBottom,
            highlightColor: red,
            displayText: "Red Bottom",
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PositionButton(
            position: Position.blueTop,
            highlightColor: blue,
            displayText: "Blue Top",
          ),
          PositionButton(
            position: Position.blueMiddle,
            highlightColor: blue,
            displayText: "Blue Middle",
          ),
          PositionButton(
            position: Position.blueBottom,
            highlightColor: blue,
            displayText: "Blue Bottom",
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}

class PositionButton extends StatelessWidget {
  final Position position;
  final Color highlightColor;
  final String displayText;

  const PositionButton({
    super.key,
    required this.position,
    required this.highlightColor,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    final MatchScoutingProvider provider =
        context.read<MatchScoutingProvider>();

    return Selector<MatchScoutingProvider, bool>(
      selector: (context, provider) => provider.position == position,
      builder: (context, isSelected, child) {
        final Color color = isSelected
            ? highlightColor
            : const Color.fromRGBO(233, 233, 233, 1);

        return ElevatedButton(
          onPressed: () => provider.setPosition(position),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: SizedBox(
            width: 100,
            height: 50,
            child: Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected
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
