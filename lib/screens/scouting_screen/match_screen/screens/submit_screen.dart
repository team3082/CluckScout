// Sets up the Submit page of Match Scouting for the scouting app

// Library of basic UI functions and other basics (Not specific to 3082)
import 'package:flutter/material.dart';
// For sharing data between files and other basics (Not specific to 3082)
import 'package:provider/provider.dart';
// References enums.dart (which stores info about what is included in types of actions, ways to be disabled...)
import 'package:cluck_scout/model/enums.dart';
//
import 'package:cluck_scout/providers/match_scouting_provider.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key});

  @override
  // Match Notes label
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildScoreSection(),
                    const SizedBox(height: 10),
                    _buildRankings(context),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Match Notes",
                        style: TextStyle(
                          color: Color.fromRGBO(28, 27, 31, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const NotesTextField(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(child: const SubmitButton()),
        ],
      ),
    );
  }

  // Displays Auto and Teleop scores
  Widget _buildScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Auto Score",
          style: TextStyle(
            color: Color.fromRGBO(28, 27, 31, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Selector<MatchScoutingProvider, int>(
          selector: (context, model) => model.autoScore,
          builder: (context, score, child) {
            return Text(
              "$score pts",
              style: const TextStyle(
                color: Color.fromRGBO(50, 50, 124, 1),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            );
          },
        ),
        const Text(
          "Teleop Score",
          style: TextStyle(
            color: Color.fromRGBO(28, 27, 31, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Selector<MatchScoutingProvider, int>(
          selector: (context, model) => model.teleopScore,
          builder: (context, score, child) {
            return Text(
              "$score pts",
              style: const TextStyle(
                color: Color.fromRGBO(50, 50, 124, 1),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            );
          },
        ),
      ],
    );
  }

  // Creates drop downs for rating teams/providing info
  Widget _buildRankings(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    const TextStyle dropdownTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(28, 27, 31, 1),
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Disabled drop down
        _buildDropdownRow(
          "Disabled",
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: DropdownButton<Disabled>(
              value: context.select<MatchScoutingProvider, Disabled>((p) => p.disabled),
              items: Disabled.values.map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.toString().split('.').last,
                  style: dropdownTextStyle,
                ),
              )).toList(),
              onChanged: (val) => provider.setDisabled(val ?? Disabled.None),
              underline: Container(),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(50, 50, 124, 1),
                size: 24,
              ),
              isDense: true,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 4,
            ),
          ),
        ),
        // Defense drop down
        _buildDropdownRow(
          "Defense",
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: DropdownButton<int>(
              value: context.select<MatchScoutingProvider, int>((p) => p.defenseRank),
              items: [for (var i = 0; i <= 10; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    i == 0 ? "None" : "$i",
                    style: dropdownTextStyle,
                  ),
                )
              ],
              onChanged: (val) => provider.setDefense(val ?? 0),
              underline: Container(),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(50, 50, 124, 1),
                size: 24,
              ),
              isDense: true,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 4,
            ),
          ),
        ),
        // Robot Goal drop down
        _buildDropdownRow(
          "Robot Goal",
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: DropdownButton<RobotGoal>(
              value: context.select<MatchScoutingProvider, RobotGoal>((p) => p.robotGoal),
              items: RobotGoal.values.map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.toString().split('.').last,
                  style: dropdownTextStyle,
                ),
              )).toList(),
              onChanged: (val) => provider.setRobotGoal(val ?? RobotGoal.other),
              underline: Container(),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(50, 50, 124, 1),
                size: 24,
              ),
              isDense: true,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 4,
            ),
          ),
        ),
        // Driving drop down
        _buildDropdownRow(
          "Driving",
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: DropdownButton<int>(
              value: context.select<MatchScoutingProvider, int>((p) => p.drivingRank),
              items: [for (var i = 0; i <= 10; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    "$i",
                    style: dropdownTextStyle,
                  ),
                )
              ],
              onChanged: (val) => provider.setDrivingRank(val ?? 0),
              underline: Container(),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(50, 50, 124, 1),
                size: 24,
              ),
              isDense: true,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: Colors.white,
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  // Instructions for template drop down
  Widget _buildDropdownRow(String label, Widget dropdown) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromRGBO(28, 27, 31, 1),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Color.fromRGBO(50, 50, 124, 1),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                dropdown,
                SizedBox(height: 5,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Creates notes area
class NotesTextField extends StatefulWidget {
  const NotesTextField({super.key});

  @override
  _NotesTextFieldState createState() => _NotesTextFieldState();
}
class _NotesTextFieldState extends State<NotesTextField> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = context
        .select<MatchScoutingProvider, String>((provider) => provider.notes);
    final provider = context.read<MatchScoutingProvider>();

    if (_notesController.text != notes) {
      _notesController.text = notes;
    }

    return TextField(
      controller: _notesController,
      maxLines: 9,
      maxLength: 200,
      textAlignVertical: TextAlignVertical.top,
      onChanged: (value) => provider.setMatchNotes(value),
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.all(8),
        filled: true,
        fillColor: Color.fromRGBO(233, 233, 233, 1),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }
}

// Creates submit button and checks error messages
class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  // Creates submit button
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(233, 233, 233, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => _handleSubmitRequest(context),
      child: SizedBox(
        height: 62.5,
        width: 187.5,
        child: Center(
          child: Text(
            "Submit",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(28, 27, 31, 1),
            ),
          ),
        ),
      ),
    );
  }

  // Confirms that user actually inputed needed values (Ex. team #) and returns error message
  void _handleSubmitRequest(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();
    FocusScope.of(context).unfocus();

    if (provider.matchNumber == 0) {
      _showError(context, "No Match Number Set!");
      provider.setTabIndex(0);
    } else if (provider.teamNumber == 0) {
      _showError(context, "No Team Number Set!");
      provider.setTabIndex(0);
    } else if (provider.notes == "") {
      _showError(context, "No Notes Taken!");
    } else {
      provider.setTabIndex(0);
      provider.submitMatchData();
    }
  }
  void _showError(BuildContext context, String error) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            width: 200,
            height: 100,
            child: Center(
              child: Text(
                error,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
