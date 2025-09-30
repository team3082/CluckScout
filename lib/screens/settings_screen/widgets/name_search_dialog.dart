import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/team_reader.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';

class NameSearchDialog extends StatefulWidget {
  const NameSearchDialog({super.key});

  @override
  NameSearchDialogState createState() => NameSearchDialogState();
}

class NameSearchDialogState extends State<NameSearchDialog> {
  late List<String> _filteredNames;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredNames = NameReader.names;
    _searchController.addListener(_filterTeams);
  }

  void _filterTeams() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNames = NameReader.names.where((name) {
        return name.toLowerCase().contains(query);
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
                labelText: 'Search Names',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNames.length,
                itemBuilder: (context, index) {
                  final name = _filteredNames[index];
                  return ListTile(
                    title: Text(name),
                    onTap: () {
                      context
                          .read<MatchScoutingProvider>()
                          .setScouterName(name);
                      context.read<PitScoutingProvider>().setScouterName(name);
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
