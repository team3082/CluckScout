import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/screens/auto_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/screens/round_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/screens/submit_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/screens/teleop_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/widgets/tab_selector_button.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.videogame_asset, size: 30),
            Text(
              " Match Scouting",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(28, 27, 31, 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabSelectorButton<MatchScoutingProvider>(
              buttonIndex: 0,
              label: "Round",
            ),
            TabSelectorButton<MatchScoutingProvider>(
              buttonIndex: 1,
              label: "Auto",
            ),
            TabSelectorButton<MatchScoutingProvider>(
              buttonIndex: 2,
              label: "Teleop",
            ),
            TabSelectorButton<MatchScoutingProvider>(
              buttonIndex: 3,
              label: "Submit",
            ),
          ],
        ),
        const SizedBox(height: 10),
        IndexedStack(
          index: context.select<MatchScoutingProvider, int>(
              (provider) => provider.tabIndex),
          children: const [
            RoundScreen(),
            AutoScreen(),
            TeleopScreen(),
            SubmitScreen(),
          ],
        ),
      ],
    );
  }
}
