import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';

class GameActionWindow extends StatelessWidget {
  final String Function(MatchScoutingProvider) getScoreString;
  final void Function(MatchScoutingProvider) deleteFunction;
  final void Function(MatchScoutingProvider)? undoFunction;
  final bool Function(MatchScoutingProvider)? hasUndoItems;
  final double actionWindowWidth;
  final double actionWindowHeight;

  const GameActionWindow({
    required this.getScoreString,
    required this.deleteFunction,
    this.undoFunction,
    this.hasUndoItems,
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
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  overlayColor: const Color.fromRGBO(50, 50, 124, 1),
                  backgroundColor: const Color.fromRGBO(233, 233, 233, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () =>
                    deleteFunction(context.read<MatchScoutingProvider>()),
                child: const SizedBox(
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
            if (undoFunction != null && hasUndoItems != null) ...[
              const SizedBox(width: 10),
              Selector<MatchScoutingProvider, bool>(
                selector: (context, provider) => hasUndoItems!(provider),
                builder: (context, canUndo, __) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      overlayColor: const Color.fromRGBO(50, 50, 124, 1),
                      backgroundColor: canUndo
                          ? const Color.fromRGBO(233, 233, 233, 1)
                          : const Color.fromARGB(255, 180, 180, 180),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: canUndo
                        ? () => undoFunction!(context.read<MatchScoutingProvider>())
                        : null,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Icon(
                          Icons.undo,
                          size: 24,
                          color: canUndo
                              ? const Color.fromRGBO(28, 27, 31, 1)
                              : const Color.fromRGBO(100, 100, 100, 1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
