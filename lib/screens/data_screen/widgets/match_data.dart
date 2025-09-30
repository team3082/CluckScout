import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/team_reader.dart';
import 'package:cluck_scout/providers/upload_provider.dart';
import 'package:cluck_scout/screens/data_screen/widgets/upload_button.dart';
import 'package:cluck_scout/services/database_service.dart';

class MatchDataPage extends StatefulWidget {
  const MatchDataPage({super.key});

  @override
  State<MatchDataPage> createState() => _MatchDataPageState();
}

class _MatchDataPageState extends State<MatchDataPage> {
  List<Map<String, dynamic>> matchDataList = [];
  UploadProvider? _provider;

  @override
  void initState() {
    super.initState();
    fetchMatchData();
    // Set up listener after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<UploadProvider>(context, listen: false);
      _provider?.addListener(_onDataChanged);
    });
  }

  @override
  void dispose() {
    _provider?.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    fetchMatchData();
  }

  Future<void> fetchMatchData() async {
    final data = await DatabaseService.instance.getAllMatchData();
    if (mounted) {
      setState(() {
        matchDataList = data;
      });
    }
  }

  String _getTeamName(int teamNumber) {
    List<Team> teams = TeamReader.teams.values.toList();
    for (Team team in teams) {
      if (team.teamNumber == teamNumber) {
        return team.nickname;
      }
    }
    return "Not a valid team";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.videogame_asset, size: 30),
            const Text(
              " Match Records",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const UploadToRoostButton(),
            const SizedBox(width: 2),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: matchDataList.isEmpty
              ? const Center(
                  child: Text(
                    'No match data scouted yet',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: matchDataList.length,
                  itemBuilder: (context, index) {
                    final match = matchDataList[index];
                    return MatchRecordCard(
                      match: match,
                      getTeamName: _getTeamName,
                      onDismissed: () async {
                        setState(() {
                          matchDataList.removeWhere((m) => m['doc_ID'] == match['doc_ID']);
                        });
                        await DatabaseService.instance.deleteMatch(match['doc_ID']);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class MatchRecordCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final String Function(int) getTeamName;
  final VoidCallback onDismissed;

  const MatchRecordCard({
    super.key,
    required this.match,
    required this.getTeamName,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Dismissible(
        key: Key(match['doc_ID']),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(50, 50, 124, 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 50),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                content: Text(
                  "Do you want to delete ${getTeamName(match['team_number'])}'s ${match["match_number"]}th match?",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Color.fromRGBO(50, 50, 124, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (_) => onDismissed(),
        child: Card(
          color: match['is_uploaded'] == 1
              ? const Color.fromARGB(255, 222, 225, 233)
              : const Color.fromARGB(255, 243, 243, 243),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              getTeamName(match['team_number']),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scouted by ${match['scouter_name']}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Round ${match['match_number']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}