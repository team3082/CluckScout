import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/data/pit_data.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MatchScoutingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        SizedBox(
          height: 10,
        ),
        const Text(
          "Comments",
          style: TextStyle(
            color: Color.fromRGBO(28, 27, 31, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const NotesTextField(), // Separate Stateful Widget
        const SizedBox(height: 10),
        SizedBox(
          child: Text(
            "Make sure to mention SWIFT bracelets when talking to people from other teams, and trade them if you like the ones they’ve got. This helps people associate kindness and fun with our team, and may also get you some new friends in the process. Help spread the SWIFT message of inclusivity and fun! Also, Evan will be very happy with you if you trade SWIFT bracelets. Make Evan happy! - Elliot",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 40),
        Center(child: const SubmitButton()),
      ],
    );
  }
}

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
        .select<PitScoutingProvider, String>((provider) => provider.notes);
    final provider = context.read<PitScoutingProvider>();

    if (_notesController.text != notes) {
      _notesController.text = notes;
    }

    return TextField(
      controller: _notesController,
      maxLines: 5,
      maxLength: 200,
      textAlignVertical: TextAlignVertical.top,
      onChanged: (value) => provider.setComments(value),
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

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
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

  void _handleSubmitRequest(BuildContext context) {
    final provider = context.read<PitScoutingProvider>();
    FocusScope.of(context).unfocus();

    if (provider.teamNumber == 0) {
      _showError(context, "No Team Number Set!");
      provider.setTabIndex(0);
    } else {
      provider.setTabIndex(0);
      provider.submit();
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
