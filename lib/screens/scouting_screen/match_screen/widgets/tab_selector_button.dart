import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';

class TabSelectorButton<T> extends StatelessWidget {
  final int buttonIndex;
  final String label;

  const TabSelectorButton({
    super.key,
    required this.buttonIndex,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Selector<T, int>(
        selector: (context, provider) => _getTabIndex(provider),
        builder: (context, tabIndex, child) {
          final provider = context.read<T>();

          return ElevatedButton(
            onPressed: () => _setTabIndex(provider, buttonIndex),
            style: ElevatedButton.styleFrom(
              backgroundColor: tabIndex == buttonIndex
                  ? const Color.fromRGBO(50, 50, 124, 1)
                  : const Color.fromRGBO(233, 233, 233, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tabIndex == buttonIndex
                    ? const Color.fromRGBO(247, 247, 247, 1)
                    : const Color.fromRGBO(28, 27, 31, 1),
              ),
            ),
          );
        },
      ),
    );
  }

  int _getTabIndex(dynamic provider) {
    if (provider is MatchScoutingProvider) return provider.tabIndex;
    if (provider is PitScoutingProvider) return provider.tabIndex;
    return 0;
  }

  void _setTabIndex(dynamic provider, int value) {
    if (provider is MatchScoutingProvider) {
      provider.setTabIndex(value);
    } else if (provider is PitScoutingProvider) {
      provider.setTabIndex(value);
    }
  }
}
