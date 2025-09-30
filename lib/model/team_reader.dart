import 'dart:async';

import 'package:flutter/services.dart';

class Team {
  final int teamNumber;
  final String nickname;

  Team({required this.teamNumber, required this.nickname});

  @override
  String toString() {
    return 'Team { teamNumber: $teamNumber, nickname: $nickname }';
  }
}

class TeamReader {
  static Map<int, Team> teams = {};

  static Future<void> readTeamsFromFiles() async {
    try {
      String teamNumbersContent =
          await rootBundle.loadString('assets/team_data/team_numbers.txt');
      String teamNamesContent =
          await rootBundle.loadString('assets/team_data/team_names.txt');

      List<String> teamNumbers = teamNumbersContent.split('\n');
      List<String> teamNames = teamNamesContent.split('\n');

      teams = {};
      for (int i = 0; i < teamNumbers.length; i++) {
        int teamNumber = int.parse(teamNumbers[i]);
        String nickname = teamNames[i];
        teams[teamNumber] = Team(teamNumber: teamNumber, nickname: nickname);
      }

    } catch (e) {
      print("Error reading team files: $e");
    }
  }
}

class NameReader {
  static List<String> names = [];

  static Future<void> readNamesFromFiles() async {
    try {
      String teamNumbersContent =
          await rootBundle.loadString('assets/team_data/team_members.txt');

      names = teamNumbersContent.split("\n");

      for (int index = 0; index < names.length; index++) {
        names[index] = names[index].trim();
      }

      names.sort();
    } catch (e) {
      print("Error reading team files: $e");
    }
  }
}
