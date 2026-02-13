// Sets up the Submit page of Match Scouting for the scouting app

// Library of basic UI functions and other basics (Not specific to 3082)
import 'package:flutter/material.dart';
// For sharing data between files and other basics (Not specific to 3082)
import 'package:provider/provider.dart';
// References enums.dart (which stores info about what is included in types of actions, ways to be disabled...)
import 'package:cluck_scout/model/enums.dart';
//
import 'package:cluck_scout/model/team_reader.dart';
//
import 'package:cluck_scout/providers/match_scouting_provider.dart';
//
import 'package:cluck_scout/screens/scouting_screen/widgets/team_serach_dialog.dart';

class RoundScreen extends StatefulWidget {
  const RoundScreen({super.key});

  @override
  RoundScreenState createState() => RoundScreenState();
}

class RoundScreenState extends State<RoundScreen> {
  late TextEditingController matchNumberController;
  late TextEditingController teamNumberController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<MatchScoutingProvider>();
    matchNumberController =
        TextEditingController(text: provider.matchNumber.toString());
    teamNumberController =
        TextEditingController(text: provider.teamNumber.toString());
  }

  @override
  void dispose() {
    matchNumberController.dispose();
    teamNumberController.dispose();
    super.dispose();
  }

  void _showTeamSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TeamSearchDialog(
        onTeamSelected: (Team selectedTeam) => context
            .read<MatchScoutingProvider>()
            .setTeamNumber(selectedTeam.teamNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();

    final matchNumber = context
        .select<MatchScoutingProvider, int>((provider) => provider.matchNumber);
    final teamNumber = context
        .select<MatchScoutingProvider, int>((provider) => provider.teamNumber);

    // Update controllers only if values actually changed
    if (matchNumber.toString() != matchNumberController.text) {
      matchNumberController.text = matchNumber.toString();
    }

    if (teamNumber != int.tryParse(teamNumberController.text)) {
      teamNumberController.text = teamNumber.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        const SizedBox(height: 20),
        // Displays Match Number
        TextField(
          controller: matchNumberController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            provider.setMatchNumber(int.tryParse(value) ?? 0);
          },
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(
            labelText: 'Match Number',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 9),
          ),
        ),
        const SizedBox(height: 15),
        // Displays Team number
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => {_showTeamSearch(context)},
                child: AbsorbPointer(
                  child: TextField(
                    controller: teamNumberController,
                    readOnly: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Team Number',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 9, horizontal: 9),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        // Displays the name of who is Scouting
        Center(
          child: Column(
            children: [
              Selector<MatchScoutingProvider, String>(
                selector: (context, model) => model.scouterName,
                builder: (context, name, child) {
                  name = name.trim();
                  return Text(
                    "$name, you are scouting",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  );
                },
              ),
              // Displays the position the person is scouting
              Selector<MatchScoutingProvider, Position>(
                selector: (context, model) => model.position,
                builder: (context, position, child) {
                  bool isBlue = position == Position.blueTop ||
                      position == Position.blueMiddle ||
                      position == Position.blueBottom;

                  String text = isBlue ? "Blue " : "Red ";

                  text += (position == Position.blueTop ||
                          position == Position.redTop)
                      ? "Top"
                      : "";

                  text += (position == Position.blueMiddle ||
                          position == Position.redMiddle)
                      ? "Middle"
                      : "";

                  text += (position == Position.blueBottom ||
                          position == Position.redBottom)
                      ? "Bottom"
                      : "";

                  return Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: isBlue
                          ? Color.fromARGB(255, 55, 96, 177)
                          : Color.fromRGBO(191, 54, 54, 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // Displays team logo
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            height: 260,
            child: Image.asset("assets/bird.png"),
          ),
        ),
      ],
    );
  }
}
