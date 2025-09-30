import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/team_reader.dart';
import 'package:cluck_scout/providers/upload_provider.dart';
import 'package:cluck_scout/services/database_service.dart';
import 'package:cluck_scout/screens/data_screen/widgets/upload_button.dart';

class PitDataPage extends StatefulWidget {
  const PitDataPage({super.key});

  @override
  State<PitDataPage> createState() => _PitDataPageState();
}

class _PitDataPageState extends State<PitDataPage> {
  List<Map<String, dynamic>> pitDataList = [];
  UploadProvider? _provider;

  @override
  void initState() {
    super.initState();
    fetchPitData();
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
    fetchPitData();
  }

  Future<void> fetchPitData() async {
    final data = await DatabaseService.instance.getAllPitData();
    if (mounted) {
      setState(() {
        pitDataList = data;
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
            const Icon(Icons.build, size: 30),
            const Text(
              " Pit Records",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const UploadToRoostButton(),
            const SizedBox(width: 2),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: pitDataList.isEmpty
              ? const Center(
                  child: Text(
                    'No pit data scouted yet',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: pitDataList.length,
                  itemBuilder: (context, index) {
                    final pit = pitDataList[index];
                    return PitRecordCard(
                      pit: pit,
                      getTeamName: _getTeamName,
                      onDismissed: () async {
                        setState(() {
                          pitDataList.removeWhere((p) => p['doc_ID'] == pit['doc_ID']);
                        });
                        await DatabaseService.instance.deletePitData(pit['doc_ID']);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class PitRecordCard extends StatelessWidget {
  final Map<String, dynamic> pit;
  final String Function(int) getTeamName;
  final VoidCallback onDismissed;

  const PitRecordCard({
    super.key,
    required this.pit,
    required this.getTeamName,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Dismissible(
        key: Key(pit['doc_ID']),
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
                  "Do you want to delete ${getTeamName(pit['team_number'])}'s pit data?",
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
          color: pit['is_uploaded'] == 1
              ? const Color.fromARGB(255, 222, 225, 233)
              : const Color.fromARGB(255, 243, 243, 243),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              getTeamName(pit['team_number']),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Scouted by ${pit['scouter_name']}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}