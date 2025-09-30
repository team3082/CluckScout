import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/tab_selector_button.dart';
import 'package:cluck_scout/screens/scouting_screen/pit_screen/screens/abilities_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/pit_screen/screens/playstyle_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/pit_screen/screens/sumbit_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/pit_screen/screens/team_screen.dart';

class PitScreen extends StatelessWidget {
  const PitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: const [
            Icon(Icons.build, size: 30),
            Text(
              " Pit Scouting",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabSelectorButton<PitScoutingProvider>(
              buttonIndex: 0,
              label: "Team",
            ),
            TabSelectorButton<PitScoutingProvider>(
              buttonIndex: 1,
              label: "Abilities",
            ),
            TabSelectorButton<PitScoutingProvider>(
              buttonIndex: 2,
              label: "Playstyle",
            ),
            TabSelectorButton<PitScoutingProvider>(
              buttonIndex: 3,
              label: "Submit",
            ),
          ],
        ),
        const SizedBox(height: 10),
        IndexedStack(
          index: context.select<PitScoutingProvider, int>(
              (provider) => provider.tabIndex),
          children: const [
            TeamScreen(),
            AbilitiesScreen(),
            PlaystyleScreen(),
            SubmitScreen()
          ],
        ),
      ],
    );
  }
}
