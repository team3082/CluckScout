import 'package:cluck_scout/model/enums.dart';

class MatchData {
  final int matchNumber;
  final int teamNumber;
  final Position position;
  final String scouterName;

  // Auto
  final AutoStatus autoStatus;
  final List<double> autoHubDurations;
  final List<double> autoHubTimeStamp; 

  // Teleop
  final List<double> teleopHubDurations;
  final List<double> teleopHubTimeStamp; 
  
  // Endgame
  final EndStatus endStatus;

  // Final Round Fields
  final Disabled disabled;
  final int defenseRank;
  final int drivingRank;
  final String notes;

  MatchData({
    required this.matchNumber,
    required this.teamNumber,
    required this.position,
    required this.scouterName,
    required this.autoStatus,
    required this.autoHubDurations,
    required this.autoHubTimeStamp,
    required this.teleopHubDurations,
    required this.teleopHubTimeStamp,
    required this.endStatus,
    required this.disabled,
    required this.defenseRank,
    required this.drivingRank,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'match_number': matchNumber,
      'team_number': teamNumber,
      'position': position.name, 
      'scouter_name': scouterName,
      'auto_L1': autoStatus == AutoStatus.L1 ? 1 : 0,
      'auto_L2': autoStatus == AutoStatus.L2 ? 1 : 0,
      'auto_L3': autoStatus == AutoStatus.L3 ? 1 : 0,
      'auto_Hub_Duration': autoHubDurations,
      'auto_Hub_Time_Stamp': autoHubTimeStamp,
      'teleop_Hub_Duration': teleopHubDurations,
      'teleop_Hub_Time_Stamp': teleopHubTimeStamp,
      'end_none': endStatus == EndStatus.none ? 1 : 0,
      'end_L1': endStatus == EndStatus.L1 ? 1 : 0,
      'end_L2': endStatus == EndStatus.L2 ? 1 : 0,
      'end_L3': endStatus == EndStatus.L3 ? 1 : 0,
      'disabled': disabled.name,
      'defense_rank': defenseRank,
      'driving_rank': drivingRank,
      'notes': notes,
    };
  }

  factory MatchData.fromMap(Map<String, dynamic> map) {
    return MatchData(
      matchNumber: map['match_number'],
      teamNumber: map['team_number'],
      position: Position.values.firstWhere((e) => e.name == map['position']),
      scouterName: map['scouter_name'],
      autoStatus: map['auto_L1'] == 1
          ? AutoStatus.L1 
          : map['auto_L2'] == 1
              ? AutoStatus.L2
              : map['auto_L3'] == 1
                  ? AutoStatus.L3
                  : AutoStatus.none,
      // Added List.from to ensure type safety
      autoHubDurations: List<double>.from(map['auto_Hub_Duration']),
      autoHubTimeStamp: List<double>.from(map['auto_Hub_Time_Stamp']),
      teleopHubDurations: List<double>.from(map['teleop_Hub_Duration']),
      teleopHubTimeStamp: List<double>.from(map['teleop_Hub_Time_Stamp']),
      endStatus: map['end_L1'] == 1
          ? EndStatus.L1 
          : map['end_L2'] == 1
              ? EndStatus.L2
              : map['end_L3'] == 1
                  ? EndStatus.L3
                  : EndStatus.none,
      disabled: Disabled.values.firstWhere((e) => e.name == map['disabled']),
      defenseRank: map['defense_rank'],
      drivingRank: map['driving_rank'],
      notes: map['notes'],
    );
  }
}
