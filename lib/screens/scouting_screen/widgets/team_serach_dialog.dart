import 'package:flutter/material.dart';
import 'package:cluck_scout/model/team_reader.dart';

class TeamSearchDialog extends StatefulWidget {
  final void Function(Team selectedTeam) onTeamSelected;

  const TeamSearchDialog({
    super.key,
    required this.onTeamSelected,
  });

  @override
  TeamSearchDialogState createState() => TeamSearchDialogState();
}

class TeamSearchDialogState extends State<TeamSearchDialog> {
  late List<Team> _filteredTeams;
  late List<Team> teamList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    teamList = TeamReader.teams.values.toList();
    _filteredTeams = teamList;
    _searchController.addListener(_filterTeams);
  }

  void _filterTeams() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeams = teamList.where((team) {
        return team.nickname.toLowerCase().contains(query) ||
            team.teamNumber.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Teams',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTeams.length,
                itemBuilder: (context, index) {
                  final team = _filteredTeams[index];
                  return ListTile(
                    title: Text(team.nickname),
                    subtitle: Text('Team ${team.teamNumber}'),
                    onTap: () {
                      widget.onTeamSelected(team);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
