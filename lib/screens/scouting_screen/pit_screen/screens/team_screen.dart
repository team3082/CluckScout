import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/model/team_reader.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/widgets/team_serach_dialog.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  TeamScreenState createState() => TeamScreenState();
}

class TeamScreenState extends State<TeamScreen> {
  late TextEditingController teamNumberController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PitScoutingProvider>();
    teamNumberController =
        TextEditingController(text: provider.teamNumber.toString());
  }

  @override
  void dispose() {
    teamNumberController.dispose();
    super.dispose();
  }

  void _showTeamSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TeamSearchDialog(
          onTeamSelected: (Team selectedTeam) => context
              .read<PitScoutingProvider>()
              .setTeamNumber(selectedTeam.teamNumber)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamNumber = context
        .select<PitScoutingProvider, int>((provider) => provider.teamNumber);

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
            GestureDetector(
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
        const SizedBox(height: 20),
        Center(
          child: Selector<PitScoutingProvider, String>(
            selector: (context, model) => model.scouterName,
            builder: (context, name, child) {
              name = name.trim();
              return Text(
                "$name, you are pit scouting",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              );
            },
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            height: 400,
            child: Image.asset("assets/bird.png"),
          ),
        ),
      ],
    );
  }
}
