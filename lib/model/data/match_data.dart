// 

// References enums.dart (which stores info about what is included in types of actions, ways to be disabled...)
import 'package:cluck_scout/model/enums.dart';

class MatchData {
  // Declares the type of each variable (Ex. int)

  final int matchNumber;
  final int teamNumber;
  final Position position;
  final String scouterName;

  // Auto
  final AutoStatus autoStatus;
  //final List<double> autoHubDurations;
  //final List<int> autoHubTimeStamp; 
  final double autoHub;
  final int autoBump;
  final int autoTrench;

  // Teleop
  //final List<double> teleopHubDurations;
  //final List<int> teleopHubTimeStamp; 
  final double teleopHub;
  final int teleopBump;
  final int teleopTrench;
  
  // Endgame
  final EndStatus endStatus;

  // Final Round Fields
  final Disabled disabled;
  final RobotGoal robotGoal;
  final int defenseRank;
  final int drivingRank;
  final String notes;

  // Requires that some value is passed along for each of the variables
  MatchData({
    required this.matchNumber,
    required this.teamNumber,
    required this.position,
    required this.scouterName,
    required this.autoStatus,
    //required this.autoHubDurations,
    //required this.autoHubTimeStamp,
    required this.autoBump,
    required this.autoTrench,
    required this.autoHub,
    //required this.teleopHubDurations,
    //required this.teleopHubTimeStamp,
    required this.teleopBump,
    required this.teleopTrench,
    required this.teleopHub,
    required this.endStatus,
    required this.disabled,
    required this.robotGoal,
    required this.defenseRank,
    required this.drivingRank,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      // Sets the values on the left (Ex. 'match_number') to the values on the right (Ex. matchNumber)
      'match_number': matchNumber,
      'team_number': teamNumber,
      'position': position.name, 
      'scouter_name': scouterName,
      'auto_L1': autoStatus == AutoStatus.L1 ? 1 : 0,
      //'auto_L2': autoStatus == AutoStatus.L2 ? 1 : 0,
      //'auto_L3': autoStatus == AutoStatus.L3 ? 1 : 0,
      //'auto_Hub_Duration': autoHubDurations,
      //'auto_Hub_Time_Stamp': autoHubTimeStamp,
      'auto_Bump': autoBump,
      'auto_Trench': autoTrench,
      'auto_Hub': autoHub,
      //'teleop_Hub_Duration': teleopHubDurations,
      //'teleop_Hub_Time_Stamp': teleopHubTimeStamp,
      'teleop_Bump': autoBump,
      'teleop_Trench': autoTrench,
      'teleop_Hub': teleopHub,
      'end_none': endStatus == EndStatus.none ? 1 : 0,
      'end_L1': endStatus == EndStatus.L1 ? 1 : 0,
      'end_L2': endStatus == EndStatus.L2 ? 1 : 0,
      'end_L3': endStatus == EndStatus.L3 ? 1 : 0,
      'disabled': disabled.name,
      'robot_Goal': robotGoal.name,
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
          : AutoStatus.none,
          /*: map['auto_L2'] == 1
              ? AutoStatus.L2
              : map['auto_L3'] == 1
                  ? AutoStatus.L3
                  : AutoStatus.none,*/
      //autoHubDurations: List<double>.from(map['auto_Hub_Duration']),
      //autoHubTimeStamp: List<int>.from(map['auto_Hub_Time_Stamp']),
      autoHub: map['auto_Hub'],
      autoBump: map['auto_Bump'],
      autoTrench: map['auto_Trench'],
      //teleopHubDurations: List<double>.from(map['teleop_Hub_Duration']),
      //teleopHubTimeStamp: List<int>.from(map['teleop_Hub_Time_Stamp']),
      teleopBump: map['teleop_Bump'],
      teleopTrench: map['teleop_Trench'],
      teleopHub: map['teleop_Hub'],
      endStatus: map['end_L1'] == 1
          ? EndStatus.L1 
          : map['end_L2'] == 1
              ? EndStatus.L2
              : map['end_L3'] == 1
                  ? EndStatus.L3
                  : EndStatus.none,
      disabled: Disabled.values.firstWhere((e) => e.name == map['disabled']),
      robotGoal: RobotGoal.values.firstWhere((e) => e.name == map['robotGoal']),
      defenseRank: map['defense_rank'],
      drivingRank: map['driving_rank'],
      notes: map['notes'],
    );
  }
}
